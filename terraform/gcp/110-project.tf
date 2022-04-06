variable "gcp_project" {
  type        = string
  description = "GCP project."
}

variable "gcp_region" {
  type        = string
  description = "Region to place compute resources."
}

variable "gcp_zone" {
  type        = string
  description = "Zone to place compute resources."
}

variable "gcp_billing_account" {
  type        = string
  description = "Billing account ID"
}

resource "google_project" "project" {
  skip_delete     = true
  project_id      = var.gcp_project
  name            = var.gcp_project
  org_id          = data.google_organization.kfirfamily.org_id
  billing_account = var.gcp_billing_account
}

resource "google_project_service" "apis" {
  depends_on = [google_project_iam_member.gha-arikkfir-infrastructure-serviceusage-serviceUsageAdmin]

  for_each = toset([
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
  ])
  project                    = google_project.project.project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

data "google_compute_default_service_account" "default" {
}

resource "google_service_account_iam_member" "compute-default-account-cloudservices-iam-serviceAccountUser" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_storage_bucket" "arikkfir-devops" {
  name                        = "arikkfir-devops"
  location                    = "EU"
  project                     = google_project.project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}
