#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

_check_dependency() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not found" >&2
    exit 1
  fi
}

_check_dependency mise
_check_dependency fzf

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

# mise remembers every config file it has seen. Configs that were deleted
# since still count as "in use" until forgotten, so drop them first. This only
# removes mise's links to missing files, so it runs without asking.
_prune_configs() {
  echo
  echo "== Forgetting tracked configs that no longer exist =="
  mise prune --configs --yes
}

# Installed versions that no tracked config requests, as "tool@version".
_prunable_versions() {
  mise ls --prunable --no-header 2>/dev/null | awk 'NF >= 2 { print $1 "@" $2 }' | sort -u
}

_uninstall_versions() {
  echo
  echo "== Tool versions not used by any mise config =="
  local -a prunable
  mapfile -t prunable < <(_prunable_versions)
  if [[ ${#prunable[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${prunable[@]}"
  echo
  echo "WARNING: projects whose config mise has not seen yet may still use these."

  local -a picked
  mapfile -t picked < <(_pick "Uninstall versions" "${prunable[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  mise uninstall "${picked[@]}"
}

# Plugins (asdf/vfox) that no longer back any installed tool.
_uninstall_plugins() {
  echo
  echo "== Plugins with no installed tool =="
  local -a extra_plugins
  mapfile -t extra_plugins < <(comm -23 \
    <(mise plugins ls 2>/dev/null | awk '{ print $1 }' | sort -u) \
    <(mise ls --installed --no-header 2>/dev/null | awk '{ print $1 }' | sed 's|^[a-z]*:||' | sort -u))
  if [[ ${#extra_plugins[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra_plugins[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall plugins" "${extra_plugins[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  mise plugins uninstall --purge "${picked[@]}"
}

_cleanup_cache() {
  echo
  echo "== Stale cache =="
  local out
  out="$(mise cache prune --dry-run 2>&1)"
  if [[ -z "$out" || "$out" == *"pruned 0 files"* ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  echo
  echo "WARNING: this deletes cached downloads and metadata."
  if _confirm "Run mise cache prune?"; then
    mise cache prune
  else
    echo "Skipped."
  fi
}

_prune_configs
_uninstall_versions
_uninstall_plugins
_cleanup_cache

echo
echo "Done."
