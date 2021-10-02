resource "google_storage_bucket" "arikkfir-devops" {
  name = "arikkfir-devops"
  location = "EU"
  project = google_project.project.project_id
  storage_class = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}
