#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

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
./submodules-update.sh

# brew
./brew-update.sh

# astrodark theme
## bat
bat cache --build
## fast-syntax-highlighting
zsh -c 'source ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh && fast-theme -q XDG:astrodark'

# mise
./mise-update.sh

# herdr
./herdr-update.sh

# pnpm
pnpm setup || true

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# macos
softwareupdate --download --install --all
