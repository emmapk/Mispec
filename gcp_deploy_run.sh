#!/bin/bash

# Ensure your .env file is populated before deploying!

REGION="us-central1"

if [ ! -f .env ]; then
    echo "❌ ERROR: .env file not found! Please create it before deploying."
    exit 1
fi

echo "🚀 Converting .env to yaml format..."
cat << 'EOF' > env_to_yaml.py
import sys
import yaml

env_dict = {}
with open('.env', 'r') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split('=', 1)
        if len(parts) == 2:
            key = parts[0].strip()
            val = parts[1].strip()
            env_dict[key] = val

with open('env.yaml', 'w') as f:
    yaml.dump(env_dict, f)
EOF

python3 env_to_yaml.py

echo "🚀 Deploying Mispec Web App to Cloud Run..."

gcloud run deploy mispec-web \
    --source . \
    --region $REGION \
    --allow-unauthenticated \
    --max-instances 3 \
    --min-instances 0 \
    --env-vars-file=env.yaml

echo "=========================================================================="
echo "✅ Cloud Run Deployment Initiated!"
echo "=========================================================================="
