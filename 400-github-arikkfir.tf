locals {
  repositories = {
    arikkfir = {
      infrastructure = {
        description   = "Infrastructure-as-Code for my infrastructure."
        homepage_url  = "https://github.com/arikkfir"
        visibility    = "public"
        is_template   = false
        has_downloads = false
        archived      = false
        topics = [
          "gcp", "google-cloud", "gke", "iac", "infrastructure", "k8s", "kubernetes", "terraform"
        ]
      }
    }
  }
}

resource "github_repository" "arikkfir" {
  for_each                                = local.repositories.arikkfir
  name                                    = each.key
  description                             = each.value.description
  homepage_url                            = each.value.homepage_url
  visibility                              = each.value.visibility
  has_issues                              = true
  has_projects                            = false
  has_wiki                                = false
  is_template                             = each.value.is_template
  allow_merge_commit                      = true
  allow_squash_merge                      = true
  allow_rebase_merge                      = true
  allow_auto_merge                        = true
  squash_merge_commit_title               = "PR_TITLE"
  squash_merge_commit_message             = "PR_BODY"
  merge_commit_title                      = "MERGE_MESSAGE"
  merge_commit_message                    = "PR_TITLE"
  delete_branch_on_merge                  = true
  has_downloads                           = each.value.has_downloads
  archived                                = each.value.archived
  archive_on_destroy                      = true
  topics                                  = each.value.topics
  vulnerability_alerts                    = true
  ignore_vulnerability_alerts_during_read = false
  allow_update_branch                     = true
}

data "github_branch" "arikkfir-main" {
  for_each   = local.repositories.arikkfir
  repository = each.key
  branch     = "main"
}

resource "github_branch_default" "arikkfir" {
  for_each   = local.repositories.arikkfir
  repository = github_repository.arikkfir[each.key].name
  branch     = data.github_branch.arikkfir-main[each.key].branch
}
