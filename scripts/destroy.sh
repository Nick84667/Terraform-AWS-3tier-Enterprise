#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-lab}"
TF_DIR="${TF_DIR:-infra}"

terraform -chdir="${TF_DIR}" init \
  -reconfigure \
  -backend-config="envs/${ENVIRONMENT}/backend.hcl"

terraform -chdir="${TF_DIR}" workspace select "${ENVIRONMENT}"

echo "ATTENZIONE: stai per distruggere ${ENVIRONMENT}"
read -r -p "Scrivi ${ENVIRONMENT} per confermare: " CONFIRM

if [[ "${CONFIRM}" != "${ENVIRONMENT}" ]]; then
  echo "Destroy annullato"
  exit 1
fi

terraform -chdir="${TF_DIR}" destroy \
  -var-file="envs/${ENVIRONMENT}/terraform.tfvars" \
  -auto-approve
