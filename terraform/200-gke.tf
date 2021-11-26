resource "google_compute_network" "gke" {
  project = google_project.project.project_id
  depends_on = [
    google_project_service.apis
  ]
  name = "gke"
  description = "GKE VPC"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
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
  enable_autopilot = false
  initial_node_count = 1  # this and "remove_default_node_pool" must be set as they are, since we're using custom node pools
  remove_default_node_pool = true # this and "initial_node_count" must be set as they are, since we're using custom node pools
  cluster_autoscaling {
    enabled = false
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
  logging_service = "logging.googleapis.com/kubernetes"
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  maintenance_policy {
    recurring_window {
      start_time = "2021-12-01T04:00:00+2"
      end_time = "2021-12-01T08:00:00+2"
      recurrence = "FREQ=WEEKLY"
    }
  }
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  monitoring_config {
    enable_components = [ "SYSTEM_COMPONENTS", "WORKLOADS" ]
  }
  cluster_telemetry {
    type = "ENABLED"
  }
}

resource "google_container_node_pool" "core-n2-standard-2" {
  project = google_container_cluster.production.project
  cluster = google_container_cluster.production.name
  name = "core-n2-standard-2"
  location = var.gcp_zone
  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }
  management {
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    machine_type = "n2-standard-2"
    preemptible = false
    disk_size_gb = 100
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
    labels = {
      "role" = "core"
    }
  }
  upgrade_settings {
    max_surge = 3
    max_unavailable = 0
  }
}

resource "google_container_node_pool" "work-n2-custom-4-4096-pe" {
  project = google_container_cluster.production.project
  cluster = google_container_cluster.production.name
  name = "work-n2-custom-4-4096-pe"
  location = var.gcp_zone
  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }
  management {
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    machine_type = "n2-custom-4-4096-pe"
    preemptible = true
    disk_size_gb = 100
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
    labels = {
      "role" = "work"
    }
    taint = [ {
      effect = "NO_EXECUTE"
      key = "role"
      value = "work"
    } ]
  }
  upgrade_settings {
    max_surge = 3
    max_unavailable = 0
  }
}
