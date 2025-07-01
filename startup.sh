#!/bin/bash
# Install system dependencies
apt-get update
apt-get install -y python3-pip git

# Create directory for GCP credentials
mkdir -p /etc/gcp

# Write the service account key from instance metadata
echo "$GOOGLE_CREDENTIALS" > /etc/gcp/key.json

# Clone the application repository (replace with your repo URL)
git clone https://github.com/yourusername/your-flask-weather-app.git /opt/flask-app
cd /opt/flask-app

# Install Python dependencies
pip3 install -r requirements.txt

# Set environment variables (replace with actual values or use metadata)
export WEATHER_API_KEY="${WEATHER_API_KEY}"
export GCP_PROJECT_ID="${GCP_PROJECT_ID}"
export PUBSUB_TOPIC_ID="${PUBSUB_TOPIC_ID}"
export GOOGLE_APPLICATION_CREDENTIALS="/etc/gcp/key.json"

# Start the Flask app
nohup python3 app.py & 