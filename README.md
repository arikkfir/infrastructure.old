# infrastructure

Infrastructure-as-Code for the KFIRS umbrella.

## Contents

Changes in this repository will apply two tiers of infrastructure:

* Infrastructure - e.g. such as GCP project, GKE, VPC, etc
* Kubernetes - e.g. cert-manager, Traefik, Prometheus, etc

### Infrastructure

All infrastructure IaC is done via Terraform, placed in the `/terraform` directory.

### Kubernetes

Kubernetes components are managed & deployed via FluxCD. 
