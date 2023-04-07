resource "google_compute_network" "gke" {
  depends_on = [
    google_project_service.apis["compute.googleapis.com"],
    github_repository_deploy_key.argocd_delivery_deploy_key,
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
  ]

  # PROVISIONING
  ######################################################################################################################
  provider         = google-beta
  location         = var.gcp_region
  name             = "main"
  description      = "Main cluster."
  enable_autopilot = true
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

  # NETWORKING
  ######################################################################################################################
  network         = google_compute_network.gke.self_link
  networking_mode = "VPC_NATIVE"

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
