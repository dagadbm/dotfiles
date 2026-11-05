#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

source "$(dirname "$0")/prune-utils.sh"

UPDATE_SCRIPT="scripts/claude-update.sh"

_check_dependency claude
_check_dependency fzf
_check_dependency jq
_check_file "$UPDATE_SCRIPT"

# Plugins declared in claude-update.sh as repo::plugin::true|false,
# as "repo<TAB>plugin<TAB>true|false".
_declared_plugins() {
  sed -n '/^plugins=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -nE 's/^[[:space:]]*([^[:space:]]+\/[^[:space:]:]+)::([^[:space:]:]+)::(true|false)[[:space:]]*$/\1\t\2\t\3/p'
}

# Marketplace GitHub repos with at least one ::true plugin, one per line.
# Repos whose plugins are all ::false are not expected, so they are offered for removal.
_expected_marketplaces() {
  _declared_plugins | awk -F'\t' '$3 == "true" {print $1}' | sort -u
}

# ::true plugin ids (name@marketplace), one per line. ::false means uninstalled, as in
# claude-update.sh, so installed ::false plugins are offered for uninstall.
# The id needs the marketplace name, so plugins of marketplaces that are not
# added are skipped.
_expected_plugins() {
  awk -F'\t' 'FILENAME == ARGV[1] {name[$1] = $2; next}
              ($1 in name) && $3 == "true" {print $2 "@" name[$1]}' \
    <(claude plugin marketplace list --json 2>/dev/null | jq -r '.[] | select(.repo) | [.repo, .name] | @tsv') \
    <(_declared_plugins) | sort -u
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

# One item for _print_items and _pick: key, title, then one detail per line.
_item() {
  local IFS=$'\t'
  printf '%s\n' "$*"
}

# Detail line "scope: …, project: …, status: …"; project is left out when empty.
_scope_detail() {
  local scope="$1" project="${2/#$HOME/\~}" status="$3"
  printf 'scope: %s%s, status: %s' "$scope" "${project:+, project: $project}" "$status"
}

# Detail line saying which claude-update.sh array keeps an entry.
_keep_detail() {
  printf "To keep, add to %s in %s: '%s'" "$1" "$UPDATE_SCRIPT" "$2"
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

  # Project and local scoped plugins show their project so they are not removed by accident.
  local -a items=()
  local plugin scope project_path repo
  local -a details
  for plugin in "${extra[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    project_path=""
    if [[ "$scope" == project || "$scope" == local ]]; then
      project_path="$(_plugin_project_path "$plugin")"
    fi
    details=("$(_scope_detail "$scope" "$project_path" "$(_plugin_state "$plugin")")")
    # update only adds GitHub marketplaces, so others get no keep hint
    repo="$(_installed_marketplaces | awk -F'\t' -v name="${plugin#*@}" '$1 == name {print $2}')"
    if [[ -n "$repo" ]]; then
      details+=("$(_keep_detail plugins "$repo::${plugin%@*}::true")")
    fi
    items+=("$(_item "$plugin" "$plugin" "${details[@]}")")
  done
  _print_items "${items[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall plugins" "${items[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  for plugin in "${picked[@]}"; do
    scope="$(_plugin_scope "$plugin")"
    if [[ "$scope" == project || "$scope" == local ]]; then
      # Project and local scoped plugins are only visible from the project they were installed in.
      project_path="$(_plugin_project_path "$plugin")"
      (cd "$project_path" && claude plugin uninstall --scope "$scope" "$plugin") ||
        echo "Failed to uninstall $plugin from $project_path, continuing." >&2
    else
      claude plugin uninstall --scope "$scope" "$plugin" || echo "Failed to uninstall $plugin, continuing." >&2
    fi
  done
}

_remove_marketplaces() {
  _section "Marketplaces not in $UPDATE_SCRIPT"
  local -a items
  mapfile -t items < <(
    _installed_marketplaces |
      while IFS=$'\t' read -r name repo; do
        grep -qxF "$repo" <(_expected_marketplaces) ||
          _item "$name" "$name" "repo: $repo" "$(_keep_detail plugins "$repo::<plugin>::true")"
      done
  )
  if [[ ${#items[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  _print_items "${items[@]}"
  _warn "removing a marketplace also removes plugins installed from it."

  local -a picked
  mapfile -t picked < <(_pick "Remove marketplaces" "${items[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  local marketplace
  for marketplace in "${picked[@]}"; do
    claude plugin marketplace remove "$marketplace" || echo "Failed to remove $marketplace, continuing." >&2
  done
}


# MCP server names declared in claude-update.sh as name::json::true, one per line.
_expected_mcp_servers() {
  sed -n '/^mcp_servers=(/,/^)/p' "$UPDATE_SCRIPT" |
    sed -nE "s/^[[:space:]]*'?([^[:space:]':]+)::.*::true'?[[:space:]]*\$/\\1/p" | sort -u
}

# MCP servers in ~/.claude.json as "name<TAB>scope<TAB>project<TAB>status<TAB>json".
# User scope lives at the top level (project "-"), local scope per project; project scope
# (.mcp.json) belongs to its repo and is skipped.
_installed_mcp_servers() {
  jq -r '
    ((.mcpServers // {}) | to_entries[] | [.key, "user", "-", "enabled", (.value | tojson)]),
    ((.projects // {}) | to_entries[] | .key as $path | (.value.disabledMcpServers // []) as $off |
      (.value.mcpServers // {}) | to_entries[] |
      [.key, "local", $path, (if (.key | IN($off[])) then "disabled" else "enabled" end), (.value | tojson)])
    | @tsv' "$HOME/.claude.json" 2>/dev/null
}

# Local and undeclared user servers; update only manages user scope by name.
_remove_mcp_servers() {
  _section "MCP servers not in $UPDATE_SCRIPT"
  local -a extra keys=() items=()
  mapfile -t extra < <(
    _installed_mcp_servers |
      while IFS=$'\t' read -r name scope path status json; do
        if [[ "$scope" == user ]] && grep -qxF "$name" <(_expected_mcp_servers); then
          continue
        fi
        printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$scope" "$path" "$status" "$json"
      done
  )
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi

  local line name scope path status json project
  for line in "${extra[@]}"; do
    IFS=$'\t' read -r name scope path status json <<<"$line"
    project=""
    keys+=("$name")
    if [[ "$scope" == local ]]; then
      project="$path"
      # a local server can exist in several projects, so its key adds the project
      keys[-1]+=" ${path/#$HOME/\~}"
    fi
    # literal ${HOME} keeps the pasted entry portable; Claude Code expands it
    items+=("$(_item "${keys[-1]}" "$name" "$(_scope_detail "$scope" "$project" "$status")" \
      "$(_keep_detail mcp_servers "$name::${json//$HOME/\${HOME\}}::true")")")
  done
  _print_items "${items[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Remove MCP servers" "${items[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  local key i
  for key in "${picked[@]}"; do
    for i in "${!keys[@]}"; do
      [[ "${keys[$i]}" == "$key" ]] || continue
      IFS=$'\t' read -r name scope path status json <<<"${extra[$i]}"
      if [[ "$scope" == local ]]; then
        # local servers are only visible from their project
        (cd "$path" && claude mcp remove --scope local "$name") ||
          echo "Failed to remove $name from $path, continuing." >&2
      else
        claude mcp remove --scope user "$name" || echo "Failed to remove $name, continuing." >&2
      fi
    done
  done
}

_uninstall_plugins
_remove_marketplaces
_remove_mcp_servers

_done
