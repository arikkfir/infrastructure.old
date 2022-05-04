resource "google_service_account" "gke-node" {
  project      = data.google_project.project.project_id
  account_id   = "gke-node"
  display_name = "GKE nodes service account"
}

resource "google_service_account_iam_member" "gke-node_gha-arikkfir-infrastructure_iam_serviceAccountUser" {
  service_account_id = google_service_account.gke-node.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gke-node" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])

  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke-node.email}"
}
