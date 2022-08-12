# infrastructure

This repository manages infrastructure all my infrastructure, including but not limited to our domains & pet projects.

## Structure

The repository is divided into two three main sections:

- [ ] GitHub Infrastructure: things like repositories, configuration, etc.
- [ ] Base Infrastructure: base GCP provisioning, requiring higher privileges (only applied manually).
- [ ] Cloud Infrastructure: rest of the GCP infrastructure, such as projects, VPCs, GKE clusters, etc. Applied by CI/CD.

### GitHub Infrastructure

GitHub Infrastructure such as repositories & their configuration are managed by the 

### Cloud Infrastructure

#### Notes

There is, however, one aspect of the GKE cluster which currently (as of Terraform Google provider 4.1.0) cannot be 
managed by Terraform, and that's the Cluster Autoscaler profile. To use the correct profile (which prefers cost of 
growth buffer), this command needs to be run:

```bash
$ gcloud container clusters update production --autoscaling-profile optimize-utilization
```

