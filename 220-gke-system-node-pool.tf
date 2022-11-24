resource "google_container_node_pool" "system" {
  depends_on = [
    google_container_cluster.primary,
  ]

  # PROVISIONING
  ######################################################################################################################
  provider = google-beta
  cluster  = google_container_cluster.primary.name
  name     = "system"
  location = var.gcp_zone

  # NODES
  ######################################################################################################################
  node_locations = [var.gcp_zone]
  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    service_account = google_service_account.gke-node.email
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  # SCALING
  ######################################################################################################################
  autoscaling {
    max_node_count = 2
    min_node_count = 1
  }

  # OPERATIONS
  ######################################################################################################################
  version = data.google_container_engine_versions.default.latest_node_version
  management {
    auto_repair  = true
    auto_upgrade = false
  }
  upgrade_settings {
    max_surge       = 2
    max_unavailable = 0
  }
}