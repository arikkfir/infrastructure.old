resource "google_service_account" "gha-arikkfir-delivery" {
  project      = data.google_project.arikkfir-primary.project_id
  account_id   = "gha-arikkfir-delivery"
  display_name = "Delivery pipeline"
}

# Set of permissions that the config-connector SA needs
resource "google_project_iam_member" "arikkfir-primary-delivery" {
  for_each = toset([
    "roles/container.clusterViewer",
    "roles/container.viewer",
  ])

  project = data.google_project.arikkfir-primary.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-delivery.email}"
}

# Allow delivery pipeline service account to authenticate from GitHub Actions
resource "google_service_account_iam_member" "gha-arikkfir-primary-delivery-workload-identity-user" {
  service_account_id = google_service_account.gha-arikkfir-delivery.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${data.google_iam_workload_identity_pool.github-actions.name}/attribute.repository/arikkfir/delivery"
}
