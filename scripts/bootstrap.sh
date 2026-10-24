#!/usr/bin/env bash
set -euxo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# Ask for the administrator password upfront
sudo -v

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

# submodules
scripts/submodules-update.sh

# dotfiles
scripts/dotbot.sh

# brew
brew bundle --file macos/Brewfile

# mise
mise trust mise.toml
mise install
mise exec -- hk install --mise

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

