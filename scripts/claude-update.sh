#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# ccstatusline
pnpm add -g ccstatusline@latest

# marketplaces
marketplaces=(
  anthropics/claude-plugins-official
  JuliusBrussee/caveman
  addyosmani/agent-skills
  TheOnlyFusionCube/potetos-for-everyone
  DietrichGebert/ponytail
)
for marketplace in "${marketplaces[@]}"; do
  claude plugin marketplace add "$marketplace"
done
claude plugin marketplace update

# plugins: <plugin>::<installed>; disabled plugins still list their skills, so
# unwanted ones are uninstalled instead
plugins=(
  mattpocock-skills@claude-plugins-official::true
  superpowers@claude-plugins-official::false
  caveman@caveman::true
  agent-skills@addy-agent-skills::false
  pstack@potetos-for-everyone::false
  ponytail@ponytail::true
)
for entry in "${plugins[@]}"; do
  plugin="${entry%::*}"
  installed="${entry##*::}"
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
