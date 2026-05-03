"""
Validates parsed rows against known DB catalogue data (test types, subjects, grades, topics).
Can either warn (and auto-create missing topics) or hard-fail.
"""

from __future__ import annotations


VALID_TEST_TYPES = {"nwea_map", "math_olympiad", "science_olympiad"}
VALID_GRADES = {"K", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"}


def validate_rows(rows: list[dict]) -> tuple[list[dict], list[str]]:
    """
    Returns (valid_rows, warnings).
    Warnings are non-fatal; the rows are still included.
    """
    valid: list[dict] = []
    warnings: list[str] = []

    for row in rows:
        src = f"{row.get('source_file')}:row{row.get('source_row')}"
        ok = True

        if row["test_type"] not in VALID_TEST_TYPES:
            warnings.append(f"{src}: unknown test_type '{row['test_type']}' – skipped")
            ok = False

        if row["grade"] not in VALID_GRADES:
            warnings.append(f"{src}: unknown grade '{row['grade']}' – skipped")
            ok = False

        if not row["topic"]:
            warnings.append(f"{src}: empty topic – will create 'General' topic")
            row["topic"] = "General"

        if not row["subject"]:
            warnings.append(f"{src}: empty subject – skipped")
            ok = False

        if ok:
            valid.append(row)

    return valid, warnings
