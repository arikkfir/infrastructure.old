provider "github" {
  alias = "akfir"
  owner = "akfir"
}

data "github_organization" "akfir" {
  provider = github.akfir
  name     = "akfir"
}
