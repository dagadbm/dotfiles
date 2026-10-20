#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
## tmux-thumbs
if command -v cargo >/dev/null 2>&1; then
  pushd ~/.tmux/plugins/tmux-thumbs || exit
  cargo build --release --target-dir=target
  popd || exit
fi

# submodules
scripts/submodules-update.sh

# brew
scripts/brew-update.sh

# astrodark theme
## bat
bat cache --build
## fast-syntax-highlighting
zsh -c 'source ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme -q ~/.config/shell/fsh.astrodark.ini'

# mise
scripts/mise-update.sh

# herdr
scripts/herdr-update.sh

# pnpm
pnpm setup || true

# claude
scripts/claude-update.sh

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# macos
softwareupdate --download --install --all
