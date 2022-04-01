resource "google_service_account" "gke-node" {
  project      = google_project.project.project_id
  account_id   = "gke-node"
  display_name = "GKE nodes service account"
}

resource "google_project_iam_member" "gke-node-logging-logWriter" {
  project = google_project.project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke-node.email}"
}

resource "google_project_iam_member" "gke-node-monitoring-metricWriter" {
  project = google_project.project.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke-node.email}"
}

resource "google_service_account" "config-connector" {
  project      = google_project.project.project_id
  account_id   = "config-connector"
  display_name = "GKE Config Connector"
}

resource "google_service_account_iam_member" "config_connector_workload_identity" {
  service_account_id = google_service_account.config-connector.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${google_project.project.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  // TODO: infer the "cnrm-system/cnrm-controller-manager" value
}
