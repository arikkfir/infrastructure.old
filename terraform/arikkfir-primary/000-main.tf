terraform {
  required_version = ">=1.4.2"
  backend "gcs" {
    bucket = "arikkfir-devops"
    prefix = "arikkfir/infrastructure/arikkfir-primary"
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
  project = "arikkfir-primary"
  region  = var.gcp_region
}

provider "google-beta" {
  project = "arikkfir-primary"
  region  = var.gcp_region
}

variable "gcp_region" {
  type        = string
  description = "Region to place compute resources."
  default     = "me-west1"
}

locals {
  gcp_zone_a = "${var.gcp_region}-a"
  gcp_zone_b = "${var.gcp_region}-b"
  gcp_zone_c = "${var.gcp_region}-c"
}
