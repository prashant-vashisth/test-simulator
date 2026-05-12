from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles

from .core.config import get_settings
from .api.v1.router import router as api_v1_router

settings = get_settings()

app = FastAPI(
    title="Test Simulator API",
    version="1.0.0",
    docs_url="/docs" if not settings.is_production else None,
    redoc_url=None,
)

# ── API routes ────────────────────────────────────────────────────────────────
app.include_router(api_v1_router, prefix=settings.API_V1_PREFIX)


@app.get("/health", tags=["health"])
async def health() -> JSONResponse:
    return JSONResponse({"status": "ok"})


# ── Serve React frontend ──────────────────────────────────────────────────────
def _find_frontend_dist() -> Path:
    """
    Walk up from this file looking for frontend/dist.
    Works in Docker (/app/frontend/dist) and Render native (/opt/.../frontend/dist).
    """
    here = Path(__file__).resolve()
    for parent in here.parents:
        candidate = parent / "frontend" / "dist"
        if candidate.exists():
            return candidate
    return here.parent / "frontend" / "dist"   # fallback (won't exist)


FRONTEND_DIST = _find_frontend_dist()

if FRONTEND_DIST.exists():
    app.mount(
        "/assets",
        StaticFiles(directory=str(FRONTEND_DIST / "assets")),
        name="assets",
    )


@app.get("/{full_path:path}", include_in_schema=False)
async def serve_spa(full_path: str) -> FileResponse:
    """Catch-all: serve a file from dist if it exists, otherwise index.html."""
    if full_path:
        requested = FRONTEND_DIST / full_path
        if requested.is_file():
            return FileResponse(str(requested))
    return FileResponse(str(FRONTEND_DIST / "index.html"))
