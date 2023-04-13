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
