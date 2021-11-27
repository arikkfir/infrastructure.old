# infrastructure

Infrastructure-as-Code for the KFIRS umbrella.

## Contents

Changes in this repository will apply two tiers of infrastructure:

* Infrastructure - e.g. such as GCP project, GKE, VPC, etc
* Kubernetes - e.g. cert-manager, Traefik, Prometheus, etc

### Infrastructure

All infrastructure IaC is done via Terraform, placed in the `/terraform` directory.

There is, however, one aspect of the GKE cluster which currently (as of Terraform Google provider 4.1.0) cannot be managed by Terraform, and that's the Cluster Autoscaler profile. To use the correct profile (which prefers cost of growth buffer), this command needs to be run:

```bash
$ gcloud container clusters update production --autoscaling-profile optimize-utilization
```

### Kubernetes

Kubernetes components are managed & deployed via FluxCD. 
