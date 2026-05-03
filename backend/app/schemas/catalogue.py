import uuid
from pydantic import BaseModel, ConfigDict


class TestTypeOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    code: str
    description: str | None
    icon: str | None


class SubjectOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    code: str
    test_type_id: uuid.UUID
    description: str | None
    display_order: int


class GradeOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    code: str
    level: int


class TopicOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    subject_id: uuid.UUID
    grade_id: uuid.UUID
    description: str | None
    display_order: int
