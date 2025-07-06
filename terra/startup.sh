#!/bin/bash

    # Create credentials directory
    mkdir -p /etc/gcp
    sudo apt-get update && sudo apt-get install -y git
    git clone https://github.com/AbdulRauf-Sidd/PUB-SUB-Terraform.git /opt/flask-app

    # Write service account key to file from metadata
    export WEATHER_API_KEY=$(curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/WEATHER_API_KEY")
    export GCP_PROJECT_ID=$(curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCP_PROJECT_ID")
    export PUBSUB_TOPIC_ID=$(curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/PUBSUB_TOPIC_ID")
    export GOOGLE_CREDENTIALS=$(curl -s -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GOOGLE_CREDENTIALS")


    echo "$GOOGLE_CREDENTIALS" > /etc/gcp/key.json
    export GOOGLE_APPLICATION_CREDENTIALS="/etc/gcp/key.json"

    # Write .env file
    cat <<EOF > /opt/flask-app/.env
    WEATHER_API_KEY="$${WEATHER_API_KEY}"
    GCP_PROJECT_ID="$${GCP_PROJECT_ID}"
    PUBSUB_TOPIC_ID="$${PUBSUB_TOPIC_ID}"
    EOF

    # Clone and start app
    cd /opt/flask-app
    sudo apt-get update
    touch aptupdated.txt
    sudo apt-get install -y python3-pip
    touch pipinstalled.txt
    pip install -r requirements.txt
    touch requirementsinstalled.txt
    nohup python3 app.py &
    touch appstarted.txt