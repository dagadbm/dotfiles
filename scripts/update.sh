#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# tmux
"$HOME/.tmux/plugins/tpm/bin/clean_plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all
## tmux-thumbs
if command -v cargo >/dev/null 2>&1; then
  pushd "$HOME/.tmux/plugins/tmux-thumbs" || exit
  cargo build --release --target-dir=target
  popd || exit
fi

# submodules
scripts/submodules-update.sh

# brew
scripts/brew-update.sh

# fzf
"$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# bat
bat cache --build

# zsh
## fast-syntax-highlighting
zsh -c 'source "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" && fast-theme -q "$HOME/.config/shell/fsh.astrodark.ini"'

# mise
scripts/mise-update.sh

# hk
scripts/hk-update.sh

# herdr
scripts/herdr-update.sh

# pnpm
pnpm setup || true

# claude
scripts/claude-update.sh

# macos
softwareupdate --download --install --all

# tailscale
scripts/tailscale-update.sh
