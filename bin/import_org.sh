#!/usr/bin/env bash

[[ -z "${GOOGLE_ORG_ID}" ]] && echo "please define GOOGLE_ORG_ID with the Google Organization numeric ID" >&2 && exit 1
[[ -z "${SA_EMAIL}" ]] && echo "please define SA_EMAIL with the Email address of the target GCP service account" >&2 && exit 1

set -exu

declare -a roles=("roles/iam.organizationRoleViewer" "roles/resourcemanager.organizationViewer")

for role in "${roles[@]}"; do
  terraform import "google_organization_iam_member.gha-arikkfir-infrastructure[\"${role}\"]" "${GOOGLE_ORG_ID} ${role} serviceAccount:${SA_EMAIL}"
done
