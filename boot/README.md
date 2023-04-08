# infrastructure bootstrapper

This Terraform module bootstraps the integration between GitHub Actions and
GCP, by creating & maintaining the following resources:
- Project
- Bucket for Terraform state
- Workload Identity Federation (via OIDC) integration:
  - Identity pool
  - Identity pool provider
- Per repository service accounts & IAM permissions

There is no (and there will be no) automated GitHub Actions workflows for
this Terraform module. It is intended to be run manually just to bootstrap
the integration, and later on if changes are necessary. The bulk of the
infrastructure is maintained in the outer module, not here.

## Running

```bash
$ terraform init
$ terraform apply
```
