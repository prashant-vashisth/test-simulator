import uuid
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class ChildOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    avatar_url: str | None
    display_order: int
    email: str | None = None
    grade_id: uuid.UUID | None = None
    is_active: bool = True
    role: str = "student"
    account_type: str = "trial"
    trial_expires_at: datetime | None = None


class ChildAdminOut(ChildOut):
    """Extended view for admin endpoints — includes all fields."""
    created_at: datetime
    deleted_at: datetime | None = None


class ChildUpdate(BaseModel):
    avatar_url: str | None = None


class ChildRegister(BaseModel):
    name: str
    grade_id: uuid.UUID


class ChildGradeUpdate(BaseModel):
    grade_id: uuid.UUID


class AdminStatusUpdate(BaseModel):
    is_active: bool


class AdminAccountTypeUpdate(BaseModel):
    account_type: str          # trial | standard
    trial_expires_at: datetime | None = None
