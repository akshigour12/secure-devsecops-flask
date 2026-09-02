# Use latest Python slim image
FROM python:3.13-slim

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser

# Set working directory
WORKDIR /app

# Copy dependency file first
COPY requirements.txt .

# Upgrade pip & setuptools and install dependencies
RUN python -m pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Copy application source
COPY . .

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 5000

# Start application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
