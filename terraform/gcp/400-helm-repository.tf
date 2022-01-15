resource "google_storage_bucket" "arikkfir-helm-repository" {
  name = "arikkfir-helm-repository"
  location = "EU"
  project = google_project.project.project_id
  storage_class = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "helm-repository-public-access" {
  bucket = google_storage_bucket.arikkfir-helm-repository.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "helm-repository-infrastructure-admin" {
  bucket = google_storage_bucket.arikkfir-helm-repository.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.infrastructure-github-actions.email}"
}

resource "google_storage_bucket_iam_member" "helm-repository-devbot-admin" {
  bucket = google_storage_bucket.arikkfir-helm-repository.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.devbot-github-actions.email}"
}
