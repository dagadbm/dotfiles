#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# Ask for the administrator password upfront
sudo -v

# keep sudo ticket alive until script exits so casks do not re-prompt
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
trap 'kill $! 2>/dev/null' EXIT

# brew
brew bundle --file macos/Brewfile
brew update
brew upgrade

# wezterm
brew upgrade --cask wezterm@nightly --greedy-latest

# tailscale
mosh_server="$(command -v mosh-server)"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$mosh_server"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$mosh_server"
brew doctor || true
