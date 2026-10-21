#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# Ask for the administrator password upfront
sudo -v

# disable homebrew analytics and other telemetry
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSIGHTS=1

# setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

# print commands
# do this after setup brew else brew will print the shell script
set -x

# xcode
xcode-select --install || true

# setup macos defaults
./macos/defaults.sh

# submodules
scripts/submodules-update.sh

# setup dotfiles
scripts/dotbot.sh

# setup brew
brew bundle --file macos/Brewfile

# tailscale
zsh -ic 'nightshift login && nightshift connect'

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo /opt/homebrew/bin/zsh >> /etc/shells"
sudo chsh -s "/opt/homebrew/bin/zsh"

# setup mise
mise trust mise.toml
mise install

# neovim
bob install latest
bob install nightly
bob use nightly
scripts/nvim-update.sh

# broot
mkdir -p "$HOME/.config/broot/launcher/zsh"
broot --print-shell-function zsh > "$HOME/.config/broot/launcher/zsh/br"
broot --set-install-state installed

# update
scripts/update.sh
