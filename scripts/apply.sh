#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-lab}"
TF_DIR="${TF_DIR:-infra}"

terraform -chdir="${TF_DIR}" init \
  -reconfigure \
  -backend-config="envs/${ENVIRONMENT}/backend.hcl"

terraform -chdir="${TF_DIR}" workspace select "${ENVIRONMENT}" \
  || terraform -chdir="${TF_DIR}" workspace new "${ENVIRONMENT}"

terraform -chdir="${TF_DIR}" validate

terraform -chdir="${TF_DIR}" plan \
  -var-file="envs/${ENVIRONMENT}/terraform.tfvars" \
  -out="tfplan-${ENVIRONMENT}"

terraform -chdir="${TF_DIR}" apply -auto-approve "tfplan-${ENVIRONMENT}"
