#!/usr/bin/env bash

set -exu

terraform import "google_compute_network.gke" "arikkfir/gke"
terraform import "google_compute_subnetwork.gke-subnet" "projects/arikkfir/regions/europe-west3/subnetworks/gke-subnet-europe-west3"
