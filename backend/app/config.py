from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional

class Settings(BaseSettings):
    app_name: str = "StyleMirror API"
    environment: str = "development"
    debug: bool = False
    
    # AI Providers & Keys
    gemini_api_keys: str = ""
    ai_provider: str = "gemini"
    ai_fallback_provider: str = "mock"
    
    # Database & Storage
    database_url: str = "sqlite:///./stylemirror.db"
    storage_dir: str = "./storage"
    
    # Limits & Security
    secret_key: str = "stylemirror-dev-secret-key-32chars"
    allowed_origin: str = "*"
    daily_generation_cap: int = 50
    rate_limit_per_minute: int = 20
    photo_ttl_hours: int = 24

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

settings = Settings()

