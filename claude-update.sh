#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# ccstatusline
pnpm add -g ccstatusline@latest

# language servers for the *-lsp plugins, each from its official install method
rustup component add rust-analyzer

mise use -g \
  npm:pyright@latest \
  go:golang.org/x/tools/gopls@latest \
  aqua:LuaLS/lua-language-server@latest

# claude code only supports typescript-language-server which needs ts6
mise use -g \
  npm:typescript@6 \
  npm:typescript-language-server@latest \

# marketplaces
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

# plugins
plugins=(
  caveman@caveman
  mattpocock-skills@claude-plugins-official
  agent-skills@addy-agent-skills
  pstack@potetos-for-everyone
  rust-analyzer-lsp@claude-plugins-official
  pyright-lsp@claude-plugins-official
  typescript-lsp@claude-plugins-official
  gopls-lsp@claude-plugins-official
  lua-lsp@claude-plugins-official
)
for plugin in "${plugins[@]}"; do
  claude plugin install "$plugin"
  claude plugin update "$plugin"
done

## caveman
 npx @caveman-ai/cli@latest
