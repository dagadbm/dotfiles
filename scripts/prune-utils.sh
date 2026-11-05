#!/usr/bin/env bash
# Shared helpers for scripts/*-prune.sh. Source it after utils.sh, do not run it.

_section() {
  echo
  echo "== $1 =="
}

_done() {
  echo
  echo "Done."
}

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

# Print a warning shown before the user picks or confirms.
_warn() {
  echo
  echo "WARNING: $1"
}

_confirm() {
  local prompt="$1" reply
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

_PICK_SKIP="[skip] keep everything, move on"
_PICK_ALL="[all] select every entry"

# Multi-select entries with fzf and print the chosen ones, one per line.
# Prints nothing when the user picks skip or aborts with Esc.
_pick() {
  local prompt="$1" out
  shift
  out="$(printf '%s\n' "$_PICK_SKIP" "$_PICK_ALL" "$@" | fzf \
    --multi \
    --reverse \
    --height=~50% \
    --prompt="$prompt> " \
    --header='TAB toggle, ctrl-a select all, Enter confirm, Esc skip' \
    --bind='ctrl-a:select-all')" || return 0

  if grep -qxF "$_PICK_ALL" <<<"$out"; then
    printf '%s\n' "$@"
  elif ! grep -qxF "$_PICK_SKIP" <<<"$out"; then
    printf '%s\n' "$out"
  fi
}
