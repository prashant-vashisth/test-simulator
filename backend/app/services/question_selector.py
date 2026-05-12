"""
Question selection service.

Strategy:
1. Fetch all topics for the chosen subject + grade.
2. Distribute `num_questions` proportionally across topics (every topic gets ≥1 Q).
3. Within each topic, sample questions according to a difficulty distribution
   that matches the user-selected difficulty level.
4. Sort the final list progressively: easier questions first, harder ones last
   so the test challenge escalates naturally.
"""

import random
import uuid
from collections import defaultdict

from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.catalogue import Topic
from ..models.question import Question

# How many questions of each difficulty to sample per topic slot
DIFFICULTY_DISTRIBUTION: dict[str, dict[str, float]] = {
    "easy":   {"easy": 0.70, "medium": 0.25, "hard": 0.05},
    "medium": {"easy": 0.20, "medium": 0.55, "hard": 0.25},
    "hard":   {"easy": 0.05, "medium": 0.30, "hard": 0.65},
}

DIFFICULTY_ORDER = {"easy": 0, "medium": 1, "hard": 2}


async def select_questions(
    *,
    db: AsyncSession,
    test_type_id: uuid.UUID,
    subject_id: uuid.UUID,
    grade_id: uuid.UUID,
    difficulty: str,
    num_questions: int,
) -> list[Question]:
    # 1. Fetch all topics for this subject + grade
    topic_rows = (
        await db.execute(
            select(Topic).where(
                Topic.subject_id == subject_id,
                Topic.grade_id == grade_id,
            ).order_by(Topic.display_order)
        )
    ).scalars().all()

    if not topic_rows:
        return []

    # 2. Build a pool of candidate question IDs per topic per difficulty
    pool: dict[uuid.UUID, dict[str, list[uuid.UUID]]] = defaultdict(lambda: defaultdict(list))

    rows = (
        await db.execute(
            select(Question.id, Question.topic_id, Question.difficulty)
            .where(
                Question.test_type_id == test_type_id,
                Question.grade_id == grade_id,
                Question.topic_id.in_([t.id for t in topic_rows]),
                Question.is_active.is_(True),
            )
        )
    ).all()

    for q_id, t_id, diff in rows:
        pool[t_id][diff].append(q_id)

    # 3. Distribute num_questions across topics
    n_topics = len(topic_rows)
    base, remainder = divmod(num_questions, n_topics)
    quotas = [base + (1 if i < remainder else 0) for i in range(n_topics)]

    dist = DIFFICULTY_DISTRIBUTION[difficulty]

    selected_ids: list[tuple[uuid.UUID, str]] = []  # (question_id, difficulty)

    for topic, quota in zip(topic_rows, quotas):
        if quota == 0:
            continue
        topic_pool = pool.get(topic.id, {})
        topic_selected: list[tuple[uuid.UUID, str]] = []

        for diff_level, fraction in dist.items():
            n_needed = round(quota * fraction)
            candidates = topic_pool.get(diff_level, [])
            sampled = random.sample(candidates, min(n_needed, len(candidates)))
            topic_selected.extend((qid, diff_level) for qid in sampled)

        # If we got fewer than quota due to sparse data, fill with any available
        already = {qid for qid, _ in topic_selected}
        all_candidates = [
            (qid, diff) for diff, ids in topic_pool.items() for qid in ids if qid not in already
        ]
        shortfall = quota - len(topic_selected)
        if shortfall > 0 and all_candidates:
            extras = random.sample(all_candidates, min(shortfall, len(all_candidates)))
            topic_selected.extend(extras)

        selected_ids.extend(topic_selected[:quota])

    if not selected_ids:
        return []

    # 4. Progressive sort: first ~33% easy, middle ~34% medium, last ~33% hard
    selected_ids.sort(key=lambda x: DIFFICULTY_ORDER[x[1]])
    # Shuffle within each difficulty band for variety
    grouped: dict[str, list[uuid.UUID]] = defaultdict(list)
    for qid, diff in selected_ids:
        grouped[diff].append(qid)
    for diff in grouped:
        random.shuffle(grouped[diff])

    ordered_ids = (
        grouped.get("easy", [])
        + grouped.get("medium", [])
        + grouped.get("hard", [])
    )
    ordered_ids = ordered_ids[:num_questions]

    # 5. Fetch full Question objects with options eagerly loaded
    result = await db.execute(
        select(Question)
        .where(Question.id.in_(ordered_ids))
        .options(selectinload(Question.options))
    )
    questions_unordered = result.scalars().all()

    # Sort in Python to the desired progressive-difficulty order
    id_order = {qid: idx for idx, qid in enumerate(ordered_ids)}
    return sorted(questions_unordered, key=lambda q: id_order.get(q.id, 999))
