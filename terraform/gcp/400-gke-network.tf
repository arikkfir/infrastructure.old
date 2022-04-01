resource "google_compute_network" "gke" {
  project = google_project.project.project_id

  depends_on = [
    google_project_service.apis
  ]
  name                            = "gke"
  description                     = "GKE VPC"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  project       = google_project.project.project_id
  name          = "gke-subnet-${var.gcp_region}"
  network       = google_compute_network.gke.id
  region        = var.gcp_region
  ip_cidr_range = "10.100.0.0/16"

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.110.0.0/17" # 10.110.0.0 - 10.110.127.255
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.110.128.0/17" # 10.110.128.0 - 10.110.255.255
  }
}
