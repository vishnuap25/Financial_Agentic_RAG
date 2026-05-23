from fastapi import FastAPI
from config.settings import get_settings

def create_app()->FastAPI:
    setting = get_settings()
    app = FastAPI(
        tiltle=setting.api_service_title,
        version=setting.api_version
    )

    @app.get("/health")
    async def health_check():
        return {"status": "healthy"}
    
    @app.post("/chat")
    async def chat_endpoint():
        return {"message": "Chat endpoint"}
    
    return app