terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

resource "github_repository" "repo" {
  name = var.name
  description = var.description
  visibility = var.visibility
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
    prevent_destroy = true
  }
}

resource "github_branch" "default" {
  repository = github_repository.repo.name
  branch = var.default_branch
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch = github_branch.default.branch
}

resource "github_branch_protection" "default" {
  repository_id = github_repository.repo.name
  pattern = var.default_branch
  enforce_admins = false
  required_status_checks {
    strict = true
  }
  allows_deletions = false
  allows_force_pushes = false
}
