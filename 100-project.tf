variable "gcp_project" {
  type        = string
  description = "GCP project."
  default     = "arikkfir"
}

variable "gcp_region" {
  type        = string
  description = "Region to place compute resources."
}

variable "gcp_zone" {
  type        = string
  description = "Zone to place compute resources."
}

data "google_organization" "kfirfamily" {
  domain = "kfirfamily.com"
}

data "google_project" "project" {
  project_id = var.gcp_project
}

data "google_storage_bucket" "arikkfir-devops" {
  name = "arikkfir-devops"
}

resource "google_project_service" "apis" {
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
  project                    = data.google_project.project.project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}
