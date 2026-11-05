#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

_sudo_keepalive

# brew
brew bundle --file macos/Brewfile
brew update
brew upgrade

# wezterm
brew upgrade --cask wezterm@nightly --greedy-latest

# tailscale
brew doctor || true
