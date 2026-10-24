#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

source "$(dirname "$0")/prune-utils.sh"

_check_dependency mise
_check_dependency fzf

# Installed versions that no tracked config requests, as "tool@version".
_prunable_versions() {
  mise ls --prunable --no-header 2>/dev/null | awk 'NF >= 2 { print $1 "@" $2 }' | sort -u
}

# Plugins (asdf/vfox) that are installed, one per line.
_installed_plugins() {
  mise plugins ls 2>/dev/null | awk '{ print $1 }' | sort -u
}

# Tools with an installed version, backend prefix stripped, one per line.
_installed_tools() {
  mise ls --installed --no-header 2>/dev/null | awk '{ print $1 }' | sed 's|^[a-z]*:||' | sort -u
}

# mise remembers every config file it has seen. Configs that were deleted
# since still count as "in use" until forgotten, so drop them first. This only
# removes mise's links to missing files, so it runs without asking.
_prune_configs() {
  _section "Forgetting tracked configs that no longer exist"
  mise prune --configs --yes
}

_uninstall_versions() {
  _section "Tool versions not used by any mise config"
  local -a extra
  mapfile -t extra < <(_prunable_versions)
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra[@]}"
  _warn "projects whose config mise has not seen yet may still use these."

  local -a picked
  mapfile -t picked < <(_pick "Uninstall versions" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  mise uninstall "${picked[@]}"
}

# Plugins that no longer back any installed tool.
_uninstall_plugins() {
  _section "Plugins with no installed tool"
  local -a extra
  mapfile -t extra < <(comm -23 \
    <(_installed_plugins) \
    <(_installed_tools))
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall plugins" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  mise plugins uninstall --purge "${picked[@]}"
}

_cleanup_cache() {
  _section "Stale cache"
  local out
  out="$(mise cache prune --dry-run 2>&1)"
  if [[ -z "$out" || "$out" == *"pruned 0 files"* ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  _warn "this deletes cached downloads and metadata."

  if ! _confirm "Run mise cache prune?"; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  mise cache prune
}

_prune_configs
_uninstall_versions
_uninstall_plugins
_cleanup_cache

_done
