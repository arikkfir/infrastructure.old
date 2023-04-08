#!/usr/bin/env bash

# TODO: consider using -e and -x flags
set -uo pipefail

for ns in $(kubectl get ns -o=jsonpath='{.items[*].metadata.name}'); do
  echo "Ensuring all Deployments in namespace ${ns} are ready"
  for d in $(kubectl get deployment -n "${ns}" -ojsonpath='{.items[*].metadata.name}'); do
    echo "Ensuring Deployment ${d} in namespace ${ns} is ready"
    while true; do
      if kubectl wait -n "${ns}" --for=condition=Available=True deployment "${d}" --timeout=0; then
        break
      else
        echo "Failed waiting for deployment ${ns}/${d} to be ready, will sleep & retry"
        sleep 5
      fi
    done
  done

  echo "Ensuring all StatefulSets in namespace ${ns} are ready"
  for d in $(kubectl get statefulset -n "${ns}" -ojsonpath='{.items[*].metadata.name}'); do
    echo "Ensuring StatefulSet ${d} in namespace ${ns} is ready"
    while true; do
      REPLICAS=$(kubectl get statefulset -n "${ns}" "${d}" -ojsonpath='{.status.replicas}')
      AVAILABLE_REPLICAS=$(kubectl get statefulset -n "${ns}" "${d}" -ojsonpath='{.status.availableReplicas}')
      READY_REPLICAS=$(kubectl get statefulset -n "${ns}" "${d}" -ojsonpath='{.status.readyReplicas}')
      # shellcheck disable=SC2055
      if [[ "${REPLICAS}" -ne "${AVAILABLE_REPLICAS}" || "${REPLICAS}" -ne "${READY_REPLICAS}" ]]; then
        echo "StatefulSet ${ns}/${d} has '${REPLICAS}' replicas but '${AVAILABLE_REPLICAS}' are available, and '${READY_REPLICAS}' are ready, will sleep & retry"
        sleep 5
      else
        break
      fi
    done
    echo "statefulsets.apps/${d} is ready (${ns})"
  done

  echo "Ensuring all DaemonSets in namespace ${ns} are ready"
  for d in $(kubectl get daemonset -n ${ns} -ojsonpath='{.items[*].metadata.name}'); do
    echo "Ensuring DaemonSet ${d} in namespace ${ns} is ready"
    while true; do
      CURRENT_SCHEDULED=$(kubectl get daemonset -n ${ns} ${d} -ojsonpath='{.status.currentNumberScheduled}')
      DESIRED_SCHEDULED=$(kubectl get daemonset -n ${ns} ${d} -ojsonpath='{.status.desiredNumberScheduled}')
      if [[ ${CURRENT_SCHEDULED} -ne ${DESIRED_SCHEDULED} ]]; then
        echo "DaemonSet ${ns}/${d} has ${CURRENT_SCHEDULED} replicas but desires ${DESIRED_SCHEDULED} replicas, will sleep & retry"
        sleep 5
      else
        break
      fi
    done
    echo "daemonsets.apps/${d} is ready (${ns})"
  done
done
