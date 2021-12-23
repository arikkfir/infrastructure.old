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

resource "google_service_account" "devbot-github-actions" {
  project = google_project.project.project_id
  account_id = "devbot-github-actions"
  display_name = "Devbot GitHub Actions"
}
