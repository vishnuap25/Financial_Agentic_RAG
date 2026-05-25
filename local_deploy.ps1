$ErrorActionPreference = "Stop"

Write-Host "=== Financial Agentic RAG - Local Deploy ==="

# -- Step 1: Ensure curl is available (built-in on Windows 10+, fallback to install)
if (!(Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    Write-Host "[0/5] Installing curl..."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install curl.curl --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "ERROR: curl not found and winget unavailable. Please install curl manually."
        exit 1
    }
}

# -- Step 2: Environment file check
if (!(Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "[1/5] Created .env from .env.example - please fill in your values."
    } else {
        Write-Host "[1/5] WARNING: No .env file found. Create one before running."
        exit 1
    }
} else {
    Write-Host "[1/5] .env file exists."
}

# -- Step 3: Start infrastructure services only if not already running
Write-Host "[2/5] Ensuring infrastructure services are running..."
docker compose up -d ollama chromadb redis

# -- Step 4: Rebuild and redeploy application services (picks up code changes)
Write-Host "[3/5] Rebuilding and redeploying application services..."
docker compose up -d --build --force-recreate api mcp

# -- Step 5: Read model names from .env and pull if missing
Write-Host "[4/5] Checking Ollama models..."

$envContent = Get-Content ".env"
$llmModel = ($envContent | Where-Object { $_ -match "^AGENT_LLM_MODEL=" }) -replace "^AGENT_LLM_MODEL=", "" -replace '"', ""
$embedModel = ($envContent | Where-Object { $_ -match "^RAG_EMBEDDING_MODEL=" }) -replace "^RAG_EMBEDDING_MODEL=", "" -replace '"', ""

$ollamaContainer = (docker compose ps -q ollama).Trim()

Write-Host "  Waiting for Ollama to be ready..."
do {
    Start-Sleep -Seconds 2
    $ready = docker exec $ollamaContainer ollama list 2>$null
} until ($LASTEXITCODE -eq 0)

$installedModels = docker exec $ollamaContainer ollama list

if ($llmModel) {
    if ($installedModels -match $llmModel) {
        Write-Host "  [OK] LLM model '$llmModel' already installed."
    } else {
        Write-Host "  [PULL] Pulling LLM model '$llmModel'..."
        docker exec $ollamaContainer ollama pull $llmModel
    }
}

if ($embedModel) {
    if ($installedModels -match $embedModel) {
        Write-Host "  [OK] Embedding model '$embedModel' already installed."
    } else {
        Write-Host "  [PULL] Pulling embedding model '$embedModel'..."
        docker exec $ollamaContainer ollama pull $embedModel
    }
}

# -- Step 6: Verify all services are running with curl
Write-Host "[5/5] Verifying services..."
Write-Host ""

# Test API
try {
    $apiResp = curl.exe -sf http://localhost:8080/health 2>$null
    Write-Host "  API (http://localhost:8080/health): [UP] $apiResp"
} catch {
    Write-Host "  API (http://localhost:8080/health): [DOWN]"
}

# Test Ollama
try {
    $ollamaResp = curl.exe -sf http://localhost:11434/ 2>$null
    Write-Host "  Ollama (http://localhost:11434): [UP] $ollamaResp"
} catch {
    Write-Host "  Ollama (http://localhost:11434): [DOWN]"
}

# Test ChromaDB
try {
    $chromaResp = curl.exe -sf http://localhost:8000/api/v1/heartbeat 2>$null
    Write-Host "  ChromaDB (http://localhost:8000/api/v1/heartbeat): [UP] $chromaResp"
} catch {
    Write-Host "  ChromaDB (http://localhost:8000/api/v1/heartbeat): [DOWN]"
}

# Test Redis
$redisResp = docker compose exec -T redis redis-cli ping 2>$null
if ($redisResp -match "PONG") {
    Write-Host "  Redis (localhost:6379): [UP] PONG"
} else {
    Write-Host "  Redis (localhost:6379): [DOWN]"
}

Write-Host ""
Write-Host "=== Deployment complete ==="
Write-Host "API Docs: http://localhost:8080/docs"
