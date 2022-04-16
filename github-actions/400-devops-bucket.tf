resource "google_storage_bucket" "arikkfir-devops" {
  depends_on = [
    google_project_iam_member.gha-arikkfir-infrastructure["roles/storage.admin"]
  ]

  name                        = "arikkfir-devops"
  location                    = "EU"
  project                     = data.google_project.project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}
