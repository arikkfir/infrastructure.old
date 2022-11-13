locals {
  repositories = {
    arikkfir = {
      infrastructure = {
        description                             = "Infrastructure-as-Code for my infrastructure."
        homepage_url                            = "https://github.com/arikkfir"
        visibility                              = "public"
        has_issues                              = true
        has_projects                            = false
        has_wiki                                = false
        is_template                             = false
        allow_merge_commit                      = true
        allow_squash_merge                      = true
        allow_rebase_merge                      = true
        allow_auto_merge                        = true
        squash_merge_commit_title               = "PR_TITLE"
        squash_merge_commit_message             = "PR_BODY"
        merge_commit_title                      = "MERGE_MESSAGE"
        merge_commit_message                    = "PR_TITLE"
        delete_branch_on_merge                  = true
        has_downloads                           = false
        archived                                = false
        archive_on_destroy                      = true
        vulnerability_alerts                    = true
        ignore_vulnerability_alerts_during_read = false
        allow_update_branch                     = true
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
  has_issues                              = each.value.has_issues
  has_projects                            = each.value.has_projects
  has_wiki                                = each.value.has_wiki
  is_template                             = each.value.is_template
  allow_merge_commit                      = each.value.allow_merge_commit
  allow_squash_merge                      = each.value.allow_squash_merge
  allow_rebase_merge                      = each.value.allow_rebase_merge
  allow_auto_merge                        = each.value.allow_auto_merge
  squash_merge_commit_title               = each.value.squash_merge_commit_title
  squash_merge_commit_message             = each.value.squash_merge_commit_message
  merge_commit_title                      = each.value.merge_commit_title
  merge_commit_message                    = each.value.merge_commit_message
  delete_branch_on_merge                  = each.value.delete_branch_on_merge
  has_downloads                           = each.value.has_downloads
  archived                                = each.value.archived
  archive_on_destroy                      = each.value.archive_on_destroy
  topics                                  = each.value.topics
  vulnerability_alerts                    = each.value.vulnerability_alerts
  ignore_vulnerability_alerts_during_read = each.value.ignore_vulnerability_alerts_during_read
  allow_update_branch                     = each.value.allow_update_branch
}
