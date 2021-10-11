provider "github" {
  alias = "gitzup"
  owner = "gitzup"
}

data "github_organization" "gitzup" {
  provider = github.gitzup
  name     = "gitzup"
}

module "github-gitzup-commons-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "commons"
  description        = "Shared resources between Gitzup modules."
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-agent-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "agent"
  description        = "Gitzup agent, in charge of running Gitzup builds."
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-gcp-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "gcp"
  description        = "Google Cloud Platform resources."
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-server-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "server"
  description        = "Gitzup server."
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-dashboard-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "dashboard"
  description        = "Gitzup user dashboard."
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-clustero-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "clustero"
  description        = "Cluster management software"
  protected_branches = ["master"]
  topics             = []
}

module "github-gitzup-config-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "config"
  description        = "TypeScript configuration utility."
  protected_branches = ["master"]
  topics             = [
    "nodejs", "config", "environment", "node", "typescript", "configuration", "ts", "environment-variables", "env"
  ]
}

module "github-gitzup-develobot-repository" {
  providers          = {
    github = github.gitzup
  }
  source             = "./modules/github-repository"
  name               = "develobot"
  description        = "Development bot that's aimed to please!"
  protected_branches = ["master"]
  topics             = []
}
