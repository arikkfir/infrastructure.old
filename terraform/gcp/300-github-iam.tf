resource "google_iam_workload_identity_pool" "github-actions" {
  provider                  = google-beta
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "Identity pool for GitHub Actions workflows."
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "default" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "default"
  display_name                       = "Default"
  description                        = "OIDC identity pool provider for GitHub Actions workflows."
  disabled                           = false
  attribute_mapping                  = {
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.event_name" = "assertion.event_name"
    "attribute.ref"        = "assertion.ref"
    "attribute.ref_type"   = "assertion.ref_type"
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "infrastructure-github-actions" {
  project = google_project.project.project_id
  account_id = "infrastructure-github-actions"
  display_name = "Infrastructure GitHub Actions"
}

resource "google_service_account_iam_member" "infrastructure-github-actions-oidc" {
  service_account_id = google_service_account.infrastructure-github-actions.name
  role = "roles/iam.workloadIdentityUser"
  member = "principalSet://iam.googleapis.com/projects/8909046976/locations/global/workloadIdentityPools/github-actions/attribute.repository/arikkfir/infrastructure"
}

resource "google_project_iam_member" "infrastructure_storageAdmin" {
  project = google_project.project.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.infrastructure-github-actions.email}"
}

resource "google_service_account" "devbot-github-actions" {
  project = google_project.project.project_id
  account_id = "devbot-github-actions"
  display_name = "Devbot GitHub Actions"
}

resource "google_service_account_iam_member" "devbot-github-actions-oidc" {
  service_account_id = google_service_account.devbot-github-actions.name
  role = "roles/iam.workloadIdentityUser"
  member = "principalSet://iam.googleapis.com/projects/8909046976/locations/global/workloadIdentityPools/github-actions/attribute.repository/arikkfir/devbot"
}
