resource "google_service_account" "config-connector" {
  project      = data.google_project.project.project_id
  account_id   = "config-connector"
  display_name = "GKE Config Connector"
}

# TODO: infer the "cnrm-system/cnrm-controller-manager" value
resource "google_service_account_iam_member" "config-connector_workload_identity" {
  service_account_id = google_service_account.config-connector.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
}

resource "google_project_iam_member" "config-connector" {
  for_each = toset([
    "roles/iam.serviceAccountAdmin",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.config-connector.email}"
}