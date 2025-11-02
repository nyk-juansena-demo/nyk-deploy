#!/usr/bin/env bash
set -euo pipefail
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Waiting for ArgoCD server rollout..."
kubectl -n argocd rollout status deploy/argocd-server --timeout=180s || true
kubectl -n argocd get svc argocd-server
echo "Default admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
