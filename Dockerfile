# Use Python 3.10 instead of 3.12 (sklearn 1.1.3 is compatible)
FROM python:3.10-slim

# Install basic utilities
RUN apt-get update && apt-get install -y curl bash \
    && rm -rf /var/lib/apt/lists/*

# Prevent Python from writing .pyc files & enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create non-root user
RUN adduser --disabled-password appuser

WORKDIR /app

# Copy requirements first (for caching)
COPY app/requirements.txt requirements.txt

# Upgrade pip/setuptools/wheel before installing requirements
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

# Copy application code
COPY app/ ./

# Set ownership to non-root user
RUN chown -R appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Run the app
CMD ["python", "app.py"]
