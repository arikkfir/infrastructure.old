resource "google_storage_bucket" "arikkfir-artifacts" {
  name                        = "arikkfir-artifacts"
  location                    = "europe-west3"
  project                     = data.google_project.project.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
