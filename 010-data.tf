data "google_organization" "kfirfamily" {
  domain = "kfirfamily.com"
}

data "google_project" "project" {
  project_id = var.gcp_project
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
