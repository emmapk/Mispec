#!/bin/bash
# Run this from your local terminal where gcloud is installed and authenticated

REGION="us-central1"
ZONE="us-central1-a"
VM_NAME="mispec-celery-vm"
# Grab the current project
PROJECT_ID=$(gcloud config get-value project)

echo "🚀 Enabling necessary GCP APIs..."
gcloud services enable compute.googleapis.com run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com

echo "🖥️ Creating Always-Free e2-micro VM for Celery Workers..."
gcloud compute instances create $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --network-interface=network-tier=STANDARD,subnet=default \
    --tags=http-server,https-server \
    --metadata=startup-script="#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose git
sudo systemctl enable docker
sudo systemctl start docker

mkdir -p /opt/mispec
"

echo "⏳ Waiting 30 seconds for VM initialization..."
sleep 30

EXTERNAL_IP=$(gcloud compute instances describe $VM_NAME --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "=========================================================================="
echo "✅ VM Setup Complete!"
echo "Your VM is ready at IP: $EXTERNAL_IP"
echo "You can SSH into it later to run your docker-compose file."
echo "=========================================================================="
