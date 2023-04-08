#!/usr/bin/env bash

set -exuo pipefail

kubectl apply -k ./argocd/server
kubectl config set-context --current --namespace=argocd

set +e
while true; do
  if kubectl wait --for=jsonpath='{.status.availableReplicas}'=1 --timeout=0 statefulset -l app.kubernetes.io/part-of=argocd; then
    break
  else
    sleep 5
    continue
  fi
done
while true; do
  if kubectl wait --for=jsonpath='{.status.readyReplicas}'=1 --timeout=0 statefulset -l app.kubernetes.io/part-of=argocd; then
    break
  else
    sleep 5
    continue
  fi
done
while true; do
  if kubectl wait --for=condition=Available=True --timeout=300s deployment -l app.kubernetes.io/part-of=argocd; then
    break
  else
    sleep 5
    continue
  fi
done
while true; do
  if kubectl wait --for=condition=Available=True --timeout=300s deployment -l app.kubernetes.io/part-of=argocd-applicationset; then
    break
  else
    sleep 5
    continue
  fi
done
set -e

if [[ $(kubectl get secret | grep -c "argocd-initial-admin-secret") == "1" ]]; then
  argocd --port-forward admin initial-password -n argocd > argocd-password.txt
  argocd --port-forward login --username admin --password - --insecure < argocd-password.txt
  argocd account update-password --current-password - --new-password "${ARGOCD_PASSWORD}" < argocd-password.txt
  kubectl delete secret argocd-initial-admin-secret
fi

kubectl apply -f ./argocd/application.yaml
