from uuid import UUID
from typing import Optional

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.config import get_settings
from ..core.database import get_db
from ..models.child import Child

security = HTTPBearer(auto_error=False)


async def get_current_child(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security),
    db: AsyncSession = Depends(get_db),
) -> Optional[Child]:
    """
    Verify a Supabase JWT and return the matching Child row.
    Returns None (not 401) so endpoints can decide whether auth is required.
    """
    if not credentials:
        return None

    settings = get_settings()
    if not settings.SUPABASE_JWT_SECRET:
        return None

    try:
        payload = jwt.decode(
            credentials.credentials,
            settings.SUPABASE_JWT_SECRET,
            algorithms=["HS256"],
            audience="authenticated",
        )
    except jwt.InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )

    user_id: str = payload.get("sub", "")
    if not user_id:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token claims")

    child = await db.scalar(select(Child).where(Child.user_id == user_id))
    if child is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No child profile found for this account",
        )
    return child


async def require_child(
    child: Optional[Child] = Depends(get_current_child),
) -> Child:
    """Hard-require an authenticated child; raise 401 if missing."""
    if child is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
        )
    return child
