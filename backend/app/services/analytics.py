"""
Analytics service: session completion, topic performance upsert, recommendations.
"""

import uuid
from datetime import datetime, timezone

from sqlalchemy import select, update
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from ..models.session import TestSession, SessionAnswer, TopicPerformance
from ..models.question import Question
from ..models.catalogue import Topic
from ..schemas.session import TopicPerformanceOut


async def complete_session(
    *,
    db: AsyncSession,
    session: TestSession,
) -> TestSession:
    """Finalise a session: calculate score, update topic performance."""
    answers = (
        await db.execute(
            select(SessionAnswer).where(SessionAnswer.session_id == session.id)
        )
    ).scalars().all()

    total = len(answers)
    correct = sum(1 for a in answers if a.is_correct)
    score_pct = round((correct / total) * 100, 2) if total > 0 else 0.0

    session.ended_at = datetime.now(timezone.utc)
    session.status = "completed"
    session.correct_count = correct
    session.score_percentage = score_pct
    db.add(session)

    # Upsert topic_performance for each answered question
    await _upsert_topic_performance(db=db, session=session, answers=answers)

    await db.commit()
    await db.refresh(session)
    return session


async def _upsert_topic_performance(
    *,
    db: AsyncSession,
    session: TestSession,
    answers: list[SessionAnswer],
) -> None:
    if not answers:
        return

    question_ids = [a.question_id for a in answers]
    q_rows = (
        await db.execute(select(Question.id, Question.topic_id).where(Question.id.in_(question_ids)))
    ).all()
    topic_by_q = {row.id: row.topic_id for row in q_rows}

    # Group answers by topic
    topic_totals: dict[uuid.UUID, tuple[int, int]] = {}  # topic_id -> (total, correct)
    for answer in answers:
        t_id = topic_by_q.get(answer.question_id)
        if t_id is None:
            continue
        prev_total, prev_correct = topic_totals.get(t_id, (0, 0))
        topic_totals[t_id] = (
            prev_total + 1,
            prev_correct + (1 if answer.is_correct else 0),
        )

    now = datetime.now(timezone.utc)
    for t_id, (total, correct) in topic_totals.items():
        stmt = (
            pg_insert(TopicPerformance)
            .values(
                child_id=session.child_id,
                topic_id=t_id,
                total_attempts=total,
                correct_attempts=correct,
                last_attempted_at=now,
            )
            .on_conflict_do_update(
                index_elements=["child_id", "topic_id"],
                set_={
                    "total_attempts": TopicPerformance.total_attempts + total,
                    "correct_attempts": TopicPerformance.correct_attempts + correct,
                    "last_attempted_at": now,
                    "updated_at": now,
                },
            )
        )
        await db.execute(stmt)


async def get_topic_performance(
    *,
    db: AsyncSession,
    child_id: uuid.UUID,
    subject_id: uuid.UUID | None = None,
    grade_id: uuid.UUID | None = None,
) -> list[TopicPerformanceOut]:
    stmt = (
        select(TopicPerformance, Topic.name.label("topic_name"))
        .join(Topic, Topic.id == TopicPerformance.topic_id)
        .where(TopicPerformance.child_id == child_id)
    )
    if subject_id:
        stmt = stmt.where(Topic.subject_id == subject_id)
    if grade_id:
        stmt = stmt.where(Topic.grade_id == grade_id)

    rows = (await db.execute(stmt)).all()

    return [
        TopicPerformanceOut(
            topic_id=tp.topic_id,
            topic_name=topic_name,
            total_attempts=tp.total_attempts,
            correct_attempts=tp.correct_attempts,
            accuracy_percent=round((tp.correct_attempts / tp.total_attempts) * 100, 1) if tp.total_attempts > 0 else 0.0,
            last_attempted_at=tp.last_attempted_at,
        )
        for tp, topic_name in rows
    ]


def generate_recommendations(performances: list[TopicPerformanceOut]) -> list[str]:
    """Rule-based improvement recommendations based on topic accuracy."""
    if not performances:
        return ["Complete a test to receive personalised recommendations!"]

    weak = [p for p in performances if p.accuracy_percent < 60 and p.total_attempts >= 2]
    improving = [p for p in performances if 60 <= p.accuracy_percent < 80]
    strong = [p for p in performances if p.accuracy_percent >= 80 and p.total_attempts >= 3]

    recs: list[str] = []

    if weak:
        names = ", ".join(p.topic_name for p in sorted(weak, key=lambda x: x.accuracy_percent)[:3])
        recs.append(f"Focus extra practice on: {names}")

    if improving:
        names = ", ".join(p.topic_name for p in improving[:2])
        recs.append(f"You're making progress on {names} — keep practising!")

    if strong:
        names = ", ".join(p.topic_name for p in strong[:2])
        recs.append(f"Excellent mastery in: {names}. Try a harder difficulty!")

    if not recs:
        recs.append("Keep up the great work! Try increasing the difficulty level.")

    return recs
