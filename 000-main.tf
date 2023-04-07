terraform {
  required_version = ">=1.4.2"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure"
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
  region  = var.gcp_region
}

provider "google-beta" {
  project = var.gcp_project
  region  = var.gcp_region
}

variable "gcp_project" {
  type        = string
  description = "GCP project."
  default     = "arikkfir"
}

variable "gcp_region" {
  type        = string
  description = "Region to place compute resources."
  default     = "me-west1"
}

variable "gcp_zone" {
  type        = string
  description = "Zone to place zonal resources."
  default     = "me-west1-a"
}
