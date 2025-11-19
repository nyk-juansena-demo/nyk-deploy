#!/usr/bin/env bash

## What’s broken (and why we have to execute this to fix it):
##
## The Prometheus Operator CRDs (Prometheus, Alertmanager, ServiceMonitor, etc.) are missing.
## The kube-prometheus-stack Helm chart created:
## the operator (monitoring-operator),
## node-exporter,
## kube-state-metrics,
## Grafana,
## the monitoring-prometheus Service and Endpoints…
## …but it could not create the Prometheus custom resource, because the CRD didn’t exist at install time.
##
## So monitoring-prometheus is just an empty service – kubectl get endpoints monitoring-prometheus shows metadata but no subsets: with addresses.

CRDS=(
  alertmanagers
  alertmanagerconfigs
  podmonitors
  probes
  prometheuses
  prometheusagents
  prometheusrules
  servicemonitors
  thanosrulers
  scrapeconfigs
)

for crd in "${CRDS[@]}"; do
  kubectl apply -f \
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_${crd}.yaml"
done

##########
CRDS=(
  alertmanagers
  alertmanagerconfigs
  prometheuses
  prometheusagents
  thanosrulers
  scrapeconfigs
)

for crd in "${CRDS[@]}"; do
  echo "Applying CRD: $crd"
  kubectl apply \
    --server-side=true \
    --force-conflicts=true \
    -f "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_${crd}.yaml"
done
