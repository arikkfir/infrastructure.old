variable "github_repositories" {
  type = map(object({
    description = string
    default_branch = string
    visibility = string
    has_issues = bool
    has_projects = bool
    has_wiki = bool
    allow_merge_commit = bool
    allow_squash_merge = bool
    allow_rebase_merge = bool
    delete_branch_on_merge = bool
    has_downloads = bool
    archive_on_destroy = bool
    topics = list(string)
  }))
  description = "GitHub repositories."
  default = {
    ".github" = {
      description = "GitHub configuration repository."
      default_branch = "main"
      visibility = "public"
      has_issues = true
      has_projects = false
      has_wiki = false
      allow_merge_commit = true
      allow_squash_merge = true
      allow_rebase_merge = true
      delete_branch_on_merge = true
      has_downloads = false
      archive_on_destroy = true
      topics = [
        "github",
        "infrastructure",
        "iac",
      ]
    },
    "infrastructure" = {
      description = "Infrastructure-as-Code for my infrastructure."
      default_branch = "main"
      visibility = "public"
      has_issues = true
      has_projects = false
      has_wiki = false
      allow_merge_commit = true
      allow_squash_merge = true
      allow_rebase_merge = true
      delete_branch_on_merge = true
      has_downloads = false
      archive_on_destroy = true
      topics = [
        "fluxcd",
        "infrastructure",
        "iac",
        "kubernetes",
        "kustomize",
        "terraform",
      ]
    },
  }
}

data "github_user" "arikkfir" {
  username = "arikkfir"
}

resource "github_repository" "all" {
  for_each = var.github_repositories
  name = each.key
  description = each.value.description
  visibility = each.value.visibility
  has_issues = each.value.has_issues
  has_projects = each.value.has_projects
  has_wiki = each.value.has_wiki
  allow_merge_commit = each.value.allow_merge_commit
  allow_squash_merge = each.value.allow_squash_merge
  allow_rebase_merge = each.value.allow_rebase_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge
  has_downloads = each.value.has_downloads
  archive_on_destroy = each.value.archive_on_destroy
  topics = each.value.topics
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch" "all" {
  for_each = var.github_repositories
  repository = github_repository.all[each.key].name
  branch = each.value.default_branch
  lifecycle {
    ignore_changes = [
      etag,
      sha,
    ]
    prevent_destroy = true
  }
}

resource "github_branch_default" "all" {
  for_each = var.github_repositories
  repository = github_repository.all[each.key].name
  branch = github_branch.all[each.key].branch
}

resource "github_branch_protection" "all" {
  for_each = var.github_repositories
  repository_id = github_repository.all[each.key].node_id
  pattern = each.value.default_branch
  enforce_admins = false
  required_status_checks {
    strict = true
  }
  allows_deletions = false
  allows_force_pushes = false
}
