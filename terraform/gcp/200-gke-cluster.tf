resource "google_container_cluster" "production" {
  provider = google-beta
  depends_on = [
    google_compute_subnetwork.gke_subnet
  ]

  name = "production"
  description = "Production cluster."
  location = var.gcp_zone
  project = google_project.project.project_id

  release_channel {
    channel = "RAPID"
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = true
    }
    network_policy_config {
      disabled = true
    }
    cloudrun_config {
      disabled = true
    }
    istio_config {
      disabled = true
    }
    dns_cache_config {
      enabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = false
    }
    kalm_config {
      enabled = false
    }
    config_connector_config {
      enabled = true
    }
  }

  # Scaling
  initial_node_count = 1  # this and "remove_default_node_pool" must be set as they are, since we're using custom node pools
  remove_default_node_pool = true # this and "initial_node_count" must be set as they are, since we're using custom node pools
  cluster_autoscaling {
    enabled = false
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }

  # Security
  authenticator_groups_config {
    security_group = "gke-security-groups@kfirfamily.com"
  }
  workload_identity_config {
    workload_pool = "${google_project.project.project_id}.svc.id.goog"
  }

  # Networking
  network = google_compute_network.gke.self_link
  networking_mode = "VPC_NATIVE"
  enable_intranode_visibility = true
  subnetwork = google_compute_subnetwork.gke_subnet.self_link
  ip_allocation_policy {
    cluster_secondary_range_name = "gke-production-pods"
    services_secondary_range_name = "gke-production-services"
  }

  # Operations
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = [ "SYSTEM_COMPONENTS", "WORKLOADS" ]
  }
}
