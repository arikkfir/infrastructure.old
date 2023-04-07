resource "google_container_node_pool" "system" {
  # PROVISIONING
  ######################################################################################################################
  provider = google-beta
  cluster  = google_container_cluster.main.name
  name     = "system"
  location = var.gcp_region

  # NODES
  ######################################################################################################################
  node_locations = [var.gcp_region]
  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    machine_type = "e2-standard-8"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    service_account = google_service_account.gke-node.email
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    labels = {
      "gke.kfirs.com/purpose" : "system"
    }
    spot = true
  }

  # SCALING
  ######################################################################################################################
  autoscaling {
    min_node_count       = 0
    max_node_count       = 2
    total_min_node_count = 1
    total_max_node_count = 3
    location_policy      = "ANY"
  }

  # OPERATIONS
  ######################################################################################################################
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  upgrade_settings {
    max_surge       = 3
    max_unavailable = 0
  }

  # LIFECYCLE
  ######################################################################################################################
  lifecycle {
    ignore_changes = [
      # see https://github.com/hashicorp/terraform-provider-google/issues/6901#issuecomment-667369691
      initial_node_count,

      # see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#taint
      node_config.0.taint
    ]
  }
}
