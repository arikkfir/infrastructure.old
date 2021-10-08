provider "github" {
  alias = "kfirz"
  owner = "kfirz"
}

data "github_organization" "kfirz" {
  provider = github.kfirz
  name     = "kfirz"
}

module "github-gitzup-repository" {
  providers          = {
    github = github.kfirz
  }
  source             = "./modules/github-repository"
  name               = "gitzup"
  description        = "An opinionated DevOps platform."
  default_branch     = "master"
  protected_branches = ["master"]
  topics             = ["devops", "deployment", "deployer", "deployments", "devops-tools"]
}
