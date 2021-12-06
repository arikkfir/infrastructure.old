terraform {
  required_version = ">=1.0.11"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "terraform/github"
  }
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.14.0"
    }
  }
}
