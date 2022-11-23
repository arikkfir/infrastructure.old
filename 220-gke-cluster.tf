# TODO: set cluster version explicitly
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
  project     = data.google_project.project.project_id
  location    = var.gcp_zone
  name        = "primary"
  description = "Primary cluster."
  timeouts {
    create = "30m"
    update = "40m"
  }

  # VERSIONING
  ######################################################################################################################
  min_master_version = "1.25.3-gke.800"
  release_channel {
    channel = "UNSPECIFIED"
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
  ######################################################################################################################
  initial_node_count = 1
  node_version       = "1.25.3-gke.800"
  node_config {
    disk_size_gb = 50
    disk_type    = "pd-standard"
    machine_type = "n2-custom-4-7168"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    preemptible     = false
    service_account = google_service_account.gke-node.email
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  cluster_autoscaling {
    enabled             = false
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }

  # NETWORKING
  ######################################################################################################################
  network                  = google_compute_network.gke.self_link
  networking_mode          = "VPC_NATIVE"
  subnetwork               = google_compute_subnetwork.gke-subnet.self_link
  enable_l4_ilb_subsetting = true
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  # OPERATIONS
  ######################################################################################################################
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    managed_prometheus {
      enabled = true
    }
  }

  # SECURITY
  ######################################################################################################################
  authenticator_groups_config {
    security_group = "gke-security-groups@${data.google_organization.kfirfamily.domain}"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
}
