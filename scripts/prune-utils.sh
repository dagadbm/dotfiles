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

# Renders an item: title first, each detail indented below it, empty details
# as blank lines; a plain entry renders as itself. No single quotes: it is
# embedded in fzf's preview command.
# shellcheck disable=SC2016 # awk fields, not shell expansions
_ITEM_AWK='NF == 1 {print pad $0; next} {print pad $2; for (i = 3; i <= NF; i++) print ($i == "" ? "" : pad "  " $i)}'

# Print items ("key<TAB>title<TAB>detail...") as indented blocks, the same
# layout _pick previews.
_print_items() {
  printf '%s\n' "$@" | awk -F'\t' -v pad='  ' "$_ITEM_AWK"
}

_PICK_SKIP="[skip] keep everything, move on"
_PICK_ALL="[all] select every entry"

# Multi-select entries with fzf and print the chosen ones, one per line.
# Prints nothing when the user picks skip or aborts with Esc.
# An entry may be an item, "key<TAB>title<TAB>detail...": only the key is
# listed and printed, the preview shows the item like _print_item.
_pick() {
  local prompt="$1" out
  shift
  out="$(printf '%s\n' "$_PICK_SKIP" "$_PICK_ALL" "$@" | fzf \
    --multi \
    --reverse \
    --height=~50% \
    --prompt="$prompt> " \
    --header='TAB toggle, ctrl-a select all, Enter confirm, Esc skip' \
    --bind='ctrl-a:select-all' \
    --delimiter=$'\t' \
    --with-nth=1 \
    --min-height=15 \
    --preview="printf '%s\n' {} | awk -F'\t' -v pad= '$_ITEM_AWK'" \
    --preview-window=wrap)" || return 0
  out="$(cut -f1 <<<"$out")"

  if grep -qxF "$_PICK_ALL" <<<"$out"; then
    printf '%s\n' "$@" | cut -f1
  elif ! grep -qxF "$_PICK_SKIP" <<<"$out"; then
    printf '%s\n' "$out"
  fi
}
