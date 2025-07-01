variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "australia-southeast1"
}

variable "zone" {
  description = "The GCP zone for the compute instance"
  type        = string
  default     = "australia-southeast1-b"
}

variable "pubsub_topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
  default     = "weather-alerts"
}

variable "instance_name" {
  description = "The name of the compute instance"
  type        = string
  default     = "flask-weather-app"
}

variable "machine_type" {
  description = "The machine type for the compute instance"
  type        = string
  default     = "e2-micro"
}

variable "boot_disk_image" {
  description = "The image for the boot disk"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "service_account_email" {
  description = "The email of the service account to attach to the instance"
  type        = string
}

variable "service_account_key_path" {
  description = "The path to the service account JSON key file"
  type        = string
  default     = "true-area-464010-j9-670d93d05dcd.json"
} 