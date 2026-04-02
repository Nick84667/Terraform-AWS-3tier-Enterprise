#!/usr/bin/env bash

TF_IN_AUTOMATION=1
export TF_IN_AUTOMATION

terraform_init() {
  local backend_file="$1"
  terraform init -reconfigure -backend-config="$backend_file"
}

terraform_apply() {
  terraform apply -auto-approve "$@"
}

terraform_destroy() {
  terraform destroy -auto-approve "$@"
}

terraform_output_raw() {
  local output_name="$1"
  terraform output -raw "$output_name"
}
