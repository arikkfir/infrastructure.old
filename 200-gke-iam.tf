resource "google_service_account" "gke-node" {
  project      = data.google_project.project.project_id
  account_id   = "gke-node"
  display_name = "GKE nodes service account"
}

# Enable the gha-infrastructure SA access to the default compute & gke-node service accounts
# This is required to create GKE clusters, and avoid the following error:
# -> Error: googleapi: Error 400: The user does not have access to service account "...". Ask a project owner to grant you the iam.serviceAccountUser role on the service account., badRequest
resource "google_service_account_iam_member" "gke-node_gha-arikkfir-infrastructure_iam_serviceAccountUser" {
  service_account_id = google_service_account.gke-node.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}

# Set of permissions that the gke-node SA needs
resource "google_project_iam_member" "gke-node" {
  project = data.google_project.project.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke-node.email}"
}
