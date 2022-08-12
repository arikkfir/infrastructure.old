#!/usr/bin/env bash

set -exu

terraform import 'google_project_service.apis["artifactregistry.googleapis.com"]' arikkfir/artifactregistry.googleapis.com
terraform import 'google_project_service.apis["bigquery.googleapis.com"]' arikkfir/bigquery.googleapis.com
terraform import 'google_project_service.apis["bigquerystorage.googleapis.com"]' arikkfir/bigquerystorage.googleapis.com
terraform import 'google_project_service.apis["cloudbilling.googleapis.com"]' arikkfir/cloudbilling.googleapis.com
terraform import 'google_project_service.apis["cloudresourcemanager.googleapis.com"]' arikkfir/cloudresourcemanager.googleapis.com
terraform import 'google_project_service.apis["compute.googleapis.com"]' arikkfir/compute.googleapis.com
terraform import 'google_project_service.apis["container.googleapis.com"]' arikkfir/container.googleapis.com
terraform import 'google_project_service.apis["containerfilesystem.googleapis.com"]' arikkfir/containerfilesystem.googleapis.com
terraform import 'google_project_service.apis["containerregistry.googleapis.com"]' arikkfir/containerregistry.googleapis.com
terraform import 'google_project_service.apis["dns.googleapis.com"]' arikkfir/dns.googleapis.com
terraform import 'google_project_service.apis["iam.googleapis.com"]' arikkfir/iam.googleapis.com
terraform import 'google_project_service.apis["iamcredentials.googleapis.com"]' arikkfir/iamcredentials.googleapis.com
terraform import 'google_project_service.apis["logging.googleapis.com"]' arikkfir/logging.googleapis.com
terraform import 'google_project_service.apis["monitoring.googleapis.com"]' arikkfir/monitoring.googleapis.com
terraform import 'google_project_service.apis["oslogin.googleapis.com"]' arikkfir/oslogin.googleapis.com
terraform import 'google_project_service.apis["pubsub.googleapis.com"]' arikkfir/pubsub.googleapis.com
terraform import 'google_project_service.apis["secretmanager.googleapis.com"]' arikkfir/secretmanager.googleapis.com
terraform import 'google_project_service.apis["servicemanagement.googleapis.com"]' arikkfir/servicemanagement.googleapis.com
terraform import 'google_project_service.apis["serviceusage.googleapis.com"]' arikkfir/serviceusage.googleapis.com
terraform import 'google_project_service.apis["storage-api.googleapis.com"]' arikkfir/storage-api.googleapis.com
terraform import 'google_project_service.apis["storage-component.googleapis.com"]' arikkfir/storage-component.googleapis.com
