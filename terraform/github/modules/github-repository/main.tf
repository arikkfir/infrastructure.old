terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

resource "github_repository" "repo" {
  provider = github
  name = var.name
  description = var.description
  visibility = var.visibility
  auto_init = true
  archived = var.archived
  homepage_url = var.homepage_url
  has_issues = var.has_issues
  has_projects = var.has_projects
  has_wiki = var.has_wiki
  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  has_downloads = var.has_downloads
  archive_on_destroy = true
  topics = var.topics
  lifecycle {
    prevent_destroy = false
  }
}

resource "github_branch_protection" "default" {
  depends_on = [github_repository.repo]
  provider = github
  for_each = var.protected_branches
  repository_id = github_repository.repo.name
  pattern = each.value
  enforce_admins = false
  required_status_checks {
    strict = true
    contexts = var.requires_status_checks
  }
  allows_deletions = false
  allows_force_pushes = false
  lifecycle {
    prevent_destroy = false
  }
}