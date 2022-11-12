terraform {
  required_version = ">=1.3.4"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "= 5.8.0"
    }
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

provider "github" {}

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
