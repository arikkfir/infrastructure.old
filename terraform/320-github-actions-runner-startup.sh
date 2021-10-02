#!/usr/bin/env bash

set -exuo pipefail

# Setup tools
curl -fsSL https://get.docker.com | sh
curl -sSL -o ~/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x ~/jq
curl -sSL -o /tmp/actions-runner.tar.gz https://github.com/actions/runner/releases/download/v2.283.1/actions-runner-linux-x64-2.283.1.tar.gz

# Setup the runner user
gcloud --quiet auth configure-docker europe-docker.pkg.dev

# Obtain GitHub token
GITHUB_TOKEN="$(gcloud secrets versions access latest --secret=github-actions-runner-token)"

# List repositories & register a runner for each one
curl -sSL -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${GITHUB_TOKEN}" \
     "https://api.github.com/user/repos" \
     | ~/jq -cr '.[] | select(.owner.login=="arikkfir") | .owner.login + "/" + .name' \
     | sort \
     | while read -r full_name; do
         RUNNER_DIR="/runners/${full_name}"
         rm -rf "${RUNNER_DIR}" && mkdir -vp "${RUNNER_DIR}"
         cd "${RUNNER_DIR}"
         tar xzf /tmp/actions-runner.tar.gz -C "${RUNNER_DIR}"

         REGISTRATION_TOKEN=$(curl -sSL -X POST \
                                   -H "Accept: application/vnd.github.v3+json" \
                                   -H "Authorization: token ${GITHUB_TOKEN}" \
                                   "https://api.github.com/repos/${full_name}/actions/runners/registration-token" \
                                   | ~/jq -r '.token')
         export RUNNER_ALLOW_RUNASROOT="1"
         ./config.sh --unattended \
                     --replace \
                     --name "${HOSTNAME}" \
                     --url "https://github.com/${full_name}" \
                     --labels "self-hosted,gcp,mig" \
                     --token "${REGISTRATION_TOKEN}"

         nohup ./run.sh > "${RUNNER_DIR}/runner.log" 2>&1 &
         echo "Successfully started runner for ${full_name}"
       done
