#!/usr/bin/env bash
set -e

echo "=== Financial Agentic RAG - Local Deploy ==="

# -- Step 1: Ensure curl is installed (needed for health checks)
if ! command -v curl &>/dev/null; then
    echo "[0/5] Installing curl..."
    if [ -f /etc/debian_version ]; then
        sudo apt-get update && sudo apt-get install -y curl
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y curl
    elif command -v brew &>/dev/null; then
        brew install curl
    else
        echo "ERROR: curl not found and cannot auto-install. Please install curl manually."
        exit 1
    fi
fi

# -- Step 2: Environment file check
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "[1/5] Created .env from .env.example - please fill in your values."
    else
        echo "[1/5] WARNING: No .env file found. Create one before running."
        exit 1
    fi
else
    echo "[1/5] .env file exists."
fi

# -- Step 3: Start infrastructure services only if not already running
echo "[2/5] Ensuring infrastructure services are running..."
docker compose up -d ollama chromadb redis

# -- Step 4: Rebuild and redeploy application services (picks up code changes)
echo "[3/5] Rebuilding and redeploying application services..."
docker compose up -d --build --force-recreate api mcp

# -- Step 5: Read model names from .env and pull if missing
echo "[4/5] Checking Ollama models..."

LLM_MODEL=$(grep -E "^AGENT_LLM_MODEL=" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
EMBED_MODEL=$(grep -E "^RAG_EMBEDDING_MODEL=" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')

OLLAMA_CONTAINER=$(docker compose ps -q ollama)

echo "  Waiting for Ollama to be ready..."
until docker exec "$OLLAMA_CONTAINER" ollama list &>/dev/null; do
    sleep 2
done

INSTALLED_MODELS=$(docker exec "$OLLAMA_CONTAINER" ollama list)

if [ -n "$LLM_MODEL" ]; then
    if echo "$INSTALLED_MODELS" | grep -q "$LLM_MODEL"; then
        echo "  [OK] LLM model '$LLM_MODEL' already installed."
    else
        echo "  [PULL] Pulling LLM model '$LLM_MODEL'..."
        docker exec "$OLLAMA_CONTAINER" ollama pull "$LLM_MODEL"
    fi
fi

if [ -n "$EMBED_MODEL" ]; then
    if echo "$INSTALLED_MODELS" | grep -q "$EMBED_MODEL"; then
        echo "  [OK] Embedding model '$EMBED_MODEL' already installed."
    else
        echo "  [PULL] Pulling embedding model '$EMBED_MODEL'..."
        docker exec "$OLLAMA_CONTAINER" ollama pull "$EMBED_MODEL"
    fi
fi

# -- Step 6: Verify all services are running with curl
echo "[5/5] Verifying services..."
echo ""

# Test API
printf "  API (http://localhost:8080/health): "
if curl -sf http://localhost:8080/health >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:8080/health)"
else
    echo "[DOWN]"
fi

# Test Ollama
printf "  Ollama (http://localhost:11434): "
if curl -sf http://localhost:11434/ >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:11434/)"
else
    echo "[DOWN]"
fi

# Test ChromaDB
printf "  ChromaDB (http://localhost:8000/api/v1/heartbeat): "
if curl -sf http://localhost:8000/api/v1/heartbeat >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:8000/api/v1/heartbeat)"
else
    echo "[DOWN]"
fi

# Test Redis
printf "  Redis (localhost:6379): "
if docker compose exec -T redis redis-cli ping 2>/dev/null | grep -q "PONG"; then
    echo "[UP] PONG"
else
    echo "[DOWN]"
fi

echo ""
echo "=== Deployment complete ==="
echo "API Docs: http://localhost:8080/docs"
