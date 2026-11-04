FROM python:3.10-slim AS dependencies

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8003

COPY requirements.txt .

RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

FROM python:3.10-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=8003
RUN --mount=from=dependencies,source=/wheels,target=/wheels \
    pip install --no-cache-dir --no-index /wheels/* \
    && useradd --system --uid 10001 app

COPY app.py .
USER 10001

EXPOSE 8003

CMD ["gunicorn", "--bind", "0.0.0.0:8003", "app:app"]
