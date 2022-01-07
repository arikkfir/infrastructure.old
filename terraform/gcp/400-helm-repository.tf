resource "google_storage_bucket" "arikkfir-helm-repository" {
  name = "arikkfir-helm-repository"
  location = "EU"
  project = google_project.project.project_id
  storage_class = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public-access" {
  bucket = google_storage_bucket.arikkfir-helm-repository.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}
