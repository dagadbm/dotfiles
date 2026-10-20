#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

UPDATE_SCRIPT="claude-update.sh"

_check_dependency() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not found" >&2
    exit 1
  fi
}

_check_dependency claude
_check_dependency fzf
_check_dependency jq

if [[ ! -f "$UPDATE_SCRIPT" ]]; then
  echo "Error: $UPDATE_SCRIPT not found" >&2
  exit 1
fi

# Marketplace GitHub repos declared in claude-update.sh, one per line.
_expected_marketplaces() {
  sed -n '/^marketplaces=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -n 's/^[[:space:]]*\([^[:space:]/]*\/[^[:space:]]*\)[[:space:]]*$/\1/p' | sort -u
}

# Plugin ids (name@marketplace) declared in claude-update.sh, one per line.
_expected_plugins() {
  sed -n '/^plugins=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -n 's/^[[:space:]]*\([^[:space:]]*@[^[:space:]]*\)[[:space:]]*$/\1/p' | sort -u
}

# Plugins installed locally or synced, enabled or disabled, as "id<TAB>scope".
# Run from $HOME: project-scoped plugins are only listed from their own project.
_installed_plugins() {
  (cd "$HOME" && claude plugin list --json 2>/dev/null) |
    jq -r '.[] | [.id, (.scope // "synced"), (if .enabled then "enabled" else "disabled" end)] | @tsv' | sort -u
}

# Scope of one installed plugin: user, project, local or synced.
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

declare -a extra_plugins extra_marketplaces

mapfile -t extra_plugins < <(comm -23 \
  <(_installed_plugins | cut -f1) \
  <(_expected_plugins))

mapfile -t extra_marketplaces < <(
  _installed_marketplaces |
    while IFS=$'\t' read -r name repo; do
      grep -qxF "$repo" <(_expected_marketplaces) || printf '%s\n' "$name"
    done
)

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

_uninstall_plugins() {
  echo
  echo "== Enabled plugins not in claude-update.sh =="
  if [[ ${#extra_plugins[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  # Project-scoped and claude.ai-synced plugins are labelled so they are not removed by accident.
  local -a labels=()
  local plugin scope state project_path
  for plugin in "${extra_plugins[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    state="$(_plugin_state "$plugin")"
    case "$scope" in
      project)
        project_path="$(_plugin_project_path "$plugin")"
        labels+=("$plugin (project scoped: ${project_path/#$HOME/\~}, $state)")
        ;;
      synced) labels+=("$plugin (synced, $state)") ;;
      *) labels+=("$plugin ($state)") ;;
    esac
  done
  printf '  %s\n' "${labels[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall plugins" "${labels[@]}" | sed -E 's/ \(.*\)$//')
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing uninstalled."
    return 0
  fi
  for plugin in "${picked[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    if [[ "$scope" == synced ]]; then
      # claude.ai-synced plugins cannot be uninstalled here, only disabled.
      claude plugin disable "$plugin" || echo "Failed to disable $plugin, continuing." >&2
    elif [[ "$scope" == project ]]; then
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
  echo
  echo "== Marketplaces not in claude-update.sh =="
  if [[ ${#extra_marketplaces[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra_marketplaces[@]}"
  echo
  echo "WARNING: removing a marketplace also removes plugins installed from it."

  local -a picked
  mapfile -t picked < <(_pick "Remove marketplaces" "${extra_marketplaces[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  local marketplace
  for marketplace in "${picked[@]}"; do
    claude plugin marketplace remove "$marketplace" || echo "Failed to remove $marketplace, continuing." >&2
  done
}

_uninstall_plugins
_remove_marketplaces

echo
echo "Done."
