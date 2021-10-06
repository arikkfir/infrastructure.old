provider "github" {}

data "github_user" "arikkfir" {
  username = "arikkfir"
}

module "github-config-repository" {
  source = "./modules/github-repository"
  name = ".github"
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
  topics = [
    "github",
    "infrastructure",
    "iac",
  ]
}

module "github-infrastructure-repository" {
  source = "./modules/github-repository"
  name = "infrastructure"
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
  topics = [
    "fluxcd",
    "infrastructure",
    "iac",
    "kubernetes",
    "kustomize",
    "terraform",
  ]
}

module "github-cloudflare-operator-repository" {
  source = "./modules/github-repository"
  name = "cloudflare-operator"
  description = "Kubernetes operator for Cloudflare resources."
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
  topics = [
    "go",
    "dns",
    "kubernetes",
    "devops",
    "cloudflare",
    "operator",
    "k8s",
    "cloudflare-operator",
  ]
}

module "github-syncer-repository" {
  source = "./modules/github-repository"
  name = "syncer"
  description = "Synchronizes properties between Kubernetes resources"
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
  requires_status_checks = [
    "build"
  ]
  topics = [
    "go",
    "kubernetes",
    "devops",
    "operator",
    "k8s",
  ]
}
