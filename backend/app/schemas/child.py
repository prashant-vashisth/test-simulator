import uuid
from pydantic import BaseModel, ConfigDict, EmailStr


class ChildOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    avatar_url: str | None
    display_order: int
    email: str | None = None
    grade_id: uuid.UUID | None = None


class ChildUpdate(BaseModel):
    avatar_url: str | None = None


class ChildRegister(BaseModel):
    """Sent to POST /auth/register after Supabase signUp succeeds."""
    name: str
    grade_id: uuid.UUID


class ChildGradeUpdate(BaseModel):
    grade_id: uuid.UUID
