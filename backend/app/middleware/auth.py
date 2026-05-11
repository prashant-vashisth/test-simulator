from uuid import UUID
from typing import Optional

import jwt
from jwt import PyJWKClient
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..core.config import get_settings
from ..core.database import get_db
from ..models.child import Child

security = HTTPBearer(auto_error=False)

# Module-level JWKS client — caches the public key so it's only fetched once
# (PyJWKClient has built-in TTL-based cache)
_jwks_client: Optional[PyJWKClient] = None


def _get_jwks_client() -> PyJWKClient:
    global _jwks_client
    if _jwks_client is None:
        settings = get_settings()
        if not settings.SUPABASE_URL:
            raise ValueError("SUPABASE_URL is required for JWT verification")
        _jwks_client = PyJWKClient(
            f"{settings.SUPABASE_URL.rstrip('/')}/auth/v1/.well-known/jwks.json",
            cache_jwk_set=True,
            lifespan=3600,  # re-fetch public key at most once per hour
        )
    return _jwks_client


async def get_current_child(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security),
    db: AsyncSession = Depends(get_db),
) -> Optional[Child]:
    """
    Verify a Supabase JWT (ECC P-256 or legacy HS256) via JWKS and return the
    matching Child row. Returns None instead of raising so endpoints can decide
    whether auth is mandatory.
    """
    if not credentials:
        return None

    settings = get_settings()
    if not settings.SUPABASE_URL:
        return None

    token = credentials.credentials
    try:
        jwks_client = _get_jwks_client()
        signing_key = jwks_client.get_signing_key_from_jwt(token)
        payload = jwt.decode(
            token,
            signing_key.key,
            algorithms=["ES256", "RS256", "HS256"],
            audience="authenticated",
        )
    except Exception:
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
