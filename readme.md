# FastAPI Dockerized Application

A concise reference for spinning up the **FastAPI** service in a containerised environment on Windows (PowerShell commands shown).

---

\## Prerequisites 

|  Requirement             |  Purpose                              |
| ------------------------ | ------------------------------------- |
|  Docker Desktop          | Builds & runs containers              |
|  Docker Compose (v2)     |  Orchestrates multi‑container stacks  |
|  Python 3.11 (optional)  |  For running the app outside Docker   |

---

\## Project layout

```
personal-code-files/
│   main.py
│   requirements.txt
│   Dockerfile
│   docker-compose.yml   # (create in the next section)
└── .dockerignore
```

---

\## Running locally (skip if using only Docker)

```powershell
python -m venv .venv
.\.venv\Scripts\Activate
pip install -r requirements.txt
uvicorn main:app --reload  # http://localhost:8000/docs
```

---

\## Building the Docker image

```powershell
cd "D:\Code\Personal Code files"
docker build -t fastapi_app_sayan .
```

- `-t fastapi_app_sayan` tags the image for easy reference.
- `.` supplies the build context (current folder).

\### Key lines inside `Dockerfile`

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

\## Running a container directly

```powershell
# Detached, mapped to host 8000, custom name
docker run -d -p 8000:8000 --name veryfastapp fastapi_app_sayan
```

Visit [**http://localhost:8000/docs**](http://localhost:8000/docs) to verify.

\### Useful container commands

```powershell
docker ps                          # list running containers
docker logs veryfastapp            # live / historic logs
docker stop veryfastapp            # stop
docker rm veryfastapp              # remove (after stopping)
```

---

\## Docker Compose If you prefer one‑command startup (and easy extension with databases, Redis, etc.) add this `docker-compose.yml` to the project root:

```yaml
version: "3.9"

services:
  web:
    build: .
    container_name: fastapi_app
    ports:
      - "8000:8000"
    volumes:
      - .:/app         # hot‑reload during development
    command: >
      uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

\### Compose lifecycle

```powershell
docker compose up          # build & run in foreground
docker compose up -d       # run detached
docker compose down        # stop & delete containers
```

\### Rebuilding after code changes

```powershell
docker compose build       # or: docker build -t fastapi_app_sayan .
```

---

\## Adding a PostgreSQL service (optional)

```yaml
services:
  web:
    build: .
    ...
    depends_on:
      - db
  db:
    image: postgres:14
    environment:
      POSTGRES_USER: fastapi
      POSTGRES_PASSWORD: fastapi
      POSTGRES_DB: fastapidb
    ports:
      - "5432:5432"
```

---

\## Troubleshooting checklist

1. **App unreachable?** Ensure `--host 0.0.0.0` is in the `uvicorn` command.
2. **Port conflict?** Change host side: `-p 8080:8000` then browse `localhost:8080`.
3. **Container won’t start?** Run `docker logs <name>` and check for import errors or missing env vars.
4. **Image feels stale?** Rebuild: `docker compose build --no-cache`.

---

\## Clean‑up helpers

```powershell
# stop & remove everything plus images, volumes & orphans
docker compose down --rmi all --volumes --remove-orphans

# remove dangling images
docker image prune -f
```

---

\## Sample `.dockerignore`

```
__pycache__/
*.py[cod]
.venv/
.env
```

Happy shipping! 🚀

