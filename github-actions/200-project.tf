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

data google_project "project" {
  project_id = var.gcp_project
}
