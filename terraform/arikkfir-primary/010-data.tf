data "google_organization" "kfirfamily" {
  domain = "kfirfamily.com"
}

data "google_project" "project" {
  project_id = "arikkfir-primary"
}

data "google_storage_bucket" "arikkfir-devops" {
  name = "arikkfir-devops"
}

data "google_service_account" "gha-arikkfir-infrastructure" {
  project    = data.google_project.project.project_id
  account_id = "gha-arikkfir-infrastructure"
}

data "google_compute_default_service_account" "default" {
  project = data.google_project.project.project_id
}

data "google_iam_workload_identity_pool" "github-actions" {
  provider                  = google-beta
  workload_identity_pool_id = "github-actions"
}

data "google_iam_workload_identity_pool_provider" "default" {
  provider                           = google-beta
  workload_identity_pool_id          = data.google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "default"
}

data "google_compute_zones" "region" {
  region = var.gcp_region
}

data "google_compute_network" "default" {
  name = "default"
}
