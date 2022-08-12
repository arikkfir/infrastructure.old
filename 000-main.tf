terraform {
  required_version = ">=1.2.7"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 4.31.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 4.31.0"
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
