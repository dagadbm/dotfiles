#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

## ccstatusline
pnpm add -g ccstatusline@latest

## marketplaces
marketplaces=(
  anthropics/claude-plugins-official
  JuliusBrussee/caveman
  addyosmani/agent-skills
  TheOnlyFusionCube/potetos-for-everyone
)
for marketplace in "${marketplaces[@]}"; do
  claude plugin marketplace add "$marketplace"
done
claude plugin marketplace update

## plugins: <plugin>::<enabled>, install re-enables so state is applied after
plugins=(
  mattpocock-skills@claude-plugins-official::false
  superpowers@claude-plugins-official::false
  caveman@caveman::true
  agent-skills@addy-agent-skills::true
  pstack@potetos-for-everyone::false
)
for entry in "${plugins[@]}"; do
  plugin="${entry%::*}"
  enabled="${entry##*::}"
  claude plugin install "$plugin"
  claude plugin update "$plugin"
  # enable/disable fail when already in that state
  if [[ "$enabled" == true ]]; then
    claude plugin enable "$plugin" 2>/dev/null || true
  else
    claude plugin disable "$plugin" 2>/dev/null || true
  fi
done

### caveman
npx @caveman-ai/cli@latest
caveman telemetry off
caveman off routing
caveman providers cloud off
