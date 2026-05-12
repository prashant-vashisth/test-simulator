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
# Path works both locally and on Render regardless of rootDir
FRONTEND_DIST = Path(__file__).resolve().parents[3] / "frontend" / "dist"


@app.on_event("startup")
async def _check_frontend():
    if FRONTEND_DIST.exists():
        app.mount(
            "/assets",
            StaticFiles(directory=str(FRONTEND_DIST / "assets")),
            name="assets",
        )


@app.get("/{full_path:path}", include_in_schema=False)
async def serve_spa(full_path: str) -> FileResponse:
    """Catch-all: serve the React SPA for any non-API route."""
    requested = FRONTEND_DIST / full_path
    if requested.is_file():
        return FileResponse(str(requested))
    return FileResponse(str(FRONTEND_DIST / "index.html"))
