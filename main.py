from config.settings import get_settings
from src.api.app import create_app
import uvicorn

settings = get_settings()

app = create_app()

if __name__ == "__main__":
    settings = get_settings()
    uvicorn.run("main:app", host=settings.api_host, port=settings.api_port)

