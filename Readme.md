# Financial Agentic RAG

## Environment Setup

### Step 1: Create Project Folder Structure

```
├── config/
│   ├── __init__.py
│   └── settings.py              # Pydantic settings (all config)
├── data/                        # Runtime data (gitignored)
│   ├── chroma_db/
│   └── uploads/
├── scripts/
│   └── ingest_sample.py         # CLI ingestion script
├── src/
│   ├── __init__.py
│   ├── agents/
│   │   ├── __init__.py
│   │   └── financial_agent.py   # RAG agent (httpx → Ollama /api/chat)
│   ├── api/
│   │   ├── __init__.py
│   │   └── app.py               # FastAPI application factory
│   ├── ingestion/
│   │   ├── __init__.py
│   │   ├── base.py              # Abstract base ingestor
│   │   ├── document_ingestor.py # PDF, Excel, Word, CSV parsers
│   │   ├── text_splitter.py     # Recursive character splitter
│   │   └── web_ingestor.py      # NSE fetcher + Google Search
│   ├── mcp/
│   │   ├── __init__.py
│   │   └── server.py            # MCP JSON-RPC server (stdio)
│   ├── models/
│   │   ├── __init__.py
│   │   └── base.py              # All Pydantic domain models
│   ├── tools/
│   │   ├── __init__.py
│   │   ├── agent_tools.py       # Tool definitions + dispatcher
│   │   └── financial_ratios.py  # 25+ ratio calculator
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── logging.py           # Structured JSON logging
│   │   └── retry.py             # Async retry decorator
│   └── vector_store/
│       ├── __init__.py
│       ├── base.py              # Abstract vector store
│       └── chromadb_store.py    # ChromaDB + Ollama embeddings
├── tests/
├── test_data/                   # Sample docs for testing
│   ├── reliance_financials.csv
│   ├── tcs_annual_report.txt
│   ├── hdfc_bank_financials.xlsx
│   └── infosys_q3_earnings.docx
├── .env.example
├── docker-compose.yml           # 5 services: ollama, chromadb, api, mcp, redis
├── Dockerfile
├── main.py                      # Entry point (dependency injection)
└── requirements.txt
```

### Create All Folders and Subfolders

#### macOS / Linux

```bash
mkdir -p config data/{chroma_db,uploads} scripts src/{agents,api,ingestion,mcp,models,tools,utils,vector_store} tests test_data
```

#### Windows (Command Prompt)

```cmd
if not exist config mkdir config
if not exist data\chroma_db mkdir data\chroma_db
if not exist data\uploads mkdir data\uploads
if not exist scripts mkdir scripts
if not exist src\agents mkdir src\agents
if not exist src\api mkdir src\api
if not exist src\ingestion mkdir src\ingestion
if not exist src\mcp mkdir src\mcp
if not exist src\models mkdir src\models
if not exist src\tools mkdir src\tools
if not exist src\utils mkdir src\utils
if not exist src\vector_store mkdir src\vector_store
if not exist tests mkdir tests
if not exist test_data mkdir test_data
```

#### Windows (PowerShell)

```powershell
$dirs = @(
    "config",
    "data\chroma_db",
    "data\uploads",
    "scripts",
    "src\agents",
    "src\api",
    "src\ingestion",
    "src\mcp",
    "src\models",
    "src\tools",
    "src\utils",
    "src\vector_store",
    "tests",
    "test_data"
)
$dirs | ForEach-Object { if (!(Test-Path $_)) { New-Item -Path $_ -ItemType Directory } }
```

### Step 2: Create All Files

#### macOS / Linux

```bash
files=(
  config/__init__.py config/settings.py
  scripts/ingest_sample.py
  src/__init__.py
  src/agents/__init__.py src/agents/financial_agent.py
  src/api/__init__.py src/api/app.py
  src/ingestion/__init__.py src/ingestion/base.py src/ingestion/document_ingestor.py src/ingestion/text_splitter.py src/ingestion/web_ingestor.py
  src/mcp/__init__.py src/mcp/server.py
  src/models/__init__.py src/models/base.py
  src/tools/__init__.py src/tools/agent_tools.py src/tools/financial_ratios.py
  src/utils/__init__.py src/utils/logging.py src/utils/retry.py
  src/vector_store/__init__.py src/vector_store/base.py src/vector_store/chromadb_store.py
  main.py requirements.txt Dockerfile docker-compose.yml
)
for f in "${files[@]}"; do [ ! -f "$f" ] && touch "$f"; done
```

#### Windows (Command Prompt)

```cmd
if not exist config\__init__.py type nul > config\__init__.py
if not exist config\settings.py type nul > config\settings.py
if not exist scripts\ingest_sample.py type nul > scripts\ingest_sample.py
if not exist src\__init__.py type nul > src\__init__.py
if not exist src\agents\__init__.py type nul > src\agents\__init__.py
if not exist src\agents\financial_agent.py type nul > src\agents\financial_agent.py
if not exist src\api\__init__.py type nul > src\api\__init__.py
if not exist src\api\app.py type nul > src\api\app.py
if not exist src\ingestion\__init__.py type nul > src\ingestion\__init__.py
if not exist src\ingestion\base.py type nul > src\ingestion\base.py
if not exist src\ingestion\document_ingestor.py type nul > src\ingestion\document_ingestor.py
if not exist src\ingestion\text_splitter.py type nul > src\ingestion\text_splitter.py
if not exist src\ingestion\web_ingestor.py type nul > src\ingestion\web_ingestor.py
if not exist src\mcp\__init__.py type nul > src\mcp\__init__.py
if not exist src\mcp\server.py type nul > src\mcp\server.py
if not exist src\models\__init__.py type nul > src\models\__init__.py
if not exist src\models\base.py type nul > src\models\base.py
if not exist src\tools\__init__.py type nul > src\tools\__init__.py
if not exist src\tools\agent_tools.py type nul > src\tools\agent_tools.py
if not exist src\tools\financial_ratios.py type nul > src\tools\financial_ratios.py
if not exist src\utils\__init__.py type nul > src\utils\__init__.py
if not exist src\utils\logging.py type nul > src\utils\logging.py
if not exist src\utils\retry.py type nul > src\utils\retry.py
if not exist src\vector_store\__init__.py type nul > src\vector_store\__init__.py
if not exist src\vector_store\base.py type nul > src\vector_store\base.py
if not exist src\vector_store\chromadb_store.py type nul > src\vector_store\chromadb_store.py
if not exist main.py type nul > main.py
if not exist requirements.txt type nul > requirements.txt
if not exist Dockerfile type nul > Dockerfile
if not exist docker-compose.yml type nul > docker-compose.yml
```

#### Windows (PowerShell)

```powershell
$files = @(
    "config\__init__.py",
    "config\settings.py",
    "scripts\ingest_sample.py",
    "src\__init__.py",
    "src\agents\__init__.py",
    "src\agents\financial_agent.py",
    "src\api\__init__.py",
    "src\api\app.py",
    "src\ingestion\__init__.py",
    "src\ingestion\base.py",
    "src\ingestion\document_ingestor.py",
    "src\ingestion\text_splitter.py",
    "src\ingestion\web_ingestor.py",
    "src\mcp\__init__.py",
    "src\mcp\server.py",
    "src\models\__init__.py",
    "src\models\base.py",
    "src\tools\__init__.py",
    "src\tools\agent_tools.py",
    "src\tools\financial_ratios.py",
    "src\utils\__init__.py",
    "src\utils\logging.py",
    "src\utils\retry.py",
    "src\vector_store\__init__.py",
    "src\vector_store\base.py",
    "src\vector_store\chromadb_store.py",
    "main.py",
    "requirements.txt",
    "Dockerfile",
    "docker-compose.yml"
)
$files | ForEach-Object { if (!(Test-Path $_)) { New-Item -Path $_ -ItemType File } }
```

### Step 3: Create .env File

#### What is a .env file?

A `.env` file stores environment variables (configuration values) outside your source code. It keeps sensitive data like API keys, database URLs, and service ports separate from your codebase so they are not accidentally committed to version control.

#### Why is it useful?

- **Security** – Keeps secrets (API keys, passwords) out of your code
- **Flexibility** – Change configuration without modifying code
- **Environment-specific** – Use different values for development, staging, and production
- **Team-friendly** – Each developer can have their own `.env` without conflicts

Python reads `.env` files using the `python-dotenv` package or `pydantic-settings`.

#### How to create it

##### macOS / Linux

```bash
[ ! -f .env ] && touch .env
```

##### Windows (Command Prompt)

```cmd
if not exist .env type nul > .env
```

##### Windows (PowerShell)

```powershell
if (!(Test-Path .env)) { New-Item -Path .env -ItemType File }
```

#### Basic Variables for this Project

Add the following to your `.env` file:

```env
# ── Ollama ─────────────────────────────────────────────────────────────────────
OLLAMA_BASE_URL=http://localhost:11434

# ── Google Custom Search ──────────────────────────────────────────────────────
GOOGLE_API_KEY=
GOOGLE_SEARCH_ENGINE_ID=

# ── Vector DB ─────────────────────────────────────────────────────────────────
VECTOR_DB_TYPE=chromadb
CHROMADB_PERSIST_DIRECTORY=./data/chroma_db
CHROMADB_COLLECTION_NAME=financial_docs

# ── RAG ───────────────────────────────────────────────────────────────────────
RAG_CHUNK_SIZE=1000
RAG_CHUNK_OVERLAP=200
RAG_TOP_K=5
RAG_SIMILARITY_THRESHOLD=0.7
RAG_EMBEDDING_MODEL=nomic-embed-text

# ── Agent ─────────────────────────────────────────────────────────────────────
AGENT_LLM_MODEL=llama3
AGENT_TEMPERATURE=0.0
AGENT_MAX_TOKENS=4096
AGENT_MAX_ITERATIONS=10

# ── API ───────────────────────────────────────────────────────────────────────
API_SERVICE_TITLE="Sample APP"
API_VERSION="0.0.1"
API_HOST=0.0.0.0
API_PORT=8081
API_WORKERS=4

# ── App ───────────────────────────────────────────────────────────────────────
ENVIRONMENT=development
DEBUG=false
OBS_LOG_LEVEL=INFO
OBS_LOG_FORMAT=json
```

#### Variable Explanation

| Variable | Description |
|----------|-------------|
| `OLLAMA_BASE_URL` | URL where Ollama LLM server is running locally |
| `GOOGLE_API_KEY` | API key for Google Custom Search (for web-based financial data retrieval) |
| `GOOGLE_SEARCH_ENGINE_ID` | Programmable Search Engine ID linked to your Google API key |
| `VECTOR_DB_TYPE` | Type of vector database to use (chromadb) |
| `CHROMADB_PERSIST_DIRECTORY` | Local path where ChromaDB stores its data persistently |
| `CHROMADB_COLLECTION_NAME` | Name of the ChromaDB collection to store document embeddings |
| `RAG_CHUNK_SIZE` | Maximum number of characters per text chunk during document splitting |
| `RAG_CHUNK_OVERLAP` | Number of overlapping characters between consecutive chunks (preserves context) |
| `RAG_TOP_K` | Number of most similar chunks to retrieve from vector store per query |
| `RAG_SIMILARITY_THRESHOLD` | Minimum similarity score (0-1) for a chunk to be considered relevant |
| `RAG_EMBEDDING_MODEL` | Ollama model used to generate text embeddings |
| `AGENT_LLM_MODEL` | Ollama LLM model used by the financial agent for reasoning |
| `AGENT_TEMPERATURE` | Controls randomness in LLM responses (0.0 = deterministic, 1.0 = creative) |
| `AGENT_MAX_TOKENS` | Maximum number of tokens the LLM can generate per response |
| `AGENT_MAX_ITERATIONS` | Maximum reasoning loops the agent can perform before stopping |
| `API_SERVICE_TITLE` | Display name of the FastAPI service (shown in docs) |
| `API_VERSION` | Version string for the API |
| `API_HOST` | Host address the API server binds to (0.0.0.0 = all interfaces) |
| `API_PORT` | Port number the API server listens on |
| `API_WORKERS` | Number of Uvicorn worker processes for handling concurrent requests |
| `ENVIRONMENT` | Current environment (development, staging, production) |
| `DEBUG` | Enable/disable debug mode (true/false) |
| `OBS_LOG_LEVEL` | Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL) |
| `OBS_LOG_FORMAT` | Log output format (json for structured logging, text for readable) |

> **Note:** Never commit your `.env` file to Git. Add `.env` to your `.gitignore` file.

### Step 4: Create Virtual Environment

A virtual environment is an isolated Python environment that keeps project dependencies separate from your system Python. This prevents package version conflicts between different projects.

#### Using venv (built-in)

##### macOS / Linux

```bash
# Create virtual environment
python3 -m venv venv

# Activate
source venv/bin/activate
```

Activated terminal looks like:
```
(venv) user@machine:~/Financial_Agentic_RAG$
```

##### Windows (Command Prompt)

```cmd
:: Create virtual environment
python -m venv venv

:: Activate
venv\Scripts\activate.bat
```

Activated terminal looks like:
```
(venv) C:\Users\user\Financial_Agentic_RAG>
```

##### Windows (PowerShell)

```powershell
# Create virtual environment
python -m venv venv

# Activate
.\venv\Scripts\Activate.ps1
```

Activated terminal looks like:
```
(venv) PS C:\Users\user\Financial_Agentic_RAG>
```

#### Using Conda

##### macOS / Linux / Windows

```bash
# Create conda environment
conda create --name financial_rag python=3.11 -y

# Activate
conda activate financial_rag
```

Activated terminal looks like:
```
(financial_rag) user@machine:~/Financial_Agentic_RAG$
```

#### Deactivate Virtual Environment

```bash
# venv
deactivate

# conda
conda deactivate
```

#### Install Dependencies After Activation

```bash
pip install -r requirements.txt
```

### Step 5: Setup requirements.txt

The `requirements.txt` file lists all Python packages needed to run this project. Install them using:

```bash
pip install -r requirements.txt
```

#### Packages

```txt
# Web Framework
fastapi==0.115.0
uvicorn==0.30.6

# LLM & Embeddings
httpx==0.27.2
ollama==0.4.7

# Vector Store
chromadb==0.5.23

# Document Parsing
pypdf==4.3.1
openpyxl==3.1.5
python-docx==1.1.2
pandas==2.2.3

# Web Scraping & Search
beautifulsoup4==4.12.3
requests==2.32.3
googlesearch-python==1.2.5

# Configuration & Environment
pydantic==2.9.2
pydantic-settings==2.6.1
python-dotenv==1.0.1

# MCP Server
jsonrpcserver==5.0.9

# Async & Utilities
tenacity==9.0.0

# Logging
structlog==24.4.0

# Containerization
docker==7.1.0

# Redis (caching)
redis==5.2.1
```

#### Package Explanation

| Package | Description |
|---------|-------------|
| `fastapi` | Modern, high-performance Python web framework for building REST APIs with automatic OpenAPI docs |
| `uvicorn` | ASGI server that runs FastAPI applications, handles HTTP requests asynchronously |
| `httpx` | Async HTTP client used to communicate with Ollama's /api/chat endpoint |
| `ollama` | Python client library for interacting with locally running Ollama LLM models |
| `chromadb` | Open-source vector database for storing and querying document embeddings |
| `pypdf` | Extracts text content from PDF financial documents for ingestion |
| `openpyxl` | Reads and parses Excel (.xlsx) spreadsheets containing financial data |
| `python-docx` | Reads and parses Word (.docx) documents like annual reports |
| `pandas` | Data manipulation library for processing CSV/Excel financial data into structured format |
| `beautifulsoup4` | HTML/XML parser used to scrape financial data from web pages |
| `requests` | HTTP library for making synchronous web requests to fetch financial data |
| `googlesearch-python` | Performs Google searches programmatically to find relevant financial information online |
| `pydantic` | Data validation library using Python type hints, defines all domain models |
| `pydantic-settings` | Loads and validates environment variables from .env file into typed settings classes |
| `python-dotenv` | Reads key-value pairs from .env file and sets them as environment variables |
| `jsonrpcserver` | Implements JSON-RPC protocol for the MCP (Model Context Protocol) server communication |
| `tenacity` | Retry decorator for handling transient failures in async operations (API calls, DB connections) |
| `structlog` | Structured logging library that outputs logs in JSON format for better observability |
| `docker` | Python SDK for Docker Engine API, used to manage containers programmatically |
| `redis` | Python client for Redis, used for caching query results and session management |

### Step 6: Setup settings.py (Configuration Management)

#### What is settings.py?

`settings.py` is a centralized configuration file that reads all environment variables from the `.env` file and makes them available as typed Python objects throughout the application. It uses `pydantic-settings` for automatic validation and type casting.

#### Why do we need it?

- **Type Safety** – Variables are automatically cast to the correct type (str, int, float, bool)
- **Validation** – App fails fast at startup if required variables are missing or invalid
- **Single Source of Truth** – All config is accessed from one place instead of scattered `os.getenv()` calls
- **Default Values** – Provides sensible defaults when env variables are not set
- **IDE Support** – Autocomplete and type hints work because settings are defined as class attributes

#### How it works

1. Reads `.env` file automatically on startup
2. Maps `VARIABLE_NAME` in `.env` → `variable_name` attribute in Python (case-insensitive)
3. Validates types and raises errors if required values are missing

#### Code: `config/settings.py`

```python
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    # API Configuration
    api_service_title: str
    api_version: str
    api_host: str = "0.0.0.0"
    api_port: int = 8080
    api_workers: int = 4

    # Ollama Configuration
    ollama_base_url: str

    # Vector DB Configuration
    vector_db_type: str
    chromadb_persist_directory: str
    chromadb_collection_name: str

    # RAG Configuration
    rag_chunk_size: int
    rag_chunk_overlap: int
    rag_top_k: int
    rag_similarity_threshold: float = 0.7
    rag_embedding_model: str = "nomic-embed-text"

    # Agent Configuration
    agent_llm_model: str = "llama3"
    agent_temperature: float = 0.0
    agent_max_tokens: int = 4096
    agent_max_iterations: int = 10

    # App Configuration
    environment: str = "development"
    debug: bool = False
    obs_log_level: str = "INFO"
    obs_log_format: str = "json"

    # Reads .env file automatically
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

def get_settings() -> Settings:
    return Settings()
```

#### Usage in other files

```python
from config.settings import get_settings

settings = get_settings()

# Access variables as typed attributes
print(settings.ollama_base_url)        # http://localhost:11434
print(settings.rag_chunk_size)         # 1000 (int, not string)
print(settings.agent_temperature)      # 0.0 (float)
print(settings.debug)                  # False (bool)
```

#### How .env maps to Settings

| .env Variable | Settings Attribute | Type | Default |
|---------------|-------------------|------|---------|
| `API_SERVICE_TITLE` | `settings.api_service_title` | str | *required* |
| `API_VERSION` | `settings.api_version` | str | *required* |
| `API_HOST` | `settings.api_host` | str | `0.0.0.0` |
| `API_PORT` | `settings.api_port` | int | `8080` |
| `API_WORKERS` | `settings.api_workers` | int | `4` |
| `OLLAMA_BASE_URL` | `settings.ollama_base_url` | str | *required* |
| `VECTOR_DB_TYPE` | `settings.vector_db_type` | str | *required* |
| `CHROMADB_PERSIST_DIRECTORY` | `settings.chromadb_persist_directory` | str | *required* |
| `CHROMADB_COLLECTION_NAME` | `settings.chromadb_collection_name` | str | *required* |
| `RAG_CHUNK_SIZE` | `settings.rag_chunk_size` | int | *required* |
| `RAG_CHUNK_OVERLAP` | `settings.rag_chunk_overlap` | int | *required* |
| `RAG_TOP_K` | `settings.rag_top_k` | int | *required* |
| `RAG_SIMILARITY_THRESHOLD` | `settings.rag_similarity_threshold` | float | `0.7` |
| `RAG_EMBEDDING_MODEL` | `settings.rag_embedding_model` | str | `nomic-embed-text` |
| `AGENT_LLM_MODEL` | `settings.agent_llm_model` | str | `llama3` |
| `AGENT_TEMPERATURE` | `settings.agent_temperature` | float | `0.0` |
| `AGENT_MAX_TOKENS` | `settings.agent_max_tokens` | int | `4096` |
| `AGENT_MAX_ITERATIONS` | `settings.agent_max_iterations` | int | `10` |
| `ENVIRONMENT` | `settings.environment` | str | `development` |
| `DEBUG` | `settings.debug` | bool | `False` |
| `OBS_LOG_LEVEL` | `settings.obs_log_level` | str | `INFO` |
| `OBS_LOG_FORMAT` | `settings.obs_log_format` | str | `json` |

> **Note:** Variables without a default value are *required* — the app will throw a validation error at startup if they are missing from `.env`.

#### Settings Field Configuration Examples

```python
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field

class Settings(BaseSettings):

    # ── Required Field (no default = must be in .env) ─────────────────────────
    ollama_base_url: str

    # ── Optional Field (has default value) ────────────────────────────────────
    api_host: str = "0.0.0.0"

    # ── Setting Data Type ─────────────────────────────────────────────────────
    api_port: int = 8080              # auto-converts "8080" string from .env to int
    debug: bool = False               # auto-converts "true"/"false" string to bool
    agent_temperature: float = 0.0    # auto-converts "0.0" string to float

    # ── Field with Description ────────────────────────────────────────────────
    rag_chunk_size: int = Field(
        default=1000,
        description="Maximum number of characters per text chunk during splitting"
    )

    # ── Required Field with Description (no default) ──────────────────────────
    google_api_key: str = Field(
        description="Google API key for Custom Search"
    )

    # ── Field with Validation Constraints ─────────────────────────────────────
    rag_top_k: int = Field(
        default=5,
        ge=1,              # greater than or equal to 1
        le=20,             # less than or equal to 20
        description="Number of similar chunks to retrieve"
    )

    rag_similarity_threshold: float = Field(
        default=0.7,
        ge=0.0,            # minimum 0.0
        le=1.0,            # maximum 1.0
        description="Minimum similarity score for relevance"
    )

    # ── Field with Alias (different name in .env vs code) ─────────────────────
    log_level: str = Field(
        default="INFO",
        alias="OBS_LOG_LEVEL"    # reads OBS_LOG_LEVEL from .env
    )

    # ── Field with Examples (shows in generated docs) ─────────────────────────
    environment: str = Field(
        default="development",
        examples=["development", "staging", "production"],
        description="Current deployment environment"
    )

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")
```

#### Quick Reference

| What you want | How to do it |
|---------------|-------------|
| Required variable | `name: str` (no default value) |
| Optional variable | `name: str = "default_value"` |
| Set data type | `name: int`, `name: float`, `name: bool`, `name: str` |
| Add description | `name: str = Field(description="...")` |
| Default value with Field | `name: int = Field(default=100)` |
| Min/Max validation | `name: int = Field(ge=1, le=100)` |
| Alias (different .env name) | `name: str = Field(alias="ENV_VAR_NAME")` |
| Examples | `name: str = Field(examples=["a", "b"])` |


### Step 7: Setup API Endpoints (src/api/app.py)

#### What are Endpoints?

Endpoints are URLs that your API exposes for clients to interact with. Each endpoint handles a specific action. In FastAPI, endpoints are Python functions decorated with HTTP method decorators.

#### HTTP Methods Used

| Method | Purpose | Example |
|--------|---------|---------|
| `GET` | Retrieve data | `/health` – check if server is running |
| `POST` | Send data / trigger action | `/chat` – send a question to the agent |

#### What is an Application Factory?

Instead of creating the FastAPI app globally, we use a `create_app()` function (factory pattern). This allows:
- Injecting different settings for testing vs production
- Registering routes and middleware in a controlled order
- Creating multiple app instances if needed

#### Code: `src/api/app.py`

```python
from fastapi import FastAPI
from config.settings import get_settings

def create_app() -> FastAPI:
    setting = get_settings()
    app = FastAPI(
        title=setting.api_service_title,
        version=setting.api_version
    )

    @app.get("/health")
    async def health_check():
        return {"status": "healthy"}

    @app.post("/chat")
    async def chat_endpoint():
        return {"message": "Chat endpoint"}

    return app
```

#### Code Breakdown

| Part | Explanation |
|------|-------------|
| `from fastapi import FastAPI` | Import the FastAPI class |
| `from config.settings import get_settings` | Import settings to read app title and version from `.env` |
| `def create_app() -> FastAPI` | Factory function that builds and returns the app |
| `FastAPI(title=..., version=...)` | Creates the app with metadata (visible at `/docs`) |
| `@app.get("/health")` | Decorator that registers a GET endpoint at `/health` |
| `async def health_check()` | Async function that handles the request |
| `@app.post("/chat")` | Decorator that registers a POST endpoint at `/chat` |
| `return app` | Returns the configured app instance |

#### Available Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/health` | Returns server health status |
| POST | `/chat` | Chat with the financial RAG agent |

#### How to Run the API

```bash
uvicorn src.api.app:create_app --factory --host 0.0.0.0 --port 8081 --reload
```

#### Test the Endpoints

```bash
# Health check
curl http://localhost:8081/health

# Chat endpoint
curl -X POST http://localhost:8081/chat
```

#### Auto-generated API Docs

FastAPI automatically generates interactive documentation:

- Swagger UI: `http://localhost:8081/docs`
- ReDoc: `http://localhost:8081/redoc`

### Step 8: Setup main.py (Application Entry Point)

#### What is main.py?

`main.py` is the entry point of the application — the file you run to start the entire server. It wires together the settings and the FastAPI app, then launches the Uvicorn server.

#### Why do we need it?

- **Single entry point** – One command to start the whole application
- **Dependency injection** – Loads settings and passes them to the app
- **Uvicorn integration** – Configures and starts the ASGI server with host/port from `.env`
- **Module-level app** – Exposes `app` at module level so Uvicorn can find it for hot-reload

#### Code: `main.py`

```python
from config.settings import get_settings
from src.api.app import create_app
import uvicorn

settings = get_settings()

app = create_app()

if __name__ == "__main__":
    settings = get_settings()
    uvicorn.run("main:app", host=settings.api_host, port=settings.api_port)
```

#### Code Breakdown

| Part | Explanation |
|------|-------------|
| `from config.settings import get_settings` | Import the settings loader to read `.env` values |
| `from src.api.app import create_app` | Import the app factory function |
| `import uvicorn` | Import the ASGI server that serves FastAPI |
| `settings = get_settings()` | Load settings at module level |
| `app = create_app()` | Create the FastAPI app instance at module level (needed for `uvicorn.run("main:app")`) |
| `if __name__ == "__main__"` | Only runs when executing `python main.py` directly (not on import) |
| `uvicorn.run("main:app", ...)` | Starts the server using string reference to enable hot-reload |
| `host=settings.api_host` | Binds to the host from `.env` (default: `0.0.0.0`) |
| `port=settings.api_port` | Listens on the port from `.env` (default: `8081`) |

#### How to Run

```bash
python main.py
```

#### Expected Output

```
INFO:     Started server process [12345]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8081 (Press CTRL+C to quit)
```

#### Why `"main:app"` string instead of `app` object?

Using the string `"main:app"` tells Uvicorn to import the app by path. This enables:
- **Hot-reload** (`--reload` flag) – Uvicorn can restart the process and re-import the module on code changes
- If you pass the `app` object directly, hot-reload won't work

### Step 9: Docker Configuration

#### What is Docker?

Docker packages your application and all its dependencies into a container — a lightweight, portable unit that runs the same way on any machine. No more "it works on my machine" issues.

#### What is Docker Compose?

Docker Compose lets you define and run multiple containers (services) together with a single command. For this project, we run 5 services simultaneously.

---

#### Dockerfile (Line-by-Line)

```dockerfile
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8082

CMD ["python", "main.py"]
```

| Line | Explanation |
|------|-------------|
| `FROM python:3.12-slim` | Base image — lightweight Python 3.12 (slim = minimal OS, smaller image size) |
| `WORKDIR /app` | Sets `/app` as the working directory inside the container |
| `RUN apt-get update && apt-get install -y --no-install-recommends build-essential curl` | Installs system dependencies: `build-essential` for compiling Python packages, `curl` for healthchecks |
| `&& rm -rf /var/lib/apt/lists/*` | Removes apt cache to reduce image size |
| `COPY requirements.txt .` | Copies only requirements.txt first (Docker layer caching — if deps don't change, this layer is reused) |
| `RUN pip install --no-cache-dir -r requirements.txt` | Installs Python packages. `--no-cache-dir` reduces image size |
| `COPY . .` | Copies the entire project source code (main.py, src/, config/, etc.) into the container |
| `EXPOSE 8082` | Documents that the container listens on port 8082 (informational only) |
| `CMD ["python", "main.py"]` | Default command to run when the container starts |

---

#### docker-compose.yml (Line-by-Line)

```yaml
version: "3.9"
```

| Line | Explanation |
|------|-------------|
| `version: "3.9"` | Docker Compose file format version (3.9 supports healthcheck conditions in depends_on) |

---

##### Service 1: Ollama (Local LLM Server)

```yaml
  ollama:
    image: ollama/ollama:latest
    ports: ["11434:11434"]
    volumes: [ollama_data:/root/.ollama]
    healthcheck:
      test: ["CMD-SHELL", "ollama list || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
```

| Line | Explanation |
|------|-------------|
| `image: ollama/ollama:latest` | Uses the official Ollama Docker image |
| `ports: ["11434:11434"]` | Maps host port 11434 → container port 11434 (Ollama API port) |
| `volumes: [ollama_data:/root/.ollama]` | Persists downloaded LLM models across container restarts |
| `healthcheck.test` | Uses `ollama list` command (curl is not available in this container) |
| `CMD-SHELL` | Runs the command via shell so `||` works for exit code handling |
| `interval: 10s` | Runs healthcheck every 10 seconds |
| `timeout: 5s` | Healthcheck fails if no response within 5 seconds |
| `retries: 5` | Marks unhealthy after 5 consecutive failures |

---

##### Service 2: ChromaDB (Vector Database)

```yaml
  chromadb:
    image: chromadb/chroma:latest
    ports: ["8000:8000"]
    volumes: [chroma_data:/chroma/chroma]
    environment:
      ANONYMIZED_TELEMETRY: "false"
    healthcheck:
      test: ["CMD-SHELL", "bash -c 'echo > /dev/tcp/localhost/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
```

| Line | Explanation |
|------|-------------|
| `image: chromadb/chroma:latest` | Uses the official ChromaDB Docker image |
| `ports: ["8000:8000"]` | Maps host port 8000 → container port 8000 (ChromaDB default) |
| `volumes: [chroma_data:/chroma/chroma]` | Persists vector embeddings across restarts |
| `ANONYMIZED_TELEMETRY: "false"` | Disables ChromaDB telemetry/data collection |
| `healthcheck.test` | Uses bash TCP check (curl/wget/python not available in this container) |
| `CMD-SHELL` | Runs via shell so `||` works for exit code handling |

---

##### Service 3: Redis (Caching)

```yaml
  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
    volumes: [redis_data:/data]
```

| Line | Explanation |
|------|-------------|
| `image: redis:7-alpine` | Uses Redis 7 on Alpine Linux (very small image ~5MB) |
| `ports: ["6379:6379"]` | Maps host port 6379 → container port 6379 (Redis default) |
| `volumes: [redis_data:/data]` | Persists cached data across restarts |

---

##### Service 4: API (FastAPI Application)

```yaml
  api:
    build: .
    ports: ["8080:8080"]
    env_file: .env
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
      CHROMADB_HOST: chromadb
      CHROMADB_PORT: 8000
    volumes:
      - uploads:/app/data/uploads
    depends_on:
      ollama:
        condition: service_healthy
      chromadb:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

| Line | Explanation |
|------|-------------|
| `build: .` | Builds the image using the Dockerfile in the current directory |
| `ports: ["8080:8080"]` | Maps host port 8080 → container port 8080 (API port) |
| `env_file: .env` | Loads all environment variables from `.env` file |
| `OLLAMA_BASE_URL: http://ollama:11434` | Overrides `.env` — uses Docker's internal DNS (`ollama` = container name) |
| `CHROMADB_HOST: chromadb` | Points to ChromaDB container via Docker network |
| `CHROMADB_PORT: 8000` | ChromaDB port inside Docker network |
| `volumes: uploads:/app/data/uploads` | Persists uploaded documents in a named volume |
| `depends_on: ollama: condition: service_healthy` | Waits until Ollama passes healthcheck before starting API |
| `depends_on: chromadb: condition: service_healthy` | Waits until ChromaDB passes healthcheck before starting API |
| `depends_on: redis: condition: service_started` | Waits until Redis container starts (no healthcheck needed) |
| `healthcheck.test` | Checks if API is ready by hitting `/health` endpoint |

---

##### Service 5: MCP (Model Context Protocol Server)

```yaml
  mcp:
    build: .
    command: ["python", "-m", "src.mcp.server"]
    env_file: .env
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
      CHROMADB_HOST: chromadb
      CHROMADB_PORT: 8000
    depends_on:
      ollama:
        condition: service_healthy
      chromadb:
        condition: service_healthy
    stdin_open: true
```

| Line | Explanation |
|------|-------------|
| `build: .` | Builds from the same Dockerfile as the API |
| `command: ["python", "-m", "src.mcp.server"]` | Overrides default CMD — runs MCP server instead of main.py |
| `env_file: .env` | Loads environment variables from `.env` |
| `OLLAMA_BASE_URL: http://ollama:11434` | Uses Docker internal DNS to reach Ollama |
| `CHROMADB_HOST: chromadb` | Points to ChromaDB container |
| `depends_on` | Waits for Ollama and ChromaDB to be healthy |
| `stdin_open: true` | Keeps stdin open (required for MCP stdio transport) |

---

##### Named Volumes

```yaml
volumes:
  chroma_data:
  uploads:
  redis_data:
  ollama_data:
```

| Volume | Stores |
|--------|--------|
| `ollama_data` | Downloaded LLM model files |
| `chroma_data` | Vector embeddings and indexes |
| `redis_data` | Cached query results |
| `uploads` | User-uploaded financial documents |

Named volumes persist data even if containers are deleted. Managed by Docker internally.

---

#### Docker Commands

| Command | Description |
|---------|-------------|
| `docker-compose up -d` | Start all services in background |
| `docker-compose down` | Stop and remove all containers |
| `docker-compose down -v` | Stop containers and delete all volumes (data loss!) |
| `docker-compose logs -f` | Follow logs from all services |
| `docker-compose logs -f api` | Follow logs from API service only |
| `docker-compose build` | Rebuild images (after code changes) |
| `docker-compose up -d --build` | Rebuild and restart all services |
| `docker-compose ps` | Show running containers and health status |
| `docker-compose restart api` | Restart only the API service |

#### Key Concept: Docker Internal DNS

Inside Docker Compose, containers communicate using service names as hostnames:
- `http://ollama:11434` — not `localhost`, because each container has its own network
- `http://chromadb:8000` — Docker resolves `chromadb` to the container's internal IP
- That's why `environment` overrides `OLLAMA_BASE_URL` from `http://localhost:11434` to `http://ollama:11434`

### Step 10: View ChromaDB with Chroma Explorer

[Chroma Explorer](https://www.chroma-explorer.com/) is a free browser-based UI for inspecting your ChromaDB collections, documents, and embeddings — no installation required.

#### Prerequisites

- ChromaDB container must be running (started in Step 9)
- A modern web browser (Chrome, Firefox, Edge, Safari)

#### How to Use

1. Make sure your ChromaDB container is running:

   ```bash
   docker compose up -d chromadb
   ```

2. Open [https://www.chroma-explorer.com/](https://www.chroma-explorer.com/) in your browser

3. Connect to your local ChromaDB instance:
   - **Host**: `http://localhost`
   - **Port**: `8000`
   - Click **Connect**

4. Browse your data:
   - Select the `financial_docs` collection
   - Inspect ingested document chunks, metadata, and IDs
   - Run similarity searches directly from the UI

#### What You Can Do

| Feature | Description |
|---------|-------------|
| Browse collections | View all ChromaDB collections and document counts |
| Inspect documents | See chunked text, metadata, and IDs stored after ingestion |
| Query embeddings | Run similarity searches directly from the UI |
| Debug ingestion | Verify documents were ingested correctly before running the agent |

> **Note:** Chroma Explorer connects directly to your local ChromaDB over HTTP. Your data never leaves your machine.

---

### Step 11: Download Ollama Models

After all containers are running and healthy, you need to pull the LLM and embedding models into the Ollama container.

#### What is curl?

`curl` is a command-line tool for making HTTP requests. It's used to interact with APIs directly from the terminal — useful for testing endpoints, downloading files, and triggering actions on running services.

#### Install curl

##### macOS

```bash
# Already pre-installed on macOS
# Or install via Homebrew
brew install curl
```

##### Linux (Ubuntu/Debian)

```bash
sudo apt-get update && sudo apt-get install -y curl
```

##### Linux (CentOS/RHEL)

```bash
sudo yum install -y curl
```

##### Windows

```cmd
:: Already available in Windows 10+ Command Prompt and PowerShell
:: Or install via winget
winget install curl.curl
```

#### Pull Models into Ollama Container

##### Pull llama3.1 (LLM for reasoning)

```bash
docker exec -it financial_agentic_rag-ollama-1 ollama pull llama3.1
```

##### Pull nomic-embed-text (Embedding model for vector search)

```bash
docker exec -it financial_agentic_rag-ollama-1 ollama pull nomic-embed-text
```

#### Verify Installed Models

```bash
docker exec -it financial_agentic_rag-ollama-1 ollama list
```

Expected output:

```
NAME                    ID              SIZE      MODIFIED
llama3.1:latest         <id>            4.7 GB    Just now
nomic-embed-text:latest <id>            274 MB    Just now
```

#### Test Models Using curl

##### Test llama3.1 (Chat completion)

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.1",
  "messages": [{"role": "user", "content": "What is a P/E ratio?"}],
  "stream": false
}'
```

Expected response:

```json
{
  "model": "llama3.1",
  "message": {
    "role": "assistant",
    "content": "A P/E ratio (Price-to-Earnings ratio) is..."
  },
  "done": true
}
```

##### Test nomic-embed-text (Generate embeddings)

```bash
curl http://localhost:11434/api/embed -d '{
  "model": "nomic-embed-text",
  "input": "Reliance Industries Q3 revenue grew 15%"
}'
```

Expected response:

```json
{
  "model": "nomic-embed-text",
  "embeddings": [[0.0123, -0.0456, 0.0789, ...]]
}
```

##### Check Ollama server status

```bash
curl http://localhost:11434/api/tags
```

This returns a list of all downloaded models.

#### curl Quick Reference

| Flag | Purpose | Example |
|------|---------|---------|
| `-d` | Send data (POST request body) | `curl -d '{"key":"value"}' URL` |
| `-X` | Specify HTTP method | `curl -X POST URL` |
| `-H` | Set header | `curl -H "Content-Type: application/json" URL` |
| `-f` | Fail silently (no output on error) | `curl -f URL` |
| `-s` | Silent mode (no progress bar) | `curl -s URL` |
| `-o` | Save output to file | `curl -o file.json URL` |

#### Model Details

| Model | Purpose | Size | Use Case |
|-------|---------|------|----------|
| `llama3.1` | Large Language Model | ~4.7 GB | Agent reasoning, answering financial questions, tool calling |
| `nomic-embed-text` | Embedding Model | ~274 MB | Converting text to vectors for similarity search in ChromaDB |

#### Important: Choose Models with Tool Support

For agentic applications (like this project), the LLM must support **tool/function calling** — the ability to decide when to use external tools, return structured tool call requests, and process tool results.

Always verify that the model you download supports tools before using it in an agent workflow.

##### Models WITH Tool Support (Recommended for Agents)

| Model | Tool Support | Notes |
|-------|:---:|-------|
| `llama3.1` | ✅ | Native tool calling, recommended for this project |
| `llama3.2` | ✅ | Lightweight versions available (1B, 3B) |
| `llama3.3` | ✅ | Latest Llama with improved tool use |
| `mistral` | ✅ | Good tool calling with function support |
| `qwen2.5` | ✅ | Strong tool support, multilingual |
| `command-r` | ✅ | Built for RAG and tool use |
| `command-r-plus` | ✅ | Larger version with better reasoning |
| `firefunction-v2` | ✅ | Specifically fine-tuned for function calling |

##### Models WITHOUT Tool Support (Not suitable for agents)

| Model | Tool Support | Notes |
|-------|:---:|-------|
| `llama2` | ❌ | Older model, no native tool calling |
| `phi` | ❌ | Small model, no tool support |
| `gemma` | ❌ | No native function calling |
| `vicuna` | ❌ | Chat-only, no tool use |
| `orca-mini` | ❌ | No structured tool output |
| `tinyllama` | ❌ | Too small for tool calling |

> **Note:** Using a model without tool support in an agentic workflow will result in the agent being unable to call tools, leading to plain text responses instead of structured actions.

### Step 12: Local Deploy Scripts

#### What are the deploy scripts?

The deploy scripts automate the entire deployment process with a single command. They handle environment setup, start infrastructure services, rebuild application containers with latest code changes, and ensure required LLM models are available in Ollama.

#### Files

| File | Platform | How to Run |
|------|----------|------------|
| `local_deploy.sh` | macOS / Linux | `./local_deploy.sh` |
| `local_deploy.ps1` | Windows (PowerShell) | `.\local_deploy.ps1` |

#### Prerequisites

- Docker and Docker Compose installed and running
- `.env` file configured (or `.env.example` present to copy from)

#### What the scripts do

| Step | Action | Details |
|------|--------|---------|
| 0 | Install curl | Checks if curl is installed. If missing, auto-installs using the system package manager (apt/yum/brew on Linux/macOS, winget on Windows). |
| 1 | Check `.env` | If `.env` doesn't exist, copies from `.env.example`. Exits with error if neither exists. |
| 2 | Start infrastructure | Runs `docker compose up -d ollama chromadb redis`. These services are only started if not already running — they are never rebuilt or recreated. |
| 3 | Rebuild application | Runs `docker compose up -d --build --force-recreate api mcp`. This rebuilds the Docker image and recreates the `api` and `mcp` containers every time, ensuring all code changes are deployed. |
| 4 | Pull Ollama models | Reads `AGENT_LLM_MODEL` and `RAG_EMBEDDING_MODEL` from `.env`, checks if they exist in the Ollama container, and pulls them if missing. |
| 5 | Verify services | Uses curl to hit each service endpoint and prints `[UP]` with the response or `[DOWN]` if unreachable. Redis is tested via `redis-cli ping`. |

#### Why infrastructure services are not rebuilt

Services like Ollama, ChromaDB, and Redis use official pre-built images and store persistent data in Docker volumes. Rebuilding them would:
- Re-download large LLM models (~5 GB)
- Lose vector embeddings stored in ChromaDB
- Clear cached data in Redis

The `--build --force-recreate` flags are only applied to `api` and `mcp` because those are built from your source code and need to reflect the latest changes.

#### How to run

##### macOS / Linux

```bash
# Make executable (first time only)
chmod +x local_deploy.sh

# Run
./local_deploy.sh
```

##### Windows (PowerShell)

```powershell
# If execution policy blocks scripts, run this first (one time)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run
.\local_deploy.ps1
```

#### Expected Output

```
=== Financial Agentic RAG - Local Deploy ===
[1/5] .env file exists.
[2/5] Ensuring infrastructure services are running...
[+] Running 3/3
  Container financial_agentic_rag-ollama-1    Running
  Container financial_agentic_rag-chromadb-1  Running
  Container financial_agentic_rag-redis-1     Running
[3/5] Rebuilding and redeploying application services...
[+] Building api
[+] Running 2/2
  Container financial_agentic_rag-api-1  Started
  Container financial_agentic_rag-mcp-1  Started
[4/5] Checking Ollama models...
  Waiting for Ollama to be ready...
  [OK] LLM model 'llama3.1:8b' already installed.
  [OK] Embedding model 'nomic-embed-text' already installed.
[5/5] Verifying services...

  API (http://localhost:8080/health): [UP] {"status":"healthy"}
  Ollama (http://localhost:11434): [UP] Ollama is running
  ChromaDB (http://localhost:8000/api/v1/heartbeat): [UP] {"nanosecond heartbeat":1234567890}
  Redis (localhost:6379): [UP] PONG

=== Deployment complete ===
API Docs: http://localhost:8080/docs
```

#### Code: `local_deploy.sh`

```bash
#!/usr/bin/env bash
# Exit immediately if any command fails
set -e

echo "=== Financial Agentic RAG - Local Deploy ==="

# -- Step 1: Ensure curl is installed (needed for health checks)
# curl is used at the end to verify all services are reachable.
# Auto-installs using the appropriate package manager for the OS.
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
# Check if .env exists. If not, copy from .env.example as a template.
# The .env file is required for Docker Compose to inject config into containers.
# If neither .env nor .env.example exist, exit with error — can't deploy without config.
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
# Docker Compose automatically skips containers that are already up.
# These use pre-built images and store data in persistent volumes,
# so we never rebuild or recreate them (avoids re-downloading models, losing embeddings, etc.)
echo "[2/5] Ensuring infrastructure services are running..."
docker compose up -d ollama chromadb redis

# -- Step 4: Rebuild and redeploy application services (picks up code changes)
# --build          = rebuilds the Docker image from Dockerfile (picks up code changes)
# --force-recreate = stops and recreates containers even if config hasn't changed
# This ensures every run deploys the latest source code.
echo "[3/5] Rebuilding and redeploying application services..."
docker compose up -d --build --force-recreate api mcp

# -- Step 5: Read model names from .env and pull if missing
# grep extracts the line, cut splits on '=', tr removes quotes and spaces.
# Then check if each model is already installed in the ollama container.
# If not installed, pull it. This avoids re-downloading ~5GB models on every deploy.
echo "[4/5] Checking Ollama models..."

LLM_MODEL=$(grep -E "^AGENT_LLM_MODEL=" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
EMBED_MODEL=$(grep -E "^RAG_EMBEDDING_MODEL=" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')

# Get the ollama container ID dynamically (works regardless of project name)
OLLAMA_CONTAINER=$(docker compose ps -q ollama)

# Wait until ollama is ready to accept commands (it takes a few seconds to boot)
echo "  Waiting for Ollama to be ready..."
until docker exec "$OLLAMA_CONTAINER" ollama list &>/dev/null; do
    sleep 2
done

# Get list of currently installed models
INSTALLED_MODELS=$(docker exec "$OLLAMA_CONTAINER" ollama list)

# Check and pull LLM model if not present
if [ -n "$LLM_MODEL" ]; then
    if echo "$INSTALLED_MODELS" | grep -q "$LLM_MODEL"; then
        echo "  [OK] LLM model '$LLM_MODEL' already installed."
    else
        echo "  [PULL] Pulling LLM model '$LLM_MODEL'..."
        docker exec "$OLLAMA_CONTAINER" ollama pull "$LLM_MODEL"
    fi
fi

# Check and pull embedding model if not present
if [ -n "$EMBED_MODEL" ]; then
    if echo "$INSTALLED_MODELS" | grep -q "$EMBED_MODEL"; then
        echo "  [OK] Embedding model '$EMBED_MODEL' already installed."
    else
        echo "  [PULL] Pulling embedding model '$EMBED_MODEL'..."
        docker exec "$OLLAMA_CONTAINER" ollama pull "$EMBED_MODEL"
    fi
fi

# -- Step 6: Verify all services are running with curl
# curl -sf = silent + fail on error (no output on failure, non-zero exit code)
# Each service is tested against its health/status endpoint.
# Redis has no HTTP endpoint so it is tested via redis-cli ping inside the container.
echo "[5/5] Verifying services..."
echo ""

printf "  API (http://localhost:8080/health): "
if curl -sf http://localhost:8080/health >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:8080/health)"
else
    echo "[DOWN]"
fi

printf "  Ollama (http://localhost:11434): "
if curl -sf http://localhost:11434/ >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:11434/)"
else
    echo "[DOWN]"
fi

printf "  ChromaDB (http://localhost:8000/api/v1/heartbeat): "
if curl -sf http://localhost:8000/api/v1/heartbeat >/dev/null 2>&1; then
    echo "[UP] $(curl -s http://localhost:8000/api/v1/heartbeat)"
else
    echo "[DOWN]"
fi

# Redis has no HTTP endpoint — test using redis-cli inside the container
printf "  Redis (localhost:6379): "
if docker compose exec -T redis redis-cli ping 2>/dev/null | grep -q "PONG"; then
    echo "[UP] PONG"
else
    echo "[DOWN]"
fi

echo ""
echo "=== Deployment complete ==="
echo "API Docs: http://localhost:8080/docs"
```

#### Code: `local_deploy.ps1`

```powershell
# Exit immediately if any command fails
$ErrorActionPreference = "Stop"

Write-Host "=== Financial Agentic RAG - Local Deploy ==="

# -- Step 1: Ensure curl is available (built-in on Windows 10+, fallback to winget)
# curl is used at the end to verify all services are reachable.
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
# Check if .env exists. If not, copy from .env.example as a template.
# The .env file is required for Docker Compose to inject config into containers.
# If neither .env nor .env.example exist, exit with error — can't deploy without config.
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
# Docker Compose automatically skips containers that are already up.
# These use pre-built images and store data in persistent volumes,
# so we never rebuild or recreate them (avoids re-downloading models, losing embeddings, etc.)
Write-Host "[2/5] Ensuring infrastructure services are running..."
docker compose up -d ollama chromadb redis

# -- Step 4: Rebuild and redeploy application services (picks up code changes)
# --build          = rebuilds the Docker image from Dockerfile (picks up code changes)
# --force-recreate = stops and recreates containers even if config hasn't changed
# This ensures every run deploys the latest source code.
Write-Host "[3/5] Rebuilding and redeploying application services..."
docker compose up -d --build --force-recreate api mcp

# -- Step 5: Read model names from .env and pull if missing
# Filter lines matching the variable name, then strip the key and quotes.
# Then check if each model is already installed in the ollama container.
# If not installed, pull it. This avoids re-downloading ~5GB models on every deploy.
Write-Host "[4/5] Checking Ollama models..."

$envContent = Get-Content ".env"
$llmModel = ($envContent | Where-Object { $_ -match "^AGENT_LLM_MODEL=" }) -replace "^AGENT_LLM_MODEL=", "" -replace '"', ""
$embedModel = ($envContent | Where-Object { $_ -match "^RAG_EMBEDDING_MODEL=" }) -replace "^RAG_EMBEDDING_MODEL=", "" -replace '"', ""

# Get the ollama container ID dynamically (works regardless of project name)
$ollamaContainer = (docker compose ps -q ollama).Trim()

# Wait until ollama is ready to accept commands (it takes a few seconds to boot)
Write-Host "  Waiting for Ollama to be ready..."
do {
    Start-Sleep -Seconds 2
    $ready = docker exec $ollamaContainer ollama list 2>$null
} until ($LASTEXITCODE -eq 0)

# Get list of currently installed models
$installedModels = docker exec $ollamaContainer ollama list

# Check and pull LLM model if not present
if ($llmModel) {
    if ($installedModels -match $llmModel) {
        Write-Host "  [OK] LLM model '$llmModel' already installed."
    } else {
        Write-Host "  [PULL] Pulling LLM model '$llmModel'..."
        docker exec $ollamaContainer ollama pull $llmModel
    }
}

# Check and pull embedding model if not present
if ($embedModel) {
    if ($installedModels -match $embedModel) {
        Write-Host "  [OK] Embedding model '$embedModel' already installed."
    } else {
        Write-Host "  [PULL] Pulling embedding model '$embedModel'..."
        docker exec $ollamaContainer ollama pull $embedModel
    }
}

# -- Step 6: Verify all services are running with curl
# curl.exe is used explicitly to avoid PowerShell's built-in Invoke-WebRequest alias.
# Each service is tested against its health/status endpoint.
# Redis has no HTTP endpoint so it is tested via redis-cli ping inside the container.
Write-Host "[5/5] Verifying services..."
Write-Host ""

try {
    $apiResp = curl.exe -sf http://localhost:8080/health 2>$null
    Write-Host "  API (http://localhost:8080/health): [UP] $apiResp"
} catch {
    Write-Host "  API (http://localhost:8080/health): [DOWN]"
}

try {
    $ollamaResp = curl.exe -sf http://localhost:11434/ 2>$null
    Write-Host "  Ollama (http://localhost:11434): [UP] $ollamaResp"
} catch {
    Write-Host "  Ollama (http://localhost:11434): [DOWN]"
}

try {
    $chromaResp = curl.exe -sf http://localhost:8000/api/v1/heartbeat 2>$null
    Write-Host "  ChromaDB (http://localhost:8000/api/v1/heartbeat): [UP] $chromaResp"
} catch {
    Write-Host "  ChromaDB (http://localhost:8000/api/v1/heartbeat): [DOWN]"
}

# Redis has no HTTP endpoint — test using redis-cli inside the container
$redisResp = docker compose exec -T redis redis-cli ping 2>$null
if ($redisResp -match "PONG") {
    Write-Host "  Redis (localhost:6379): [UP] PONG"
} else {
    Write-Host "  Redis (localhost:6379): [DOWN]"
}

Write-Host ""
Write-Host "=== Deployment complete ==="
Write-Host "API Docs: http://localhost:8080/docs"
```

#### Redeployment Behavior

| Service | On re-run |
|---------|----------|
| `ollama` | Kept running (not touched) |
| `chromadb` | Kept running (not touched) |
| `redis` | Kept running (not touched) |
| `api` | Rebuilt and recreated (code changes deployed) |
| `mcp` | Rebuilt and recreated (code changes deployed) |
| LLM models | Only pulled if missing |
| Service verification | Always runs — prints [UP]/[DOWN] for each service |

---

## Git Basics

#### What is Git?

Git is a version control system that tracks changes in your code. It lets multiple developers work on the same project without overwriting each other's work.

#### Git Workflow (Proper Order)

```
Clone → Branch → Code → Add → Commit → Push → Pull Request → Merge
```

---

#### 1. Cloning a Repository

Cloning downloads a remote repository to your local machine.

```bash
git clone https://github.com/username/repository.git
cd repository
```

| Part | Explanation |
|------|-------------|
| `git clone <url>` | Downloads the entire repo (code + history) to your machine |
| `cd repository` | Enter the project folder |

---

#### 2. Creating a Branch

Branches let you work on features/fixes without affecting the main code.

```bash
# Create and switch to a new branch
git checkout -b feature/my-new-feature

# Or using newer syntax
git switch -c feature/my-new-feature
```

```bash
# List all branches
git branch

# Switch to an existing branch
git checkout main
```

| Command | Explanation |
|---------|-------------|
| `git checkout -b <name>` | Creates a new branch and switches to it |
| `git branch` | Lists all local branches (current branch marked with *) |
| `git checkout <name>` | Switches to an existing branch |

---

#### 3. Staging and Committing Changes

After making code changes, you need to stage and commit them.

```bash
# Check what files changed
git status

# Stage specific files
git add src/api/app.py

# Stage all changes
git add .

# Commit with a message
git commit -m "Add health check endpoint"
```

| Command | Explanation |
|---------|-------------|
| `git status` | Shows modified, staged, and untracked files |
| `git add <file>` | Stages a specific file for commit |
| `git add .` | Stages all changed files |
| `git commit -m "message"` | Saves staged changes with a description |

---

#### 4. Push (Upload to Remote)

Push sends your local commits to the remote repository (GitHub).

```bash
# Push current branch to remote
git push origin feature/my-new-feature

# First push (set upstream tracking)
git push -u origin feature/my-new-feature
```

| Command | Explanation |
|---------|-------------|
| `git push origin <branch>` | Uploads your commits to the remote branch |
| `-u origin <branch>` | Sets upstream so future pushes only need `git push` |

---

#### 5. Pull (Download + Merge from Remote)

Pull downloads the latest changes from the remote and merges them into your current branch.

```bash
# Pull latest changes from remote
git pull origin main

# Pull current branch
git pull
```

| Command | Explanation |
|---------|-------------|
| `git pull origin <branch>` | Fetches + merges remote changes into your local branch |
| `git pull` | Pulls from the tracked upstream branch |

---

#### 6. Fetch (Download Without Merging)

Fetch downloads remote changes but does NOT merge them. Useful to see what others have pushed before merging.

```bash
# Fetch all remote changes
git fetch origin

# See what's new
git log origin/main --oneline
```

| Command | Explanation |
|---------|-------------|
| `git fetch origin` | Downloads remote changes without modifying your local code |
| `git log origin/main` | View remote commits that haven't been merged locally |

**Pull vs Fetch:**
- `git fetch` = download only (safe, no changes to your code)
- `git pull` = `git fetch` + `git merge` (downloads and applies changes)

---

#### 7. Pull Request (PR)

A Pull Request is a request to merge your branch into another branch (usually `main`). It's created on GitHub (not a git command) and allows:
- Code review by team members
- Discussion and feedback
- Automated tests to run before merging

**How to create a PR:**
1. Push your branch to remote: `git push -u origin feature/my-new-feature`
2. Go to GitHub → your repository
3. Click "Compare & pull request"
4. Add title, description, and reviewers
5. Click "Create pull request"

---

#### 8. Merge

Merge combines changes from one branch into another.

```bash
# Switch to the branch you want to merge INTO
git checkout main

# Merge the feature branch into main
git merge feature/my-new-feature

# Delete the branch after merge (cleanup)
git branch -d feature/my-new-feature
```

| Command | Explanation |
|---------|-------------|
| `git merge <branch>` | Merges the specified branch into your current branch |
| `git branch -d <branch>` | Deletes a branch that has been merged |

> **Note:** In team workflows, merging is usually done via Pull Requests on GitHub, not locally.

---

#### Git Commands Quick Reference

| Command | Description |
|---------|-------------|
| `git clone <url>` | Download a repository |
| `git checkout -b <branch>` | Create and switch to new branch |
| `git status` | Check file changes |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit staged changes |
| `git push origin <branch>` | Upload to remote |
| `git pull origin <branch>` | Download and merge from remote |
| `git fetch origin` | Download without merging |
| `git merge <branch>` | Merge branch into current branch |
| `git log --oneline` | View commit history |
| `git branch` | List branches |
| `git branch -d <branch>` | Delete merged branch |

---

## References

| Topic | Link |
|-------|------|
| Docker Basics | https://www.youtube.com/watch?v=_dfLOzuIg2o |
| Postman (Download) | https://www.postman.com/downloads/ |
| Use GET & POST with Postman | https://www.youtube.com/watch?v=pUGmhtqVJRk |
| Use GET & POST with curl | https://www.youtube.com/watch?v=q2sqkvXzsw8 |
| Build GET & POST with FastAPI | https://www.youtube.com/watch?v=vGl-L7K4hXA |
