resource "google_compute_network" "gke" {
  project = google_project.project.project_id
  depends_on = [
    google_project_service.apis
  ]
  name = "gke"
  description = "GKE VPC"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnet" {
  project = google_project.project.project_id
  name = "gke-subnet-${var.gcp_region}"
  network = google_compute_network.gke.id
  region = var.gcp_region
  ip_cidr_range = "10.100.0.0/16"

  secondary_ip_range {
    range_name = "gke-production-pods"
    ip_cidr_range = "10.110.0.0/17" # 10.110.0.0 - 10.110.127.255
  }
  secondary_ip_range {
    range_name = "gke-production-services"
    ip_cidr_range = "10.110.128.0/17" # 10.110.128.0 - 10.110.255.255
  }
}

resource "google_service_account" "kubernetes" {
  project = google_project.project.project_id
  account_id = "kubernetes"
  display_name = "Kubernetes nodes service account"
}

resource "google_project_iam_member" "kubernetes_log_writer" {
  project = google_project.project.project_id
  role = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
}

resource "google_project_iam_member" "kubernetes_metrics_writer" {
  project = google_project.project.project_id
  role = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
}

resource "google_service_account" "config_connector" {
  project = google_project.project.project_id
  account_id = "config-connector"
  display_name = "Config Connector"
}

resource "google_project_iam_member" "config_connector_owner" {
  project = google_project.project.project_id
  role = "roles/owner"
  member = "serviceAccount:${google_service_account.config_connector.email}"
}

resource "google_service_account_iam_member" "config_connector_workload_identity" {
  service_account_id = google_service_account.config_connector.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${google_project.project.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
}

resource "google_container_cluster" "production" {
  depends_on = [
    google_compute_subnetwork.gke_subnet
  ]

  project = google_project.project.project_id
  provider = google-beta
  name = "production"
  location = var.gcp_zone

  # Get upgrades faster
  release_channel {
    channel = "RAPID"
  }

  # These two settings together are required as they are, to use standalone node-pool resources
  # DO NOT CHANGE.
  initial_node_count = 1
  remove_default_node_pool = true

  # Security
  authenticator_groups_config {
    security_group = "gke-security-groups@kfirfamily.com"
  }
  workload_identity_config {
    identity_namespace = "${google_project.project.project_id}.svc.id.goog"
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = true
    }
    config_connector_config {
      enabled = true
    }
  }

  # Networking
  network = google_compute_network.gke.self_link
  subnetwork = google_compute_subnetwork.gke_subnet.self_link
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name = "gke-production-pods"
    services_secondary_range_name = "gke-production-services"
  }
}

resource "google_container_node_pool" "n2-standard-2" {
  project = google_container_cluster.production.project
  cluster = google_container_cluster.production.name
  name = "n2-standard-2"
  location = var.gcp_zone
  initial_node_count = 1
  autoscaling {
    min_node_count = 0
    max_node_count = 8
  }
  management {
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    machine_type = "n2-standard-2"
    preemptible = true
    disk_size_gb = 100
    disk_type = "pd-standard"
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
  upgrade_settings {
    max_surge = 1
    max_unavailable = 0
  }
}

resource "google_container_node_pool" "n2-standard-4" {
  project = google_container_cluster.production.project
  cluster = google_container_cluster.production.name
  name = "n2-standard-4"
  location = var.gcp_zone
  initial_node_count = 1
  autoscaling {
    min_node_count = 0
    max_node_count = 8
  }
  management {
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    machine_type = "n2-standard-4"
    preemptible = true
    disk_size_gb = 100
    disk_type = "pd-standard"
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
  upgrade_settings {
    max_surge = 1
    max_unavailable = 0
  }
}
