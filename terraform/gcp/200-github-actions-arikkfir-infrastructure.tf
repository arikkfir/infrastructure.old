resource "google_service_account" "gha-arikkfir-infrastructure" {
  project      = google_project.project.project_id
  account_id   = "gha-arikkfir-infrastructure"
  display_name = "GitHub Actions: arikkfir/infrastructure"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure-browser" {
  project = google_project.project.project_id
  role    = "roles/browser"
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure-compute-networkAdmin" {
  project = google_project.project.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_organization_iam_member" "kfirfamily-gha-arikkfir-infrastructure-iam-organizationRoleViewer" {
  org_id = data.google_organization.kfirfamily.org_id
  role   = "roles/iam.organizationRoleViewer"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure-iam-serviceAccountAdmin" {
  project = google_project.project.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_organization_iam_member" "kfirfamily-gha-arikkfir-infrastructure-resourcemanager-organizationViewer" {
  org_id = data.google_organization.kfirfamily.org_id
  role   = "roles/resourcemanager.organizationViewer"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure-resourcemanager-projectIamAdmin" {
  project = google_project.project.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure-serviceusage-serviceUsageAdmin" {
  project = google_project.project.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-infrastructure-storage-objectAdmin" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-infrastructure-storage-admin" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}
