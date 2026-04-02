#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ARGOCD_DIR="${ROOT_DIR}/bootstrap/argocd"

source "${ROOT_DIR}/scripts/lib/logging.sh"

log_step "Deleting Argo CD root application if present"
kubectl delete -f "${ARGOCD_DIR}/root-application.yaml" --ignore-not-found=true || true

log_step "Deleting child applications manifests if present"
if [[ -d "${ARGOCD_DIR}/applications" ]]; then
  kubectl delete -f "${ARGOCD_DIR}/applications/" --ignore-not-found=true || true
fi

log_step "Waiting briefly for cascading resource cleanup"
sleep 20

log_info "Argo CD teardown step completed"
