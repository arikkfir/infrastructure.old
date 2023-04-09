# infrastructure bootstrapper

This Terraform module bootstraps the basic infrastructure:
- GCP project(s)
- Storage bucket for Terraform state
- IAM
- Workload Identity Federation (via OIDC) integration (for GitHub integration):
  - Identity pool
  - Identity pool provider

There is no (and there will be no) automated GitHub Actions workflows for
this Terraform module. It is intended to be run manually just to bootstrap
the integration, and later on if changes are necessary. The bulk of the
infrastructure is maintained in the outer module, not here.

## Running

```bash
$ terraform init
$ terraform apply
```
