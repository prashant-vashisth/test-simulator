"""
Excel → validated dict list parser.

Expected sheet columns (case-insensitive, order doesn't matter):
  test_type       | nwea_map / math_olympiad / science_olympiad
  subject         | math / english_reading / english_writing / reading / …
  grade           | K / 1 / 2 / … / 12
  topic           | free text
  question        | free text (may be long)
  passage         | optional – reading comprehension context
  type            | single / multiple / open_ended  (default: single)
  difficulty      | easy / medium / hard  (default: medium)
  points          | integer  (default: 1)
  explanation     | optional
  writing_rubric  | optional – grading guidance for open_ended questions
  option_a        | required for single/multiple
  option_b        | required for single/multiple
  option_c        | optional
  option_d        | optional
  option_e        | optional
  correct         | comma-separated labels – not required for open_ended
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any

import pandas as pd


REQUIRED_COLUMNS = {"test_type", "subject", "grade", "topic", "question"}

VALID_TEST_TYPES = {"nwea_map", "math_olympiad", "science_olympiad"}
VALID_DIFFICULTIES = {"easy", "medium", "hard"}
VALID_QUESTION_TYPES = {"single", "multiple", "open_ended", "single_choice", "multiple_choice"}

OPTION_LABELS = ["A", "B", "C", "D", "E"]


def _normalise_columns(df: pd.DataFrame) -> pd.DataFrame:
    df.columns = [str(c).strip().lower().replace(" ", "_") for c in df.columns]
    return df


def _to_question_type(raw: Any) -> str:
    val = str(raw).strip().lower()
    if val in ("multiple", "multiple_choice"):
        return "multiple_choice"
    if val == "open_ended":
        return "open_ended"
    return "single_choice"


def _to_difficulty(raw: Any) -> str:
    val = str(raw).strip().lower()
    return val if val in VALID_DIFFICULTIES else "medium"


def _parse_correct(raw: Any) -> list[str]:
    return [c.strip().upper() for c in str(raw).split(",") if c.strip()]


def parse_excel(file_path: str | Path) -> tuple[list[dict], list[str]]:
    """
    Returns (rows, errors).
    Each row dict has keys: test_type, subject, grade, topic, question_text,
    passage, question_type, difficulty, points, explanation, options, source_file, source_row.
    options is a list of {label, text, is_correct}.
    """
    path = Path(file_path)
    errors: list[str] = []
    rows: list[dict] = []

    try:
        df = pd.read_excel(path, engine="openpyxl", dtype=str)
    except Exception as exc:
        return [], [f"Cannot read file: {exc}"]

    df = _normalise_columns(df)
    df = df.dropna(how="all")

    missing = REQUIRED_COLUMNS - set(df.columns)
    if missing:
        return [], [f"Missing required columns: {', '.join(sorted(missing))}"]

    for idx, row in df.iterrows():
        row_num = int(idx) + 2  # Excel row number (1-based header)
        src = f"{path.name}:row{row_num}"

        def cell(col: str, default: str = "") -> str:
            v = row.get(col, default)
            return "" if pd.isna(v) else str(v).strip()

        test_type = cell("test_type").lower()
        if test_type not in VALID_TEST_TYPES:
            errors.append(f"{src}: unknown test_type '{test_type}'")
            continue

        question_text = cell("question")
        if not question_text:
            errors.append(f"{src}: empty question text")
            continue

        question_type = _to_question_type(cell("type", "single"))

        if question_type == "open_ended":
            # open_ended questions have no answer options or correct labels
            rows.append({
                "test_type": test_type,
                "subject": cell("subject").lower(),
                "grade": cell("grade").upper(),
                "topic": cell("topic"),
                "question_text": question_text,
                "passage": cell("passage") or None,
                "question_type": "open_ended",
                "difficulty": _to_difficulty(cell("difficulty", "medium")),
                "points": max(1, int(float(cell("points", "1") or "1"))),
                "explanation": cell("explanation") or None,
                "writing_rubric": cell("writing_rubric") or None,
                "options": [],
                "source_file": path.name,
                "source_row": row_num,
            })
            continue

        correct_labels = _parse_correct(cell("correct"))
        if not correct_labels:
            errors.append(f"{src}: no correct answer specified")
            continue

        options = []
        for label in OPTION_LABELS:
            col = f"option_{label.lower()}"
            text = cell(col)
            if text:
                options.append({
                    "label": label,
                    "text": text,
                    "is_correct": label in correct_labels,
                })

        if len(options) < 2:
            errors.append(f"{src}: fewer than 2 options")
            continue

        rows.append({
            "test_type": test_type,
            "subject": cell("subject").lower(),
            "grade": cell("grade").upper(),
            "topic": cell("topic"),
            "question_text": question_text,
            "passage": cell("passage") or None,
            "question_type": question_type,
            "difficulty": _to_difficulty(cell("difficulty", "medium")),
            "points": max(1, int(float(cell("points", "1") or "1"))),
            "explanation": cell("explanation") or None,
            "writing_rubric": None,
            "options": options,
            "source_file": path.name,
            "source_row": row_num,
        })

    return rows, errors
