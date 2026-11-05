#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# ccstatusline
pnpm add -g ccstatusline@latest

# plugins: <marketplace repo>::<plugin>::<installed>. A marketplace is added
# while any of its plugins is installed and removed once none is; disabled
# plugins still list their skills, so unwanted ones are uninstalled instead
plugins=(
  anthropics/claude-plugins-official::mattpocock-skills::true
  anthropics/claude-plugins-official::superpowers::false
  JuliusBrussee/caveman::caveman::true
  addyosmani/agent-skills::agent-skills::false
  TheOnlyFusionCube/potetos-for-everyone::pstack::false
  DietrichGebert/ponytail::ponytail::false
  mvanhorn/last30days-skill::last30days::false
  heygen-com/hyperframes::hyperframes::false
)

# plugin ids and `marketplace remove` use the marketplace name, not the repo;
# empty when the marketplace is not added
_marketplace_name() {
  claude plugin marketplace list --json |
    jq -r --arg repo "$1" '.[] | select(.repo == $repo) | .name'
}

repos="$(printf '%s\n' "${plugins[@]}" | sed 's/::.*//' | sort -u)"
wanted_repos="$(printf '%s\n' "${plugins[@]}" | sed -n 's/::.*::true$//p' | sort -u)"

while read -r repo; do
  if grep -qxF "$repo" <<<"$wanted_repos"; then
    claude plugin marketplace add "$repo"
  fi
done <<<"$repos"
claude plugin marketplace update

for entry in "${plugins[@]}"; do
  repo="${entry%%::*}"
  rest="${entry#*::}"
  installed="${rest##*::}"
  name="$(_marketplace_name "$repo")"
  # marketplace not added, so none of its plugins can be installed
  if [[ -z "$name" ]]; then
    continue
  fi
  plugin="${rest%::*}@$name"
  if [[ "$installed" == true ]]; then
    claude plugin install "$plugin"
    claude plugin update "$plugin"
    # enable fails when already enabled
    claude plugin enable "$plugin" 2>/dev/null || true
  else
    # uninstall fails when not installed
    claude plugin uninstall "$plugin" 2>/dev/null || true
  fi
done

# after the plugin loop, so their plugins uninstall first
while read -r repo; do
  if ! grep -qxF "$repo" <<<"$wanted_repos"; then
    name="$(_marketplace_name "$repo")"
    if [[ -n "$name" ]]; then
      claude plugin marketplace remove "$name"
    fi
  fi
done <<<"$repos"

# mcp servers: '<name>::<json>::<installed>', user scope. The json is what
# `claude mcp add-json` takes; keep secrets out of it, this file is committed.
# Single quote entries and write paths as a literal ${HOME}: Claude Code expands
# it when starting the server, so entries work on every machine
# caveman is not listed: `caveman enable claude` below owns its entry and
# refuses to disable once anything else rewrote it
mcp_servers=(
)
for entry in "${mcp_servers[@]}"; do
  name="${entry%%::*}"
  installed="${entry##*::}"
  json="${entry#*::}"
  json="${json%::*}"
  current="$(jq -c --arg name "$name" '.mcpServers[$name] // empty' "$HOME/.claude.json")"
  if [[ "$installed" == true ]]; then
    # rewrite only on change: other tools (caveman) check their entry is untouched
    if [[ "$(jq -cS . <<<"$json")" != "$(jq -cS . <<<"${current:-null}")" ]]; then
      if [[ -n "$current" ]]; then
        claude mcp remove --scope user "$name"
      fi
      claude mcp add-json --scope user "$name" "$json"
    fi
  elif [[ -n "$current" ]]; then
    claude mcp remove --scope user "$name"
  fi
done

# caveman
## caveman bakes the package's absolute path into Claude hooks, committed in
## agents/claude/settings.json. Installed by mise with npm it gets a stable,
## identical path on every machine (installs/npm-caveman-ai-cli/<version>/lib/)
## that survives node updates; pnpm (`pnpm add -g` or mise's
## npm.package_manager = "pnpm") uses a per-machine hashed dir instead.
## mise has no per-tool package manager, so force npm inline here, and always
## reinstall in case a plain `mise install` used pnpm. scripts/mise-update.sh
## skips caveman so it is only upgraded here
MISE_NPM_PACKAGE_MANAGER=npm mise upgrade npm:@caveman-ai/cli
MISE_NPM_PACKAGE_MANAGER=npm mise install --force npm:@caveman-ai/cli

## mise only installs the CLI; this fetches the ~/.caveman/bin binaries
## (caveman-proxy, caveman-mcp, ...) that hooks and the MCP server run
caveman update

## caveman bakes absolute node/pnpm paths into its hooks, which go stale on
## upgrades; reinstall them. `hooks uninstall` must run before `disable`, which
## refuses while a shrink-hook it did not write is present
caveman hooks uninstall claude
caveman disable claude
caveman hooks install claude
caveman enable claude

caveman telemetry off
caveman off routing
caveman providers cloud off

# ponytail
## hide the plugin band above the prompt
## run `/ponytail band on` inside claude to shows it again
echo off > "$HOME/.claude/.ponytail-band"
