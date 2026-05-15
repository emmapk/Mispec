FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies (required for Postgres and Geocoding)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Note: We do not run collectstatic here because python-decouple requires all env vars to be present.
# Instead, we run it in the startup command below.

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# The default command runs collectstatic first, then starts Gunicorn
CMD ["sh", "-c", "python manage.py collectstatic --noinput && gunicorn --bind 0.0.0.0:8080 --workers 2 --timeout 120 mispec.wsgi:application"]
