#!/usr/bin/env bash

set -exuo pipefail

kubectl apply -k ./argocd/server
kubectl config set-context --current --namespace=argocd
kubectl wait --for=jsonpath='{.status.availableReplicas}'=1 --timeout=30m statefulset -l app.kubernetes.io/part-of=argocd
kubectl wait --for=jsonpath='{.status.readyReplicas}'=1 --timeout=30m statefulset -l app.kubernetes.io/part-of=argocd
kubectl wait --for=condition=Available=True --timeout=30m deployment -l app.kubernetes.io/part-of=argocd
kubectl wait --for=condition=Available=True --timeout=30m deployment -l app.kubernetes.io/part-of=argocd-applicationset

if [[ $(kubectl get secret | grep -c "argocd-initial-admin-secret") == "1" ]]; then
  # TODO: another way to do this is to add the new ArgoCD password to the file (in a 2nd line after the initial one) so command reads 2 lines from file
  INITIAL_PWD=$(kubectl get secret argocd-initial-admin-secret -oyaml|yq '.data.password'|base64 -d)
  argocd --port-forward login --plaintext --username admin --password "${INITIAL_PWD}"
  argocd --port-forward account update-password --plaintext --current-password "${INITIAL_PWD}" --new-password "${ARGOCD_PASSWORD}"
  kubectl delete secret argocd-initial-admin-secret
fi

kubectl apply -f ./argocd/applications/*.yaml
