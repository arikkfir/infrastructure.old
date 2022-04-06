resource "google_service_account" "gke-node" {
  depends_on   = [google_project_iam_member.gha-arikkfir-infrastructure-iam-serviceAccountAdmin]
  project      = google_project.project.project_id
  account_id   = "gke-node"
  display_name = "GKE nodes service account"
}

resource "google_service_account_iam_member" "gke-node-gha-arikkfir-infrastructure-iam-serviceAccountUser" {
  service_account_id = google_service_account.gke-node.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_service_account_iam_member" "gke-node-cloudservices-iam-serviceAccountUser" {
  service_account_id = google_service_account.gke-node.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "gke-node-logging-logWriter" {
  depends_on = [google_project_iam_member.gha-arikkfir-infrastructure-resourcemanager-projectIamAdmin]
  project    = google_project.project.project_id
  role       = "roles/logging.logWriter"
  member     = "serviceAccount:${google_service_account.gke-node.email}"
}

resource "google_project_iam_member" "gke-node-monitoring-metricWriter" {
  depends_on = [google_project_iam_member.gha-arikkfir-infrastructure-resourcemanager-projectIamAdmin]
  project    = google_project.project.project_id
  role       = "roles/monitoring.metricWriter"
  member     = "serviceAccount:${google_service_account.gke-node.email}"
}

resource "google_service_account" "config-connector" {
  depends_on   = [google_project_iam_member.gha-arikkfir-infrastructure-iam-serviceAccountAdmin]
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
