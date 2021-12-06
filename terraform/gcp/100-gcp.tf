variable "gcp_billing_account" {
  type = string
  description = "Billing account ID"
  default = "01F6CD-4EDAB8-6D4B05"
}

variable "gcp_project" {
  type = string
  description = "GCP project."
}

variable "gcp_region" {
  type = string
  description = "Region to place compute resources."
}

variable "gcp_zone" {
  type = string
  description = "Zone to place compute resources."
}

provider "google" {
  project = var.gcp_project
  region = var.gcp_region
  zone = var.gcp_zone
}

provider "google-beta" {
  project = var.gcp_project
  region = var.gcp_region
  zone = var.gcp_zone
}

data "google_organization" "kfirfamily" {
  domain = "kfirfamily.com"
}

resource "google_project" "project" {
  skip_delete = true
  project_id = var.gcp_project
  name = var.gcp_project
  org_id = data.google_organization.kfirfamily.org_id
  billing_account = var.gcp_billing_account
}

resource "google_project_service" "apis" {
  for_each = toset([
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com",
    "redis.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "stackdriver.googleapis.com",
    "vpcaccess.googleapis.com",
  ])
  project = google_project.project.project_id
  service = each.key
  disable_dependent_services = false
  disable_on_destroy = false
}
