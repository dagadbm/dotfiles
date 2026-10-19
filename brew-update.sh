#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Ask for the administrator password upfront
sudo -v

# keep sudo ticket alive until script exits so casks do not re-prompt
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
trap 'kill $! 2>/dev/null' EXIT

# brew
brew bundle --file macos/Brewfile
brew update
brew upgrade

# tailscale
mosh_server="$(command -v mosh-server)"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$mosh_server"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$mosh_server"
brew doctor || true
