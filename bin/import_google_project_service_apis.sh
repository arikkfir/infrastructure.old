#!/usr/bin/env bash

set -exu

declare -a apis=("artifactregistry" "bigquery" "bigquerystorage" "cloudbilling" "cloudresourcemanager" "compute"
                  "container" "containerregistry" "containerfilesystem" "dns" "iam" "iamcredentials" "logging"
                  "monitoring" "oslogin" "pubsub" "secretmanager" "servicemanagement" "serviceusage" "storage-api"
                  "storage-component")

for api in "${apis[@]}"; do
  terraform import "google_project_service.apis[\"${api}.googleapis.com\"]" "arikkfir/${api}.googleapis.com"
done
