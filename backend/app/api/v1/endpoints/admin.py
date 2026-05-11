import uuid
from datetime import datetime
from fastapi import APIRouter, Depends, Response, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
import httpx

from ....core.config import get_settings
from ....core.database import get_db
from ....models.child import Child
from ....models.session import TestSession
from ....schemas.child import ChildAdminOut, AdminStatusUpdate, AdminAccountTypeUpdate
from ....middleware.auth import require_admin

router = APIRouter()


@router.get("/users", response_model=list[ChildAdminOut])
async def list_users(
    skip: int = 0,
    limit: int = 100,
    role: str | None = None,
    account_type: str | None = None,
    is_active: bool | None = None,
    db: AsyncSession = Depends(get_db),
    _admin: Child = Depends(require_admin),
):
    """List all registered children with optional filters."""
    q = select(Child).order_by(Child.created_at.desc())
    if role:
        q = q.where(Child.role == role)
    if account_type:
        q = q.where(Child.account_type == account_type)
    if is_active is not None:
        q = q.where(Child.is_active == is_active)
    result = await db.execute(q.offset(skip).limit(limit))
    return result.scalars().all()


@router.get("/stats")
async def admin_stats(
    db: AsyncSession = Depends(get_db),
    _admin: Child = Depends(require_admin),
):
    """High-level platform statistics for the admin dashboard."""
    total_users = await db.scalar(select(func.count()).select_from(Child).where(Child.user_id.isnot(None)))
    active_users = await db.scalar(select(func.count()).select_from(Child).where(Child.is_active == True, Child.user_id.isnot(None)))
    trial_users = await db.scalar(select(func.count()).select_from(Child).where(Child.account_type == "trial", Child.user_id.isnot(None)))
    standard_users = await db.scalar(select(func.count()).select_from(Child).where(Child.account_type == "standard", Child.user_id.isnot(None)))
    total_sessions = await db.scalar(select(func.count()).select_from(TestSession))
    completed_sessions = await db.scalar(select(func.count()).select_from(TestSession).where(TestSession.status == "completed"))

    return {
        "total_users": total_users or 0,
        "active_users": active_users or 0,
        "disabled_users": (total_users or 0) - (active_users or 0),
        "trial_users": trial_users or 0,
        "standard_users": standard_users or 0,
        "total_sessions": total_sessions or 0,
        "completed_sessions": completed_sessions or 0,
    }


@router.get("/users/{user_id}", response_model=ChildAdminOut)
async def get_user(
    user_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    _admin: Child = Depends(require_admin),
):
    child = await db.get(Child, user_id)
    if not child:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="User not found")
    return child


@router.patch("/users/{user_id}/status", response_model=ChildAdminOut)
async def set_user_status(
    user_id: uuid.UUID,
    body: AdminStatusUpdate,
    db: AsyncSession = Depends(get_db),
    admin: Child = Depends(require_admin),
):
    """Enable or disable a user account. Enabling also clears deleted_at."""
    child = await db.get(Child, user_id)
    if not child:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="User not found")
    if child.id == admin.id:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="Cannot disable your own admin account")
    child.is_active = body.is_active
    if body.is_active:
        child.deleted_at = None  # clear soft-delete when reactivating
    db.add(child)
    await db.commit()
    await db.refresh(child)
    return child


@router.patch("/users/{user_id}/account-type", response_model=ChildAdminOut)
async def set_account_type(
    user_id: uuid.UUID,
    body: AdminAccountTypeUpdate,
    db: AsyncSession = Depends(get_db),
    _admin: Child = Depends(require_admin),
):
    """Change a user's account type (trial → standard, etc.)."""
    child = await db.get(Child, user_id)
    if not child:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="User not found")
    if body.account_type not in ("trial", "standard"):
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="account_type must be 'trial' or 'standard'")
    child.account_type = body.account_type
    child.trial_expires_at = body.trial_expires_at
    db.add(child)
    await db.commit()
    await db.refresh(child)
    return child


@router.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def admin_delete_user(
    user_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    admin: Child = Depends(require_admin),
):
    """Permanently delete any user account (admin only)."""
    child = await db.get(Child, user_id)
    if not child:
        return Response(status_code=status.HTTP_204_NO_CONTENT)
    if child.id == admin.id:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="Cannot delete your own account from admin panel")

    await _delete_supabase_user(child.user_id)
    await db.delete(child)
    await db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


async def _delete_supabase_user(user_id: str | None) -> None:
    if not user_id:
        return
    settings = get_settings()
    if not settings.SUPABASE_URL or not settings.SUPABASE_SERVICE_ROLE_KEY:
        return
    async with httpx.AsyncClient() as client:
        await client.delete(
            f"{settings.SUPABASE_URL.rstrip('/')}/auth/v1/admin/users/{user_id}",
            headers={
                "apikey": settings.SUPABASE_SERVICE_ROLE_KEY,
                "Authorization": f"Bearer {settings.SUPABASE_SERVICE_ROLE_KEY}",
            },
            timeout=10,
        )
