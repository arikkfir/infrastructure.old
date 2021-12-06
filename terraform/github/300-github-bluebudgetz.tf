provider "github" {
  alias = "bluebudgetz"
  owner = "bluebudgetz"
}

data "github_organization" "bluebudgetz" {
  provider = github.bluebudgetz
  name     = "bluebudgetz"
}

module "github-bluebudgetz-dashboard-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "dashboard"
  description        = "Dashboard"
  protected_branches = ["master"]
  topics             = []
}

module "github-bluebudgetz-front-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "front"
  description        = ""
  protected_branches = ["master"]
  topics             = []
}

module "github-bluebudgetz-gate-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "gate"
  description        = "Bluebudgetz API gateway"
  protected_branches = ["master"]
  topics             = ["go", "api", "golang"]
}

module "github-bluebudgetz-infrastructure-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "infrastructure"
  description        = "Bluebudgetz infrastructure"
  protected_branches = ["master"]
  topics             = ["infrastructure", "terraform"]
}

module "github-bluebudgetz-development-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "development"
  description        = ""
  protected_branches = ["master"]
  topics             = []
}

module "github-bluebudgetz-neo4j-repository" {
  providers          = {
    github = github.bluebudgetz
  }
  source             = "./modules/github-repository"
  name               = "neo4j"
  description        = "Custom flavor of Neo4j with APOC"
  protected_branches = ["master"]
  topics             = []
}
