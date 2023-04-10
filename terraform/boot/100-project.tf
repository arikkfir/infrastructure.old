resource "google_project" "arikkfir" {
  org_id          = "468825984716"
  billing_account = "015F98-305E8D-24864D"
  project_id      = "arikkfir"
  name            = "arikkfir"
}

resource "google_project" "arikkfir-primary" {
  org_id          = data.google_organization.kfirfamily.org_id
  billing_account = "015F98-305E8D-24864D"
  project_id      = "arikkfir-primary"
  name            = "arikkfir-primary"
}
