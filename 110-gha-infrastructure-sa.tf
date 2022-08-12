data "google_service_account" "gha-arikkfir-infrastructure" {
  project    = data.google_project.project.project_id
  account_id = "gha-arikkfir-infrastructure"
}

resource "google_organization_iam_member" "gha-arikkfir-infrastructure" {
  for_each = toset([
    "roles/iam.organizationRoleViewer",
    "roles/resourcemanager.organizationViewer",
  ])

  org_id = data.google_organization.kfirfamily.org_id
  role   = each.key
  member = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_project_iam_member" "gha-arikkfir-infrastructure" {
  for_each = toset([
    "roles/browser",
    "roles/container.admin",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
  ])

  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-infrastructure" {
  for_each = toset([
    "roles/storage.admin",
    "roles/storage.objectAdmin",
  ])

  bucket = data.google_storage_bucket.arikkfir-devops.name
  role   = each.key
  member = "serviceAccount:${data.google_service_account.gha-arikkfir-infrastructure.email}"
}
