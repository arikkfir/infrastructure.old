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
        main_branch_protection = {
          required_status_checks = {
            strict   = true
            contexts = ["Apply", "Plan", "Verify Format"]
          }
        }
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
  has_projects                            = true
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
  repository = each.key
  branch     = data.github_branch.arikkfir-main[each.key].branch
}

resource "github_branch_protection" "arikkfir" {
  for_each                        = local.repositories.arikkfir
  repository_id                   = github_repository.arikkfir[each.key].node_id
  pattern                         = "main"
  enforce_admins                  = false
  require_signed_commits          = false
  required_linear_history         = true
  require_conversation_resolution = true
  allows_deletions                = false
  allows_force_pushes             = false

  required_status_checks {
    strict   = each.value.main_branch_protection.required_status_checks.strict
    contexts = each.value.main_branch_protection.required_status_checks.contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    dismissal_restrictions          = []
    pull_request_bypassers          = []
    require_code_owner_reviews      = false
    required_approving_review_count = 0
  }
}

resource "github_issue_label" "arikkfir" {
  for_each   = local.repositories.arikkfir
  repository = each.key
  name       = "Urgent"
  color      = "FF0000"
}
