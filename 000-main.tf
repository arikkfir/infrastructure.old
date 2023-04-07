terraform {
  required_version = ">=1.4.2"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "= 5.19.0"
    }
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

provider "github" {}

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
}

variable "argocd_delivery_deploy_key" {
  type        = string
  description = "Readonly SSH key used as a Deploy key in the delivery repository."
}
