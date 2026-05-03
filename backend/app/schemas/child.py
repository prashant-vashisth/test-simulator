import uuid
from pydantic import BaseModel, ConfigDict


class ChildOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str
    avatar_url: str | None
    display_order: int


class ChildUpdate(BaseModel):
    avatar_url: str | None = None
