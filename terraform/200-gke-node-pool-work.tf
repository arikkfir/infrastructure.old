resource "google_container_node_pool" "work-n2-custom-4-5120-pre" {
  project = google_container_cluster.production.project
  cluster = google_container_cluster.production.name
  name = "work-n2-custom-4-5120-pre"
  location = var.gcp_zone

  # Scaling
  initial_node_count = 0
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
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    machine_type = "n2-custom-4-5120"
    preemptible = true
    disk_size_gb = 100
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    labels = {
      "kfirs.com/workload-nodes" = "true"
    }
    taint = [ {
      effect = "NO_EXECUTE"
      key = "kfirs.com/workload-nodes"
      value = "true"
    } ]
  }
  upgrade_settings {
    max_surge = 3
    max_unavailable = 0
  }
}
