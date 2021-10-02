resource "google_service_account" "github-actions-runner" {
  project = google_project.project.project_id
  account_id = "github-actions-runner"
  display_name = "GitHub Actions Runner"
  description = "GitHub Actions Runner service account."
}

resource "google_project_iam_member" "github-actions-runner-project-owner" {
  project = google_project.project.project_id
  role = "roles/owner"
  member = "serviceAccount:${google_service_account.github-actions-runner.email}"
}

resource "google_storage_bucket_iam_member" "github-actions-runner-devops-bucket-objectCreator" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.github-actions-runner.email}"
}

resource "google_storage_bucket_iam_member" "github-actions-runner-devops-bucket-objectViewer" {
  bucket = google_storage_bucket.arikkfir-devops.name
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.github-actions-runner.email}"
}

resource "google_storage_bucket_object" "github-actions-runner-startup-script" {
  bucket = google_storage_bucket.arikkfir-devops.name
  name = "github/actions/runner/github-actions-runner-startup.sh"
  source = "320-github-actions-runner-startup.sh"
  cache_control = "Cache-Control: no-cache, no-store"
  content_type = "application/x-sh"
}

resource "google_compute_network" "github-actions" {
  project = google_project.project.project_id
  depends_on = [
    google_project_service.apis
  ]
  name = "github-actions"
  description = "GitHub Actions Runners VPC"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "github-actions-allow-ssh" {
  name = "github-actions-allow-ssh"
  network = google_compute_network.github-actions.name
  allow {
    protocol = "tcp"
    ports = [
      "22"
    ]
  }
  description = "Allow SSH access to GitHub Actions Runner instances."
  target_tags = [
    "github-runner"
  ]
  project = google_project.project.name
}

resource "google_compute_instance_template" "github-actions-runner" {
  lifecycle {
    create_before_destroy = true
  }
  disk {
    auto_delete = true
    boot = true
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20210429"
    mode = "READ_WRITE"
    disk_type = "pd-balanced"
    disk_size_gb = 50
    type = "PERSISTENT"
  }
  machine_type = "e2-standard-4"
  name_prefix = "github-actions-runner-"
  can_ip_forward = false
  description = "GitHub Actions runner"
  labels = {
    app = "github-actions"
    component = "runner"
  }
  metadata = {
    startup-script-url = "gs://arikkfir-devops/github/actions/runner/github-actions-runner-startup.sh"
  }
  network_interface {
    network = google_compute_network.github-actions.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }
  project = google_project.project.project_id
  scheduling {
    automatic_restart = false
    on_host_maintenance = "TERMINATE"
    preemptible = true
  }
  service_account {
    email = google_service_account.github-actions-runner.email
    scopes = [
      "cloud-platform"
    ]
  }
  tags = [
    "github-runner"
  ]
}

resource "google_compute_instance_group_manager" "github-actions-runners" {
  base_instance_name = "github-actions-runner"
  version {
    name = "v1"
    instance_template = google_compute_instance_template.github-actions-runner.id
  }
  name = "github-actions-runners"
  zone = var.gcp_zone
  description = "GitHub Actions runners."
  project = google_project.project.name
  target_size = 1

  # TODO: consider health check for the GitHub runners
  //  auto_healing_policies {
  //    health_check = google_compute_health_check.autohealing.id
  //    initial_delay_sec = 300
  //  }

  update_policy {
    minimal_action = "REPLACE"
    type = "PROACTIVE"
    max_unavailable_fixed = 1
    max_surge_fixed = 1
    replacement_method = "SUBSTITUTE"
  }
}
