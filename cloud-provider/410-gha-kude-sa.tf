resource "google_service_account" "gha-arikkfir-kude" {
  project      = data.google_project.project.project_id
  account_id   = "gha-arikkfir-kude"
  display_name = "GitHub Actions: arikkfir/kude"
}

resource "google_storage_bucket_iam_member" "arikkfir-artifacts-gha-arikkfir-kude" {
  for_each = toset([
    "roles/storage.objectCreator",
    "roles/storage.objectViewer",
  ])

  bucket = google_storage_bucket.arikkfir-artifacts.name
  role   = each.key
  member = "serviceAccount:${google_service_account.gha-arikkfir-kude.email}"
}
