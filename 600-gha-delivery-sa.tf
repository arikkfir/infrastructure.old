resource "google_service_account" "gha-arikkfir-delivery" {
  project      = data.google_project.project.project_id
  account_id   = "gha-arikkfir-delivery"
  display_name = "GitHub Actions: arikkfir/delivery"
}

resource "google_service_account_iam_member" "gha-arikkfir-infrastructure-workload-identity-user" {
  service_account_id = google_service_account.gha-arikkfir-delivery.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${data.google_iam_workload_identity_pool.github-actions.name}/attribute.repository/arikkfir/delivery"
}

resource "google_project_iam_member" "gha-arikkfir-delivery" {
  for_each = toset([
    "roles/container.admin",
  ])

  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-delivery.email}"
}

resource "github_repository_deploy_key" "argocd_delivery_deploy_key" {
  title      = "ArgoCD"
  repository = "delivery"
  key        = var.argocd_delivery_deploy_key
  read_only  = true
}
