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

resource "google_container_cluster" "main" {
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
  name        = "main"
  description = "Main cluster."
  timeouts {
    create = "60m"
    update = "60m"
  }

  # ADDONS
  ######################################################################################################################
  addons_config {
    //noinspection HCLUnknownBlockType
    config_connector_config {
      enabled = true
    }
    http_load_balancing {
      disabled = true
    }
  }

  # SCALING
  # It appears that unless I keep the default node pool, cluster does not function properly; see case 44318169.
  # Therefore, I'm keeping the default node pool as the system/core node pool, and adding a new one for my workloads.
  ######################################################################################################################
  initial_node_count       = 1
  remove_default_node_pool = false
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
    spot = true
    labels = {
      "gke.kfirs.com/purpose" : "system"
    }
  }
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
  release_channel {
    channel = "RAPID"
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
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
