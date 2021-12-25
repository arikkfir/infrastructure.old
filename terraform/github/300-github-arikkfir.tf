provider "github" {
  alias = "arikkfir"
  owner = "arikkfir"
}

data "github_user" "arikkfir" {
  provider = github.arikkfir
  username = "arikkfir"
}

module "github-arikkfir-Apache-Felix-IntelliJ-Plugin-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "Apache-Felix-IntelliJ-Plugin"
  description        = "An IntelliJ plugin to integrate Apache Felix"
  homepage_url       = "http://plugins.intellij.net/plugin/?idea&id=5910"
  protected_branches = ["master"]
  archived           = false
  topics             = []
}

module "github-arikkfir-cloudflare-operator-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "cloudflare-operator"
  description        = "Kubernetes operator for Cloudflare resources."
  protected_branches = ["main"]
  topics             = ["go", "dns", "kubernetes", "devops", "cloudflare", "operator", "k8s", "cloudflare-operator"]
}

module "github-arikkfir-config-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = ".github"
  description        = "GitHub configuration repository."
  protected_branches = ["main"]
  topics             = ["github", "infrastructure", "iac"]
}

module "github-arikkfir-deployster-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "deployster"
  description        = "An opinionated declarative deployment tool, extensible to virtually any deployment topology."
  protected_branches = ["master"]
  archived           = true
  topics             = []
}

module "github-arikkfir-develobot-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "develobot"
  description        = "An opinionated DevOps bot intended to simplify development & collaboration in modern-day development teams."
  homepage_url       = "https://github.com/apps/develobot"
  protected_branches = ["master"]
  archived           = true
  topics             = []
}

module "github-arikkfir-develobot-console-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "develobot-console"
  description        = "Web console for Develobot."
  protected_branches = ["master"]
  archived           = true
  topics             = []
}

module "github-arikkfir-infrastructure-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "infrastructure"
  description        = "Infrastructure-as-Code for my infrastructure."
  protected_branches = ["main"]
  visibility         = "public"
  topics             = ["fluxcd", "infrastructure", "iac", "kubernetes", "kustomize", "terraform"]
}

module "github-arikkfir-mosaic-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "mosaic"
  description        = "An end-to-end web framework based on modularity and consistency."
  protected_branches = ["master"]
  archived           = true
  topics             = []
}

module "github-arikkfir-msvc-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "msvc"
  description        = "Micro services framework for Golang"
  protected_branches = ["master"]
  topics             = []
}

module "github-arikkfir-syncer-repository" {
  providers              = {
    github = github.arikkfir
  }
  source                 = "./modules/github-repository"
  name                   = "syncer"
  description            = "Synchronizes properties between Kubernetes resources"
  protected_branches     = ["main"]
  requires_status_checks = ["build"]
  topics                 = ["go", "kubernetes", "devops", "operator", "k8s"]
}

module "github-arikkfir-unbotify-engineering-hometask-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "unbotify-engineering-hometask"
  description        = ""
  protected_branches = ["master"]
  topics             = []
}

module "github-arikkfir-devbot-repository" {
  providers          = {
    github = github.arikkfir
  }
  source             = "./modules/github-repository"
  name               = "devbot"
  description        = "An opinionated DevOps bot intended to simplify development & collaboration in modern-day development teams."
  protected_branches = ["main"]
  topics             = ["go", "devops"]
}
