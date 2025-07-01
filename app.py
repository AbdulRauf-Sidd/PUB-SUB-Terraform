from flask import Flask, jsonify
import requests
from apscheduler.schedulers.background import BackgroundScheduler
import logging
import os
from google.cloud import pubsub_v1
import json
from dotenv import load_dotenv

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)

# Load environment variables from .env if present
load_dotenv()

# Set GOOGLE_APPLICATION_CREDENTIALS from .env if provided
# GCP_CREDENTIALS_PATH = os.getenv('GOOGLE_APPLICATION_CREDENTIALS', "true-area-464010-j9-670d93d05dcd.json")
# if GCP_CREDENTIALS_PATH:
#     os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = GCP_CREDENTIALS_PATH

# Weather API configuration
WEATHER_API_KEY = os.getenv('WEATHER_API_KEY', '169a2c7b9ceb47849d2175634253006')
WEATHER_API_URL = f"https://api.weatherapi.com/v1/current.json?key={WEATHER_API_KEY}&q=Australia&aqi=no"

# GCP Pub/Sub configuration
GCP_PROJECT_ID = os.getenv('GCP_PROJECT_ID', 'true-area-464010-j9')
# PUBSUB_TOPIC_ID = os.getenv('PUBSUB_TOPIC_ID', 'iaac-test')
PUBSUB_TOPIC_ID = 'iaac-topic'

# Store the latest weather data
data_cache = {}

# Publisher client (reuse for efficiency)
publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(GCP_PROJECT_ID, PUBSUB_TOPIC_ID)

def publish_weather_alert(data):
    try:
        message_json = json.dumps(data).encode('utf-8')
        print(message_json)
        future = publisher.publish(topic_path, message_json)
        future.result(timeout=10)
        logging.info(f"Published weather alert to Pub/Sub topic {PUBSUB_TOPIC_ID}.")
    except Exception as e:
        logging.error(f"Failed to publish to Pub/Sub: {e}")

def fetch_weather():
    try:
        response = requests.get(WEATHER_API_URL, timeout=10)
        response.raise_for_status()
        data = response.json()
        data_cache['weather'] = data
        logging.info("Weather data fetched successfully.")
        publish_weather_alert(data)  # Publish to Pub/Sub on success
    except Exception as e:
        logging.error(f"Failed to fetch weather data: {e}")

# Schedule the weather fetch every 5 minutes
scheduler = BackgroundScheduler(daemon=True)
scheduler.add_job(fetch_weather, 'interval', minutes=1)
scheduler.start()

@app.route('/weather', methods=['GET'])
def get_weather():
    if 'weather' in data_cache:
        return jsonify(data_cache['weather'])
    else:
        return jsonify({'error': 'No weather data available.'}), 503

if __name__ == '__main__':
    fetch_weather()  # Initial fetch
    app.run(host='0.0.0.0', port=5000) 