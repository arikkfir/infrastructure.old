terraform {
  required_version = ">=1.3.4"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure/boot"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 4.43.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 4.43.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "google-beta" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

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

resource "google_project" "arikkfir" {
  org_id          = "468825984716"
  billing_account = "01F6CD-4EDAB8-6D4B05"
  project_id      = "arikkfir"
  name            = "arikkfir"
}

data "google_organization" "kfirfamily" {
  domain = "kfirfamily.com"
}

resource "google_storage_bucket" "arikkfir-devops" {
  name          = "arikkfir-devops"
  location      = "eu"
  storage_class = "MULTI_REGIONAL"
}

resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "Identity pool for GitHub Actions workflows."
}

resource "google_iam_workload_identity_pool_provider" "default" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "default"
  description                        = "OIDC identity pool provider for GitHub Actions workflows."
  display_name                       = "Default"
  attribute_mapping = {
    "attribute.aud"        = "assertion.aud"
    "attribute.actor"      = "assertion.actor"
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref_type"   = "assertion.ref_type"
    "attribute.ref"        = "assertion.ref"
    "attribute.event_name" = "assertion.event_name"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "gha-arikkfir-infrastructure" {
  account_id   = "gha-arikkfir-infrastructure"
  display_name = "GitHub Actions: arikkfir/infrastructure"
  description  = ""
}

resource "google_service_account_iam_member" "gha-arikkfir-infrastructure-workload-identity-user" {
  service_account_id = google_service_account.gha-arikkfir-infrastructure.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github-actions.name}/attribute.repository/arikkfir/infrastructure"
}

resource "google_organization_iam_member" "gha-arikkfir-infrastructure" {
  for_each = toset([
    "roles/iam.organizationRoleViewer",
    "roles/resourcemanager.organizationViewer",
  ])

  org_id = data.google_organization.kfirfamily.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure" {
  for_each = toset([
    "roles/compute.networkAdmin",
    "roles/compute.viewer",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
  ])
  project = google_project.arikkfir.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-infrastructure" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}
