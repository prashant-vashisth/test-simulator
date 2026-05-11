from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    # Database
    DATABASE_URL: str

    # Supabase (used by pipeline; API uses DATABASE_URL directly)
    SUPABASE_URL: str = ""
    SUPABASE_SERVICE_ROLE_KEY: str = ""

    # Security
    SECRET_KEY: str = "change-me"
    ALLOWED_ORIGINS: str = "http://localhost:5173"

    # Supabase Auth JWT verification
    SUPABASE_JWT_SECRET: str = ""

    # Groq AI (writing feedback)
    GROQ_API_KEY: str = ""

    # App
    ENVIRONMENT: str = "development"
    API_V1_PREFIX: str = "/api/v1"

    @property
    def allowed_origins_list(self) -> list[str]:
        return [o.strip() for o in self.ALLOWED_ORIGINS.split(",")]

    @property
    def is_production(self) -> bool:
        return self.ENVIRONMENT == "production"


@lru_cache
def get_settings() -> Settings:
    return Settings()
