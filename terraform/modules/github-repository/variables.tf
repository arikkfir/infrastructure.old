variable "name" {
  type = string
  description = "Repository name."
}
variable "description" {
  type = string
  description = "Repository description."
}
variable "default_branch" {
  type = string
  description = "The default branch to set for the repository."
  default = "main"
}
variable "protected_branches" {
  type = set(string)
  description = "List of branch names to protect."
  default = []
}
variable "visibility" {
  type = string
  description = "Repository visibility - can be 'public' or 'private'."
  default = "public"
  validation {
    condition = var.visibility == "private" || var.visibility == "public"
    error_message = "Invalid visibility - must be 'public' or 'private'."
  }
}
variable "archived" {
  type = bool
  description = "Whether this repository is archived."
  default = false
}
variable "has_issues" {
  type = bool
  description = "Whether to enable issues for the repository."
  default = true
}
variable "has_projects" {
  type = bool
  description = "Whether to enable projects for the repository."
  default = false
}
variable "has_wiki" {
  type = bool
  description = "Whether to enable wiki pages for the repository."
  default = false
}
variable "has_downloads" {
  type = bool
  description = "Whether to enable downloads for the repository."
  default = false
}
variable "allow_merge_commit" {
  type = bool
  description = "Whether to allow merge commits on the repository."
  default = true
}
variable "allow_squash_merge" {
  type = bool
  description = "Whether to allow squash commits on the repository."
  default = true
}
variable "allow_rebase_merge" {
  type = bool
  description = "Whether to allow rebase commits on the repository."
  default = true
}
variable "delete_branch_on_merge" {
  type = bool
  description = "Whether to delete a branch once its merged to the base branch of a PR."
  default = true
}
variable "topics" {
  type = list(string)
  description = "List of topics for the repository."
  default = []
}
variable "requires_status_checks" {
  type = list(string)
  description = "List of status checks to require before merging to main branch."
  default = []
}
