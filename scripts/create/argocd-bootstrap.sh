#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-lab}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ARGOCD_DIR="${ROOT_DIR}/bootstrap/argocd"

source "${ROOT_DIR}/scripts/lib/logging.sh"
source "${ROOT_DIR}/scripts/lib/checks.sh"

require_dir "${ARGOCD_DIR}"
require_file "${ARGOCD_DIR}/root-application.yaml"

log_step "Creating argocd namespace if missing"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

log_step "Installing Argo CD standard manifests with Server-Side Apply"
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

log_step "Waiting for Argo CD components"
kubectl rollout status deployment/argocd-server -n argocd --timeout=600s
kubectl rollout status deployment/argocd-repo-server -n argocd --timeout=600s
kubectl rollout status deployment/argocd-application-controller -n argocd --timeout=600s || true

log_step "Applying AppProjects"
kubectl apply -f "${ARGOCD_DIR}/projects/"

log_step "Applying RBAC"
kubectl apply -f "${ARGOCD_DIR}/rbac/"

log_step "Applying root application"
kubectl apply -f "${ARGOCD_DIR}/root-application.yaml"

log_info "Argo CD bootstrap completed for environment: ${ENVIRONMENT}"
