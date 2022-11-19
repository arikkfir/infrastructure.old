resource "google_container_cluster" "primary" {
  depends_on = [
    google_project_service.apis["compute.googleapis.com"],
    google_project_service.apis["container.googleapis.com"],
    google_service_account_iam_member.gke-node_gha-arikkfir-infrastructure_iam_serviceAccountUser,
    google_service_account_iam_member.default-compute-gha-arikkfir-infrastructure-iam-serviceAccountUser,
  ]

  # Provisioning
  provider    = google-beta
  project     = data.google_project.project.project_id
  location    = var.gcp_zone
  name        = "primary"
  description = "Primary cluster."
  release_channel {
    channel = "RAPID"
  }

  addons_config {
    config_connector_config {
      enabled = true
    }
    http_load_balancing {
      disabled = true
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
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  # Security
  authenticator_groups_config {
    security_group = "gke-security-groups@${data.google_organization.kfirfamily.domain}"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
}
