data "google_container_engine_versions" "default" {
  provider       = google-beta
  location       = var.gcp_zone
  version_prefix = "1.24."
}

resource "google_compute_network" "gke" {
  depends_on = [
    google_project_service.apis["compute.googleapis.com"],
  ]

  project                         = data.google_project.project.project_id
  name                            = "gke"
  description                     = "GKE VPC"
  auto_create_subnetworks         = true
  delete_default_routes_on_create = false
}

resource "google_container_cluster" "primary" {
  depends_on = [
    google_project_service.apis["compute.googleapis.com"],
    google_project_service.apis["container.googleapis.com"],
    google_service_account_iam_member.gke-node_gha-arikkfir-infrastructure_iam_serviceAccountUser,
    google_service_account_iam_member.default-compute-gha-arikkfir-infrastructure-iam-serviceAccountUser,
  ]

  # PROVISIONING
  ######################################################################################################################
  provider    = google-beta
  location    = var.gcp_zone
  name        = "primary"
  description = "Primary cluster."
  timeouts {
    create = "60m"
    update = "60m"
  }

  # ADDONS
  ######################################################################################################################
  addons_config {
    config_connector_config {
      enabled = true
    }
    http_load_balancing {
      disabled = true
    }
  }

  # SCALING
  # - must specify "initial_node_count" and "remove_default_node_pool" to enable external node pools
  # - see: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#remove_default_node_pool
  ######################################################################################################################
  initial_node_count       = 1
  remove_default_node_pool = true
  cluster_autoscaling {
    enabled             = false
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }

  # NETWORKING
  ######################################################################################################################
  network         = google_compute_network.gke.self_link
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    # previously used "10.110.0.0/17"
    cluster_ipv4_cidr_block = ""
    # previously used "10.110.128.0/17"
    services_ipv4_cidr_block = ""
  }

  # OPERATIONS
  ######################################################################################################################
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  release_channel {
    channel = "UNSPECIFIED"
  }
  cluster_telemetry {
    type = "ENABLED"
  }
  #  logging_service = "logging.googleapis.com/kubernetes"
  #  logging_config {
  #    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  #  }
  #  monitoring_service = "monitoring.googleapis.com/kubernetes"
  #  monitoring_config {
  #    enable_components = ["SYSTEM_COMPONENTS"]
  #    managed_prometheus {
  #      enabled = true
  #    }
  #  }

  # SECURITY
  ######################################################################################################################
  authenticator_groups_config {
    security_group = "gke-security-groups@${data.google_organization.kfirfamily.domain}"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
}
