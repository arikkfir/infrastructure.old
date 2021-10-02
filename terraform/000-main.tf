terraform {
  required_version = ">=1.0.4"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "terraform/global"
  }
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.14.0"
    }
    google = {
      source = "hashicorp/google"
      version = "~> 3.81.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 3.81.0"
    }
  }
}
