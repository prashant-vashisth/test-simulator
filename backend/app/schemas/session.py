import uuid
from datetime import datetime
from pydantic import BaseModel, ConfigDict, field_validator


class SessionCreate(BaseModel):
    child_id: uuid.UUID
    test_type_id: uuid.UUID
    subject_id: uuid.UUID
    grade_id: uuid.UUID
    difficulty: str
    num_questions: int

    @field_validator("difficulty")
    @classmethod
    def validate_difficulty(cls, v: str) -> str:
        if v not in ("easy", "medium", "hard"):
            raise ValueError("difficulty must be easy, medium, or hard")
        return v

    @field_validator("num_questions")
    @classmethod
    def validate_num_questions(cls, v: int) -> int:
        if not (5 <= v <= 100):
            raise ValueError("num_questions must be between 5 and 100")
        return v


class SessionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    child_id: uuid.UUID
    test_type_id: uuid.UUID
    subject_id: uuid.UUID
    grade_id: uuid.UUID
    difficulty: str
    total_questions: int
    started_at: datetime
    ended_at: datetime | None
    status: str
    correct_count: int
    score_percentage: float | None
    interruption_count: int


class SessionSummaryOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    started_at: datetime
    ended_at: datetime | None
    status: str
    difficulty: str
    total_questions: int
    correct_count: int
    score_percentage: float | None
    # Enriched fields
    test_type_name: str | None = None
    subject_name: str | None = None
    grade_name: str | None = None


class AnswerSubmit(BaseModel):
    question_id: uuid.UUID
    selected_option_ids: list[uuid.UUID] = []
    time_taken_seconds: int | None = None
    writing_response: str | None = None


class AnswerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    question_id: uuid.UUID
    question_order: int
    selected_option_ids: list[uuid.UUID] | None
    is_correct: bool | None
    time_taken_seconds: int | None
    writing_response: str | None = None
    groq_feedback: dict | None = None
    answered_at: datetime


class TopicPerformanceOut(BaseModel):
    topic_id: uuid.UUID
    topic_name: str
    total_attempts: int
    correct_attempts: int
    accuracy_percent: float
    last_attempted_at: datetime | None
