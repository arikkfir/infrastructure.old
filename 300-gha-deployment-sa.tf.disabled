resource "google_service_account" "gha-arikkfir-deployment" {
  project      = data.google_project.project.project_id
  account_id   = "gha-arikkfir-deployment"
  display_name = "GitHub Actions: arikkfir/deployment"
}

resource "google_project_iam_member" "gha-arikkfir-deployment" {
  for_each = toset([
    "roles/container.admin",
  ])

  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-deployment.email}"
}
