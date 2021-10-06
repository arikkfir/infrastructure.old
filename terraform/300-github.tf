provider "github" {}

data "github_user" "arikkfir" {
  username = "arikkfir"
}

module "github-config-repository" {
  source      = "./modules/github-repository"
  name        = ".github"
  description = "GitHub configuration repository."
  topics      = ["github", "infrastructure", "iac"]
}

module "github-infrastructure-repository" {
  source      = "./modules/github-repository"
  name        = "infrastructure"
  description = "Infrastructure-as-Code for my infrastructure."
  topics      = ["fluxcd", "infrastructure", "iac", "kubernetes", "kustomize", "terraform"]
}

module "github-cloudflare-operator-repository" {
  source      = "./modules/github-repository"
  name        = "cloudflare-operator"
  description = "Kubernetes operator for Cloudflare resources."
  topics      = ["go", "dns", "kubernetes", "devops", "cloudflare", "operator", "k8s", "cloudflare-operator"]
}

module "github-syncer-repository" {
  source                 = "./modules/github-repository"
  name                   = "syncer"
  description            = "Synchronizes properties between Kubernetes resources"
  requires_status_checks = ["build"]
  topics                 = ["go", "kubernetes", "devops", "operator", "k8s"]
}
