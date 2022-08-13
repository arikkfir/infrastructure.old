resource "google_service_account" "gha-arikkfir-cluster" {
  project      = data.google_project.project.project_id
  account_id   = "gha-arikkfir-cluster"
  display_name = "GitHub Actions: arikkfir/cluster"
}

resource "google_service_account" "gha-arikkfir-deployment" {
  project      = data.google_project.project.project_id
  account_id   = "gha-arikkfir-deployment"
  display_name = "GitHub Actions: arikkfir/deployment"
}
