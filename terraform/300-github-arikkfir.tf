provider "github" {
  alias = "arikkfir"
  owner = "arikkfir"
}

data "github_user" "arikkfir" {
  provider = github.arikkfir
  username = "arikkfir"
}

module "github-config-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = ".github"
  description        = "GitHub configuration repository."
  protected_branches = ["main"]
  topics             = ["github", "infrastructure", "iac"]
}

module "github-infrastructure-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "infrastructure"
  description        = "Infrastructure-as-Code for my infrastructure."
  protected_branches = ["main"]
  topics             = ["fluxcd", "infrastructure", "iac", "kubernetes", "kustomize", "terraform"]
}

module "github-cloudflare-operator-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "cloudflare-operator"
  description        = "Kubernetes operator for Cloudflare resources."
  protected_branches = ["main"]
  topics             = ["go", "dns", "kubernetes", "devops", "cloudflare", "operator", "k8s", "cloudflare-operator"]
}

module "github-syncer-repository" {
  providers          = {
    github = github.arikkfir
  }
  source                 = "./modules/github-repository"
  name                   = "syncer"
  description            = "Synchronizes properties between Kubernetes resources"
  protected_branches     = ["main"]
  requires_status_checks = ["build"]
  topics                 = ["go", "kubernetes", "devops", "operator", "k8s"]
}

module "github-msvc-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "msvc"
  description        = "Micro services framework for Golang"
  default_branch     = "master"
  protected_branches = ["master"]
  topics             = []
}

module "github-unbotify-engineering-hometask-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "unbotify-engineering-hometask"
  description        = ""
  default_branch     = "master"
  protected_branches = ["master"]
  topics             = []
}

module "github-deployster-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "deployster"
  description        = "An opinionated declarative deployment tool, extensible to virtually any deployment topology."
  default_branch     = "master"
  protected_branches = []
  archived           = true
  topics             = []
}

module "github-develobot-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "develobot"
  description        = "An opinionated DevOps bot intended to simplify development & collaboration in modern-day development teams."
  default_branch     = "master"
  homepage_url       = "https://github.com/apps/develobot"
  protected_branches = []
  archived           = true
  topics             = []
}

module "github-develobot-console-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "develobot-console"
  description        = "Web console for Develobot."
  default_branch     = "master"
  protected_branches = []
  archived           = true
  topics             = []
}

module "github-mosaic-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "mosaic"
  description        = "An end-to-end web framework based on modularity and consistency."
  default_branch     = "master"
  protected_branches = []
  archived           = true
  topics             = []
}

module "github-Apache-Felix-IntelliJ-Plugin-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "Apache-Felix-IntelliJ-Plugin"
  description        = "An IntelliJ plugin to integrate Apache Felix"
  default_branch     = "master"
  homepage_url       = "http://plugins.intellij.net/plugin/?idea&id=5910"
  protected_branches = ["master"]
  archived           = false
  topics             = []
}
