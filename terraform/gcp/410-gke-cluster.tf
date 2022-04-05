resource "google_container_cluster" "primary" {
  depends_on = [
    google_compute_subnetwork.gke-subnet
  ]

  # Provisioning
  provider    = google-beta
  project     = google_project.project.project_id
  location    = var.gcp_zone
  name        = "primary"
  description = "Primary cluster."
  release_channel {
    channel = "RAPID"
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
    config_connector_config {
      enabled = true
    }
  }

  # Scale
  cluster_autoscaling {
    enabled             = false
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }
  initial_node_count       = 1
  remove_default_node_pool = true

  # Networking
  network         = google_compute_network.gke.self_link
  networking_mode = "VPC_NATIVE"
  subnetwork      = google_compute_subnetwork.gke-subnet.self_link
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  # Operations
  cluster_telemetry {
    type = "ENABLED"
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  resource_usage_export_config {
    enable_network_egress_metering       = false
    enable_resource_consumption_metering = true
    bigquery_destination {
      dataset_id = "cluster_resource_usage"
    }
  }

  # Security
  authenticator_groups_config {
    security_group = "gke-security-groups@${data.google_organization.kfirfamily.domain}"
  }
  workload_identity_config {
    workload_pool = "${google_project.project.project_id}.svc.id.goog"
  }
}
