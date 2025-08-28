FROM python:3.10-slim   # Stick to Python 3.10 for sklearn compatibility

RUN apt-get update && apt-get install -y curl bash \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create app user
RUN adduser --disabled-password appuser

WORKDIR /app

# Copy requirements and install exact versions
COPY app/requirements.txt requirements.txt

# Force sklearn + numpy versions compatible with your model
RUN pip install --upgrade pip && \
    pip install numpy==1.23.5 scikit-learn==1.1.3 && \
    pip install -r requirements.txt

# Copy application code
COPY app/ ./

RUN chown -R appuser /app
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

CMD ["python", "app.py"]