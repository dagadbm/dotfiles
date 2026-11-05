#!/usr/bin/env bash
set -euxo pipefail

source "$(dirname "$0")/utils.sh"

_sudo_keepalive

# disable homebrew analytics and other telemetry
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSIGHTS=1

# install brew
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  set +x
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  set -x
fi
brew analytics off

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo /opt/homebrew/bin/zsh >> /etc/shells"
sudo chsh -s "/opt/homebrew/bin/zsh"

# xcode
xcode-select --install || true

# macos
./macos/defaults.sh

# dotbot
scripts/submodules-update.sh
scripts/dotbot.sh

# brew
brew bundle --file macos/Brewfile

# mise
mise trust mise.toml
mise install

# neovim
bob install latest
bob install nightly
bob use nightly

# broot
mkdir -p "$HOME/.config/broot/launcher/zsh"
broot --print-shell-function zsh > "$HOME/.config/broot/launcher/zsh/br"
broot --set-install-state installed

# update
scripts/tmux-update.sh
scripts/brew-update.sh
scripts/shell-update.sh
scripts/mise-update.sh
scripts/hk-update.sh
scripts/herdr-update.sh
scripts/nvim-update.sh
scripts/claude-update.sh
scripts/macos-update.sh
scripts/tailscale-update.sh
