#!/usr/bin/env bash
# Shared helpers for scripts/*.sh. Source it, do not run it.

# Run from the repo root, so paths like macos/Brewfile resolve however the
# script was started (mise task, ./scripts/x.sh, or from another directory).
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

_check_dependency() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not found" >&2
    exit 1
  fi
}

_check_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "Error: $file not found" >&2
    exit 1
  fi
}

# Print a step header.
_section() {
  echo
  echo "== $1 =="
}

_done() {
  echo
  echo "Done."
}
