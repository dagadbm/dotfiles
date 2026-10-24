#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

source "$(dirname "$0")/prune-utils.sh"

UPDATE_SCRIPT="scripts/claude-update.sh"

_check_dependency claude
_check_dependency fzf
_check_dependency jq
_check_file "$UPDATE_SCRIPT"

# Marketplace GitHub repos declared in claude-update.sh, one per line.
_expected_marketplaces() {
  sed -n '/^marketplaces=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -n 's/^[[:space:]]*\([^[:space:]/]*\/[^[:space:]]*\)[[:space:]]*$/\1/p' | sort -u
}

# Plugins declared in claude-update.sh as id:true|false, as "id<TAB>enabled|disabled".
_expected_plugin_states() {
  sed -n '/^plugins=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -nE 's/^[[:space:]]*([^[:space:]:]+@[^[:space:]:]+):(true|false)[[:space:]]*$/\1\t\2/p' |
    sed -e 's/\ttrue$/\tenabled/' -e 's/\tfalse$/\tdisabled/' | sort -u
}

# Plugin ids (name@marketplace) declared in claude-update.sh, one per line.
_expected_plugins() {
  _expected_plugin_states | cut -f1
}

# Plugins installed locally, enabled or disabled, as "id<TAB>scope<TAB>state".
# claude.ai-synced plugins are skipped: they cannot be removed here.
# Run from $HOME: project-scoped plugins are only listed from their own project.
_installed_plugins() {
  (cd "$HOME" && claude plugin list --json 2>/dev/null) |
    jq -r '.[] | select(.scope != "synced") | [.id, .scope, (if .enabled then "enabled" else "disabled" end)] | @tsv' | sort -u
}

# Scope of one installed plugin: user, project or local.
_plugin_scope() {
  _installed_plugins | awk -F'\t' -v id="$1" '$1 == id {print $2}'
}

# Enabled state of one installed plugin: enabled or disabled.
_plugin_state() {
  _installed_plugins | awk -F'\t' -v id="$1" '$1 == id {print $3}'
}

# Directory a project-scoped plugin was installed from; uninstall must run there.
_plugin_project_path() {
  (cd "$HOME" && claude plugin list --json 2>/dev/null) |
    jq -r --arg id "$1" '.[] | select(.id == $id) | .projectPath // empty'
}

# Marketplaces as "name<TAB>GitHub repo", for GitHub-sourced ones only.
# Built-in and claude.ai-synced entries have no CLI name or repo and are skipped.
_installed_marketplaces() {
  claude plugin marketplace list 2>/dev/null |
    awk '/^  ❯ /{name=$2; next}
         /Source: GitHub \(/{
           repo=$0; sub(/.*Source: GitHub \(/, "", repo); sub(/\)$/, "", repo)
           if (name != "") print name "\t" repo
           name=""
         }' | sort -u
}

_uninstall_plugins() {
  _section "Plugins not in $UPDATE_SCRIPT"
  local -a extra
  mapfile -t extra < <(comm -23 \
    <(_installed_plugins | cut -f1) \
    <(_expected_plugins))
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi

  # Project-scoped plugins are labelled so they are not removed by accident.
  local -a labels=()
  local plugin scope state project_path
  for plugin in "${extra[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    state="$(_plugin_state "$plugin")"
    if [[ "$scope" == project ]]; then
      project_path="$(_plugin_project_path "$plugin")"
      labels+=("$plugin (project scoped: ${project_path/#$HOME/\~}, $state)")
    else
      labels+=("$plugin ($state)")
    fi
  done
  printf '  %s\n' "${labels[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall plugins" "${labels[@]}" | sed -E 's/ \(.*\)$//')
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  for plugin in "${picked[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    if [[ "$scope" == project ]]; then
      # Project-scoped plugins are only visible from the project they were installed in.
      project_path="$(_plugin_project_path "$plugin")"
      (cd "$project_path" && claude plugin uninstall --scope project "$plugin") ||
        echo "Failed to uninstall $plugin from $project_path, continuing." >&2
    else
      claude plugin uninstall --scope "$scope" "$plugin" || echo "Failed to uninstall $plugin, continuing." >&2
    fi
  done
}

_remove_marketplaces() {
  _section "Marketplaces not in $UPDATE_SCRIPT"
  local -a extra
  mapfile -t extra < <(
    _installed_marketplaces |
      while IFS=$'\t' read -r name repo; do
        grep -qxF "$repo" <(_expected_marketplaces) || printf '%s\n' "$name"
      done
  )
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra[@]}"
  _warn "removing a marketplace also removes plugins installed from it."

  local -a picked
  mapfile -t picked < <(_pick "Remove marketplaces" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  local marketplace
  for marketplace in "${picked[@]}"; do
    claude plugin marketplace remove "$marketplace" || echo "Failed to remove $marketplace, continuing." >&2
  done
}

# Declared plugins whose enabled state differs from claude-update.sh.
_sync_plugin_states() {
  _section "Plugins with enabled state not matching $UPDATE_SCRIPT"
  local -a mismatched
  mapfile -t mismatched < <(
    join -t $'\t' \
      <(_expected_plugin_states) \
      <(_installed_plugins | cut -f1,3) |
      awk -F'\t' '$2 != $3 {print $1 " (" $3 " -> " $2 ")"}'
  )
  if [[ ${#mismatched[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${mismatched[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Apply enabled state" "${mismatched[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing changed."
    return 0
  fi
  local label plugin
  for label in "${picked[@]}"; do
    plugin="${label%% *}"
    if [[ "$label" == *"-> enabled)" ]]; then
      claude plugin enable "$plugin" || echo "Failed to enable $plugin, continuing." >&2
    else
      claude plugin disable "$plugin" || echo "Failed to disable $plugin, continuing." >&2
    fi
  done
}

_uninstall_plugins
_sync_plugin_states
_remove_marketplaces

_done
