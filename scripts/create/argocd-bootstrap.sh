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

log_step "Installing Argo CD HA manifests"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml

log_step "Waiting for Argo CD components"
kubectl rollout status deployment/argocd-server -n argocd --timeout=600s
kubectl rollout status deployment/argocd-repo-server -n argocd --timeout=600s
kubectl rollout status statefulset/argocd-application-controller -n argocd --timeout=600s

log_step "Applying AppProjects"
kubectl apply -f "${ARGOCD_DIR}/projects/"

log_step "Applying RBAC"
kubectl apply -f "${ARGOCD_DIR}/rbac/"

log_step "Applying platform applications (if present)"
if find "${ARGOCD_DIR}/applications" -maxdepth 1 -type f -name '*.yaml' | grep -q .; then
  kubectl apply -f "${ARGOCD_DIR}/applications/"
else
  log_warn "No child applications found under ${ARGOCD_DIR}/applications"
fi

log_step "Applying root application"
kubectl apply -f "${ARGOCD_DIR}/root-application.yaml"

log_info "Argo CD bootstrap completed for environment: ${ENVIRONMENT}"
