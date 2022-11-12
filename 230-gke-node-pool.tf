resource "google_container_node_pool" "n2-custom-4-7168-pre" {
  project  = google_container_cluster.primary.project
  cluster  = google_container_cluster.primary.name
  name     = "n2-custom-4-7168"
  location = var.gcp_zone

  # Scaling
  initial_node_count = 1
  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }
  lifecycle {
    ignore_changes = [
      initial_node_count # see https://github.com/hashicorp/terraform-provider-google/issues/6901#issuecomment-667369691
    ]
  }

  # Operations
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  upgrade_settings {
    max_surge       = 3
    max_unavailable = 3
  }

  # Node configuration
  node_config {
    machine_type    = "n2-custom-4-7168"
    preemptible     = true
    disk_size_gb    = 50
    service_account = google_service_account.gke-node.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
