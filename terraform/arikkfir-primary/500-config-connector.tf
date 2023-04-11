resource "google_service_account" "config-connector" {
  project      = data.google_project.arikkfir-primary.project_id
  account_id   = "config-connector"
  display_name = "GKE Config Connector"
}

# This enables Workload Identity for the config-connector SA
resource "google_service_account_iam_member" "config-connector_workload_identity" {
  service_account_id = google_service_account.config-connector.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.arikkfir-primary.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
}

# Set of permissions that the config-connector SA needs
resource "google_project_iam_member" "arikkfir-primary-config-connector" {
  for_each = toset([
    "roles/owner",
  ])

  project = data.google_project.arikkfir-primary.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.config-connector.email}"
}

# Set of permissions that the config-connector SA needs
resource "google_project_iam_member" "arikkfir-config-connector" {
  for_each = toset([
    "roles/owner",
  ])

  project = data.google_project.arikkfir.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.config-connector.email}"
}
