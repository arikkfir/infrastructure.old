terraform {
  required_version = ">=1.0.11"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "terraform/gcp"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "= 4.5.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "= 4.5.0"
    }
  }
}
