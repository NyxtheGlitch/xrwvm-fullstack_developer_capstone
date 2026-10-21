# ---------- Stage 1: build the React frontend ----------
# This stage only exists to produce frontend/build. Node and all the
# node_modules stay behind in this stage; they never reach the final image.
FROM node:20-slim AS frontend-build
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# ---------- Stage 2: the Django app ----------
FROM python:3.12-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Install dependencies first so Docker can cache this layer
# when only the app code changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY --from=frontend-build /frontend/build ./frontend/build

# Gather static files (including the React build) into /app/static.
RUN python manage.py collectstatic --noinput

# Run as a normal user instead of root. /data holds the SQLite database
# and is where the compose file mounts a persistent volume.
RUN useradd --create-home --uid 1000 app \
    && mkdir /data \
    && chown -R app:app /app /data
USER app

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "djangoproj.wsgi"]
