"""
Loads validated question rows into PostgreSQL.

Strategy:
- Looks up test_type, subject, grade, topic by code/name.
- Creates missing topics automatically (warns, does not create subjects/test_types).
- Upserts questions by (topic_id, question_text) to avoid duplicates on re-run.
- Inserts answer options fresh each time (deletes old ones first on upsert).
"""

from __future__ import annotations

import uuid
from typing import Any

import psycopg2
import psycopg2.extras

psycopg2.extras.register_uuid()


def _fetch_one(cur: Any, query: str, params: tuple) -> dict | None:
    cur.execute(query, params)
    row = cur.fetchone()
    return dict(row) if row else None


def load_rows(
    *,
    database_url: str,
    rows: list[dict],
    dry_run: bool = False,
) -> dict[str, int]:
    """
    Returns stats: {inserted, updated, skipped, errors}
    database_url must be a standard psycopg2 DSN (not asyncpg format).
    """
    # Convert asyncpg URL format to psycopg2
    dsn = database_url.replace("postgresql+asyncpg://", "postgresql://")

    conn = psycopg2.connect(dsn, cursor_factory=psycopg2.extras.RealDictCursor)
    conn.autocommit = False
    cur = conn.cursor()

    stats = {"inserted": 0, "updated": 0, "skipped": 0, "errors": 0}

    try:
        # Cache lookups to avoid repeated queries
        _test_type_cache: dict[str, uuid.UUID] = {}
        _subject_cache: dict[tuple, uuid.UUID] = {}
        _grade_cache: dict[str, uuid.UUID] = {}
        _topic_cache: dict[tuple, uuid.UUID] = {}

        def get_test_type_id(code: str) -> uuid.UUID | None:
            if code not in _test_type_cache:
                row = _fetch_one(cur, "SELECT id FROM test_types WHERE code = %s", (code,))
                if row:
                    _test_type_cache[code] = row["id"]
            return _test_type_cache.get(code)

        def get_grade_id(grade_code: str) -> uuid.UUID | None:
            if grade_code not in _grade_cache:
                row = _fetch_one(cur, "SELECT id FROM grades WHERE code = %s", (grade_code,))
                if row:
                    _grade_cache[grade_code] = row["id"]
            return _grade_cache.get(grade_code)

        def get_subject_id(code: str, test_type_id: uuid.UUID) -> uuid.UUID | None:
            key = (code, test_type_id)
            if key not in _subject_cache:
                row = _fetch_one(
                    cur,
                    "SELECT id FROM subjects WHERE code = %s AND test_type_id = %s",
                    (code, test_type_id),
                )
                if row:
                    _subject_cache[key] = row["id"]
            return _subject_cache.get(key)

        def get_or_create_topic(name: str, subject_id: uuid.UUID, grade_id: uuid.UUID) -> uuid.UUID:
            key = (name.lower(), subject_id, grade_id)
            if key not in _topic_cache:
                row = _fetch_one(
                    cur,
                    "SELECT id FROM topics WHERE lower(name) = %s AND subject_id = %s AND grade_id = %s",
                    (name.lower(), subject_id, grade_id),
                )
                if row:
                    _topic_cache[key] = row["id"]
                else:
                    new_id = uuid.uuid4()
                    cur.execute(
                        "INSERT INTO topics (id, name, subject_id, grade_id) VALUES (%s, %s, %s, %s)",
                        (new_id, name, subject_id, grade_id),
                    )
                    _topic_cache[key] = new_id
            return _topic_cache[key]

        for row in rows:
            try:
                tt_id = get_test_type_id(row["test_type"])
                if not tt_id:
                    stats["skipped"] += 1
                    continue

                grade_id = get_grade_id(row["grade"])
                if not grade_id:
                    stats["skipped"] += 1
                    continue

                subj_id = get_subject_id(row["subject"], tt_id)
                if not subj_id:
                    stats["skipped"] += 1
                    continue

                topic_id = get_or_create_topic(row["topic"], subj_id, grade_id)

                # Check for existing question with same text in same topic
                existing = _fetch_one(
                    cur,
                    "SELECT id FROM questions WHERE topic_id = %s AND lower(question_text) = lower(%s)",
                    (topic_id, row["question_text"]),
                )

                if existing:
                    q_id = existing["id"]
                    if not dry_run:
                        cur.execute(
                            """UPDATE questions SET
                                question_type = %s, difficulty = %s, points = %s,
                                passage = %s, explanation = %s,
                                source_file = %s, source_row = %s, updated_at = NOW()
                            WHERE id = %s""",
                            (
                                row["question_type"], row["difficulty"], row["points"],
                                row["passage"], row["explanation"],
                                row["source_file"], row["source_row"], q_id,
                            ),
                        )
                        cur.execute("DELETE FROM answer_options WHERE question_id = %s", (q_id,))
                    stats["updated"] += 1
                else:
                    q_id = uuid.uuid4()
                    if not dry_run:
                        cur.execute(
                            """INSERT INTO questions
                                (id, topic_id, grade_id, test_type_id, question_text,
                                 passage, question_type, difficulty, points, explanation,
                                 source_file, source_row)
                            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
                            (
                                q_id, topic_id, grade_id, tt_id, row["question_text"],
                                row["passage"], row["question_type"], row["difficulty"],
                                row["points"], row["explanation"],
                                row["source_file"], row["source_row"],
                            ),
                        )
                    stats["inserted"] += 1

                if not dry_run:
                    for order, opt in enumerate(row["options"]):
                        cur.execute(
                            """INSERT INTO answer_options
                                (id, question_id, option_label, option_text, is_correct, display_order)
                            VALUES (%s,%s,%s,%s,%s,%s)""",
                            (uuid.uuid4(), q_id, opt["label"], opt["text"], opt["is_correct"], order + 1),
                        )

            except Exception as exc:
                stats["errors"] += 1
                conn.rollback()
                print(f"  Row error ({row.get('source_file')}:{row.get('source_row')}): {exc}")
                conn.autocommit = False

        if not dry_run:
            conn.commit()

    finally:
        cur.close()
        conn.close()

    return stats
