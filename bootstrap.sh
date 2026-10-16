#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Ask for the administrator password upfront
sudo -v

# To change computer name settings on a mac
# sudo scutil --set ComputerName computername
# sudo scutil --set HostName hostname
# sudo scutil --set LocalHostName localhostname

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
./submodules-update.sh

# setup dotfiles
./dotbot.sh

# setup brew
brew bundle --file macos/Brewfile

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo /opt/homebrew/bin/zsh >> /etc/shells"
sudo chsh -s "/opt/homebrew/bin/zsh"

# setup mise
mise install

# neovim
bob install latest
bob install nightly
bob use nightly
./nvim-update.sh

# broot
mkdir -p "$HOME/.config/broot/launcher/zsh"
broot --print-shell-function zsh > "$HOME/.config/broot/launcher/zsh/br"
broot --set-install-state installed

# update
./update.sh
