from fastapi import APIRouter
from .endpoints import children, catalogue, sessions, auth, admin

router = APIRouter()
router.include_router(auth.router,      prefix="/auth",      tags=["auth"])
router.include_router(admin.router,     prefix="/admin",     tags=["admin"])
router.include_router(children.router,  prefix="/children",  tags=["children"])
router.include_router(catalogue.router, prefix="/catalogue", tags=["catalogue"])
router.include_router(sessions.router,  prefix="/sessions",  tags=["sessions"])
