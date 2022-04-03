# infrastructure

This repository manages all infrastructure for the KFIRS umbrella, including but not limited to our domains & pet 
projects.

## Structure

The repository is divided into two three main sections:

* GitHub Infrastructure: things like repositories, configuration, etc.
* Cloud Infrastructure: global infrastructure such as GCP projects, VPCs, GKE clusters, etc.
* Kubernetes Manifests: workloads running inside GKE but also localized infrastructure (e.g. infrastructure for a specific development environment).

### GitHub Infrastructure

GitHub Infrastructure such as repositories & their configuration are managed by the 

### Cloud Infrastructure

Cloud Infrastructure is managed by Terraform files, placed in the `/terraform` directory. This directory is monitored by
the GitHub Actions `apply-terraform-gcp` & `apply-terraform-github` workflows. This means that any commit in this
directory will trigger one of those workflows (depending on the subdirectory).


There is, however, one aspect of the GKE cluster which currently (as of Terraform Google provider 4.1.0) cannot be 
managed by Terraform, and that's the Cluster Autoscaler profile. To use the correct profile (which prefers cost of 
growth buffer), this command needs to be run:

```bash
$ gcloud container clusters update production --autoscaling-profile optimize-utilization
```

### Kubernetes

Kubernetes components are managed & deployed via FluxCD. 
