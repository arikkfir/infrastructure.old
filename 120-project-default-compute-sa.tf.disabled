data "google_compute_default_service_account" "default" {
  project = data.google_project.project.project_id
}

# Enable the gha-infrastructure SA access to the default compute SA
resource "google_service_account_iam_member" "default-compute-gha-arikkfir-infrastructure-iam-serviceAccountUser" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}
