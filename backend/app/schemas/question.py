import uuid
from pydantic import BaseModel, ConfigDict


class AnswerOptionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    option_label: str
    option_text: str
    display_order: int
    # is_correct intentionally omitted — never sent to client during test


class AnswerOptionWithCorrect(AnswerOptionOut):
    """Used only in post-test result reveals."""
    is_correct: bool


class QuestionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    topic_id: uuid.UUID
    grade_id: uuid.UUID
    test_type_id: uuid.UUID
    question_text: str
    passage: str | None
    image_url: str | None
    question_type: str
    difficulty: str
    points: int
    options: list[AnswerOptionOut]


class QuestionWithAnswers(QuestionOut):
    """Returned after test completion — includes correct flags and explanation."""
    explanation: str | None
    options: list[AnswerOptionWithCorrect]
