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

# Ask for the sudo password once and keep the ticket alive until the caller
# exits. The loop also stops on its own if the caller dies without running the
# EXIT trap (kill -9). Only the outermost caller revokes the ticket (`sudo -k`)
# on exit; nested callers see SUDO_KEEPALIVE and reuse the parent's loop,
# so they never revoke the shared tty ticket.
_sudo_keepalive() {
  [[ -n "${SUDO_KEEPALIVE:-}" ]] && return
  export SUDO_KEEPALIVE=1
  sudo -v
  local parent=$$
  { set +x; while kill -0 "$parent" 2>/dev/null; do sudo -n -v 2>/dev/null || exit; sleep 50; done; } &
  _sudo_keepalive_pid=$!
  trap 'kill "$_sudo_keepalive_pid" 2>/dev/null || true; sudo -k' EXIT
}
