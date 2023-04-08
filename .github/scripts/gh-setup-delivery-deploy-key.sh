#!/usr/bin/env bash

set -exuo pipefail

gh api -H "Accept: application/vnd.github+json" \
       -H "X-GitHub-Api-Version: 2022-11-28" \
       /repos/arikkfir/delivery/keys \
       | jq '.[]|select(.title=="ArgoCD")' > argocd_deploy_key.json

if [[ "$(cat argocd_deploy_key.json)" == "" ]]; then
  gh api -H "Accept: application/vnd.github+json" \
         -H "X-GitHub-Api-Version: 2022-11-28" \
         --method POST \
         /repos/arikkfir/delivery/keys \
         -f title="ArgoCD" \
         -F key="${ARGOCD_DEPLOY_PUB_KEY}" \
         -F read_only=true
fi
