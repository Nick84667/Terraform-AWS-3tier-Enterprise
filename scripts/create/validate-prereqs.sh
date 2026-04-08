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

log_step "Validating local prerequisites for environment: ${ENVIRONMENT}"

require_command git
require_command terraform
require_command aws

if [[ "${ENABLE_ARGOCD_BOOTSTRAP}" == "true" ]]; then
  log_info "Argo CD bootstrap enabled: validating kubectl and helm"
  require_command kubectl
  require_command helm
else
  log_info "Argo CD bootstrap disabled: skipping kubectl and helm prerequisite checks"
fi

log_info "Checking AWS credentials"
aws sts get-caller-identity >/dev/null

log_info "Checking repository structure"
require_dir "${ROOT_DIR}/infra"
require_dir "${ROOT_DIR}/scripts"
require_dir "${ROOT_DIR}/bootstrap"
require_dir "${ENV_DIR}"

log_info "Checking Terraform environment files"
require_file "${ENV_DIR}/main.tf"
require_file "${ENV_DIR}/variables.tf"
require_file "${ENV_DIR}/outputs.tf"
require_file "${ENV_DIR}/terraform.tfvars"
require_file "${BACKEND_FILE}"

if [[ ! -s "${BACKEND_FILE}" ]]; then
  log_error "Backend file is empty: ${BACKEND_FILE}"
  exit 1
fi

log_info "Terraform version"
terraform version

if [[ "${ENABLE_ARGOCD_BOOTSTRAP}" == "true" ]]; then
  log_info "kubectl client version"
  kubectl version --client

  log_info "helm version"
  helm version
fi

log_info "Prerequisites validation completed successfully"
