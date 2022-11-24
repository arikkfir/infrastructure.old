resource "google_container_node_pool" "workloads" {
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.system
  ]

  # PROVISIONING
  ######################################################################################################################
  provider = google-beta
  cluster  = google_container_cluster.primary.name
  name     = "workloads"
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
    labels = {
      "gke.kfirs.com/purpose" : "workloads"
    }
    spot = true
    taint {
      key    = "gke.kfirs.com/purpose"
      value  = "workloads"
      effect = "NO_EXECUTE"
    }
  }

  # SCALING
  ######################################################################################################################
  autoscaling {
    max_node_count  = 3
    min_node_count  = 0
    location_policy = "ANY"
  }

  # OPERATIONS
  ######################################################################################################################
  version = data.google_container_engine_versions.default.latest_node_version
  management {
    auto_repair  = true
    auto_upgrade = false
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
