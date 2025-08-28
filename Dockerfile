
FROM python:3.12-slim

RUN apt-get update && apt-get install -y curl bash \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
	
RUN adduser --disbaled-password appuser

WORKDIR /app

COPY app/requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY app/ ./

RUN chown -R appuser /app

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

CMD ["python", "app.py"]
