resource "google_artifact_registry_repository" "public" {
  provider = google-beta
  repository_id = "public"
  format = "DOCKER"
  location = "europe"
}

resource "google_artifact_registry_repository_iam_member" "public-allUsers-reader" {
  provider = google-beta
  project = google_artifact_registry_repository.public.project
  location = google_artifact_registry_repository.public.location
  repository = google_artifact_registry_repository.public.name
  role = "roles/artifactregistry.reader"
  member = "allUsers"
}

resource "google_artifact_registry_repository_iam_member" "public-devbot-github-actions-writer" {
  provider = google-beta
  project = google_artifact_registry_repository.public.project
  location = google_artifact_registry_repository.public.location
  repository = google_artifact_registry_repository.public.name
  role = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.devbot-github-actions.email}"
}
