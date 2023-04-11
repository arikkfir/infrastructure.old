# Enable the gha-infrastructure SA access to the default compute service account
# This is required to create GKE clusters, and avoid the following error:
#   -> Error: googleapi: Error 400: The user does not have access to service account "...". Ask a project owner to grant you the iam.serviceAccountUser role on the service account., badRequest
resource "google_service_account_iam_member" "default-compute-gha-arikkfir-infrastructure-iam-serviceAccountUser" {
  service_account_id = data.google_compute_default_service_account.arikkfir-primary.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}
