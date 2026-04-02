#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${ROOT_DIR}/scripts/lib/logging.sh"
source "${ROOT_DIR}/scripts/lib/checks.sh"

log_step "Validating local prerequisites"

require_command git
require_command terraform
require_command aws
require_command kubectl
require_command helm

log_info "Checking AWS credentials"
aws sts get-caller-identity >/dev/null

log_info "Checking repository structure"
require_dir "${ROOT_DIR}/infra"
require_dir "${ROOT_DIR}/scripts"
require_dir "${ROOT_DIR}/bootstrap"

log_info "Checking terraform global files"
require_file "${ROOT_DIR}/infra/global/backend.hcl"

log_info "Terraform version"
terraform version

log_info "kubectl client version"
kubectl version --client

log_info "helm version"
helm version

log_info "Prerequisites validation completed successfully"
