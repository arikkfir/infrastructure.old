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
