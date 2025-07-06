terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_pubsub_topic" "iaac_test2" {
  name = var.pubsub_topic_name
}

resource "google_pubsub_subscription" "iaac_test2_sub" {
  name  = "${var.pubsub_topic_name}-sub"
  topic = google_pubsub_topic.iaac_test2.id
}

resource "google_compute_instance" "flask_app" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    GOOGLE_CREDENTIALS = file(var.service_account_key_path)  # JSON key content
    WEATHER_API_KEY     = var.weather_api_key                # Define in tfvars or secrets
    GCP_PROJECT_ID      = var.project_id
    PUBSUB_TOPIC_ID     = var.pubsub_topic_name
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  tags = ["flask-app"]
}

resource "google_compute_firewall" "flask_app_allow_http" {
  name    = "flask-app-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["flask-app"]
}
