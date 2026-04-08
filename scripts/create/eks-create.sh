#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-eks-lab}"
ENABLE_ARGOCD_BOOTSTRAP="${ENABLE_ARGOCD_BOOTSTRAP:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENV_DIR="${ROOT_DIR}/infra/envs/${ENVIRONMENT}"
BACKEND_FILE="${ENV_DIR}/backend.hcl"

source "${ROOT_DIR}/scripts/lib/logging.sh"
source "${ROOT_DIR}/scripts/lib/checks.sh"
source "${ROOT_DIR}/scripts/lib/terraform.sh"

log_step "Running prerequisite validation"
"${ROOT_DIR}/scripts/create/validate-prereqs.sh" "${ENVIRONMENT}"

require_dir "${ENV_DIR}"
require_file "${ENV_DIR}/terraform.tfvars"
require_file "${BACKEND_FILE}"

log_step "Switching to Terraform environment: ${ENVIRONMENT}"
cd "${ENV_DIR}"

log_step "Terraform init"
terraform_init "${BACKEND_FILE}"

log_step "Terraform apply"
terraform_apply -var-file=terraform.tfvars

log_step "Reading Terraform outputs"
CLUSTER_NAME="$(terraform_output_raw cluster_name)"
AWS_REGION="$(terraform_output_raw aws_region)"

log_info "Cluster name: ${CLUSTER_NAME}"
log_info "AWS region : ${AWS_REGION}"

log_step "Updating kubeconfig"
aws eks update-kubeconfig --region "${AWS_REGION}" --name "${CLUSTER_NAME}" --alias "${CLUSTER_NAME}"

if [[ "${ENABLE_ARGOCD_BOOTSTRAP}" == "true" ]]; then
  log_step "Bootstrap Argo CD enabled"
  "${ROOT_DIR}/scripts/create/argocd-bootstrap.sh" "${ENVIRONMENT}"
else
  log_warn "Skipping Argo CD bootstrap for environment ${ENVIRONMENT}"
  log_warn "To enable it, run with: ENABLE_ARGOCD_BOOTSTRAP=true bash scripts/create/eks-create.sh ${ENVIRONMENT}"
fi

log_info "EKS create workflow completed successfully"
