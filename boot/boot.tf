terraform {
  required_version = ">=1.4.2"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure/boot"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 4.59.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 4.59.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
}

provider "google-beta" {
  project = var.gcp_project
}

variable "gcp_project" {
  type        = string
  description = "GCP project."
  default     = "arikkfir"
}

resource "google_project" "main" {
  org_id          = "468825984716"
  billing_account = "015F98-305E8D-24864D"
  project_id      = var.gcp_project
  name            = var.gcp_project
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
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
  ])
  project = google_project.main.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-infrastructure" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gha-arikkfir-infrastructure.email}"
}
