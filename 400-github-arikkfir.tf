locals {
  common_labels = {
    bug         = { color = "d73a4a", description = "Something isn't working" }
    docs        = { color = "0075ca", description = "Improvements or additions to documentation" }
    duplicate   = { color = "cfd3d7", description = "This issue or pull request already exists" }
    enhancement = { color = "a2eeef", description = "New feature or request" }
    invalid     = { color = "e4e669", description = "This doesn't seem right" }
    question    = { color = "d876e3", description = "Further information is requested" }
    wontfix     = { color = "ffffff", description = "This will not be worked on" }
  }
  arikkfir-repositories = {
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
      labels = {
        bootstrap       = { color = "d73a4a", description = "Related to IaC bootstrapping code" }
        bug             = local.common_labels.bug
        configconnector = { color = "b7f5f6", description = "ConfigConnector related issues or improvements" }
        docs            = local.common_labels.docs
        duplicate       = local.common_labels.duplicate
        enhancement     = local.common_labels.enhancement
        gke             = { color = "1D76DB", description = "GKE related issues or improvements" }
        invalid         = local.common_labels.invalid
        question        = local.common_labels.question
        wontfix         = local.common_labels.wontfix
      }
      topics = [
        "gcp", "google-cloud", "gke", "iac", "infrastructure", "k8s", "kubernetes", "terraform"
      ]
    }
  }
  arikkfir-labels = flatten([
    for repoName, repo in local.arikkfir-repositories : [
      for labelName, label in repo.labels : merge({ repoName = repoName, name = labelName }, label)
    ]
  ])
}

data "github_user" "arikkfir" {
  username = "arikkfir"
}

resource "github_repository" "arikkfir" {
  for_each                                = local.arikkfir-repositories
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
  for_each   = local.arikkfir-repositories
  repository = each.key
  branch     = "main"
}

resource "github_branch_default" "arikkfir-main" {
  for_each   = local.arikkfir-repositories
  repository = each.key
  branch     = data.github_branch.arikkfir-main[each.key].branch
}

resource "github_branch_protection" "arikkfir-main" {
  for_each                        = local.arikkfir-repositories
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
  for_each    = { for l in local.arikkfir-labels : format("arikkfir/%s:%s", l.repoName, l.name) => l }
  repository  = each.value.repoName
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}

resource "github_repository_environment" "arikkfir-production" {
  for_each    = local.arikkfir-repositories
  environment = "production"
  repository  = each.key
  reviewers {
    users = [data.github_user.arikkfir.id]
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}
