#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-eks-lab}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_DIR="${ROOT_DIR}/infra/envs/${ENVIRONMENT}"
BACKEND_FILE="${ENV_DIR}/backend.hcl"

source "${ROOT_DIR}/scripts/lib/logging.sh"
source "${ROOT_DIR}/scripts/lib/checks.sh"
source "${ROOT_DIR}/scripts/lib/terraform.sh"

require_dir "${ENV_DIR}"
require_file "${ENV_DIR}/terraform.tfvars"
require_file "${BACKEND_FILE}"

log_step "Tearing down Argo CD managed resources"
"${ROOT_DIR}/scripts/destroy/argocd-teardown.sh" "${ENVIRONMENT}" || true

log_step "Switching to Terraform environment: ${ENVIRONMENT}"
cd "${ENV_DIR}"

log_step "Terraform init"
terraform_init "${BACKEND_FILE}"

log_step "Terraform destroy"
terraform_destroy -var-file=terraform.tfvars

log_step "Residual resources cleanup"
"${ROOT_DIR}/scripts/destroy/cleanup-residuals.sh" "${ENVIRONMENT}" || true

log_info "EKS destroy workflow completed successfully"
