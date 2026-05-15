#!/bin/bash
# start_workers.sh - Runs multiple Celery processes in a single container for Koyeb's Free Tier

echo "Starting Celery worker (Default Queue)..."
celery -A mispec worker --loglevel=info &

echo "Starting Celery Beat (Scheduler)..."
celery -A mispec beat --loglevel=info --scheduler django_celery_beat.schedulers:DatabaseScheduler &

echo "Starting Geocoding Worker..."
celery -A mispec worker -Q geocoding_queue --loglevel=info &

echo "All workers started. Waiting for processes..."
# Wait for any process to exit. If one fails, the container should ideally restart.
wait -n
