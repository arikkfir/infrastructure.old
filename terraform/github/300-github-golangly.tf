provider "github" {
  alias = "golangly"
  owner = "golangly"
}

data "github_organization" "golangly" {
  provider = github.golangly
  name     = "golangly"
}

module "github-golangly-errors-repository" {
  providers          = {
    github = github.golangly
  }
  source             = "./modules/github-repository"
  name               = "errors"
  description        = "Better errors"
  protected_branches = ["master"]
  topics             = ["go", "golang", "errors", "error-handling"]
}

module "github-golangly-webutil-repository" {
  providers          = {
    github = github.golangly
  }
  source             = "./modules/github-repository"
  name               = "webutil"
  description        = "Web related utilities."
  protected_branches = ["master"]
  topics             = []
}

module "github-golangly-log-repository" {
  providers          = {
    github = github.golangly
  }
  source             = "./modules/github-repository"
  name               = "log"
  description        = "Go logging done right (well, you know...)"
  protected_branches = ["master"]
  topics             = ["go", "golang", "log", "logging"]
}
