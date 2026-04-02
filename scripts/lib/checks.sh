#!/usr/bin/env bash

require_command() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "[ERROR] Missing required command: $cmd" >&2
    exit 1
  }
}

require_env() {
  local var_name="$1"
  [[ -n "${!var_name:-}" ]] || {
    echo "[ERROR] Missing required environment variable: $var_name" >&2
    exit 1
  }
}

require_file() {
  local file_path="$1"
  [[ -f "$file_path" ]] || {
    echo "[ERROR] Missing required file: $file_path" >&2
    exit 1
  }
}

require_dir() {
  local dir_path="$1"
  [[ -d "$dir_path" ]] || {
    echo "[ERROR] Missing required directory: $dir_path" >&2
    exit 1
  }
}
