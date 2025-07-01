output "pubsub_topic_id" {
  value = google_pubsub_topic.iaac_test2.id
}

output "flask_app_external_ip" {
  value = google_compute_instance.flask_app.network_interface[0].access_config[0].nat_ip
}

output "pubsub_subscription_id" {
  value = google_pubsub_subscription.iaac_test2_sub.id
}
