from pathlib import Path
from pydantic import BaseModel
from pydantic_settings import BaseSettings
from django.conf import settings as django_settings


class AuthJWT(BaseModel):
    private_key_path: Path = django_settings.BASE_DIR / "certs" / "jwt-private.pem"
    public_key_path: Path = django_settings.BASE_DIR / "certs" / "jwt-public.pem"
    algorithm: str = "RS256"
    access_token_expire_minutes: int = 5


class Settings(BaseSettings):
    auth_jwt: AuthJWT = AuthJWT()


settings = Settings()
