from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse, Response

from .core.config import get_settings
from .api.v1.router import router as api_v1_router

settings = get_settings()

app = FastAPI(
    title="Test Simulator API",
    version="1.0.0",
    docs_url="/docs" if not settings.is_production else None,
    redoc_url=None,
)

CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, PUT, PATCH, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "Authorization, Content-Type, Accept, X-Requested-With",
    "Access-Control-Max-Age": "86400",
}


@app.middleware("http")
async def cors_middleware(request: Request, call_next):
    # Handle preflight OPTIONS requests immediately — never forward to route handlers
    if request.method == "OPTIONS":
        return Response(status_code=200, headers=CORS_HEADERS)

    response = await call_next(request)
    for key, value in CORS_HEADERS.items():
        response.headers[key] = value
    return response


app.include_router(api_v1_router, prefix=settings.API_V1_PREFIX)


@app.get("/health", tags=["health"])
async def health() -> JSONResponse:
    return JSONResponse({"status": "ok"})
