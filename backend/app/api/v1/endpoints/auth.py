import uuid
from datetime import datetime, timezone
from pydantic import BaseModel
from fastapi import APIRouter, Depends, Response, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
import httpx

from ....core.config import get_settings
from ....core.database import get_db
from ....models.child import Child
from ....schemas.child import ChildOut, ChildGradeUpdate
from ....middleware.auth import require_child

router = APIRouter()


class CreateProfileBody(BaseModel):
    name: str
    grade_id: uuid.UUID
    user_id: str   # Supabase auth.users.id (sub claim)
    email: str


@router.post("/create-profile", response_model=ChildOut, status_code=status.HTTP_201_CREATED)
async def create_profile(
    body: CreateProfileBody,
    db: AsyncSession = Depends(get_db),
):
    """
    Called by the frontend immediately after supabase.auth.signUp() returns a session.
    Creates the children row linked to the Supabase user.
    Idempotent: returns existing profile if already created.
    """
    existing = await db.scalar(select(Child).where(Child.user_id == body.user_id))
    if existing:
        return existing

    child = Child(
        name=body.name,
        grade_id=body.grade_id,
        user_id=body.user_id,
        email=body.email,
    )
    db.add(child)
    await db.commit()
    await db.refresh(child)
    return child


@router.get("/me", response_model=ChildOut)
async def get_me(child: Child = Depends(require_child)):
    """Returns the authenticated child's profile."""
    return child


@router.put("/me/grade", response_model=ChildOut)
async def update_grade(
    body: ChildGradeUpdate,
    child: Child = Depends(require_child),
    db: AsyncSession = Depends(get_db),
):
    child.grade_id = body.grade_id
    db.add(child)
    await db.commit()
    await db.refresh(child)
    return child


@router.delete("/account", status_code=status.HTTP_204_NO_CONTENT)
async def delete_own_account(
    child: Child = Depends(require_child),
    db: AsyncSession = Depends(get_db),
):
    """
    Soft-delete the authenticated child's account.
    Sets is_active=False and deleted_at=now. The Supabase auth account
    is NOT deleted so the user can be reactivated by an admin.
    All session data is preserved.
    """
    child.is_active = False
    child.deleted_at = datetime.now(timezone.utc)
    db.add(child)
    await db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
