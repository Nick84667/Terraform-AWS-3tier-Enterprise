#!/usr/bin/env bash

log_info() {
  echo "[INFO ] $*"
}

log_warn() {
  echo "[WARN ] $*" >&2
}

log_error() {
  echo "[ERROR] $*" >&2
}

log_step() {
  echo
  echo "=================================================="
  echo "[STEP ] $*"
  echo "=================================================="
}
