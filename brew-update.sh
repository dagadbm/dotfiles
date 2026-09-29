#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# brew
brew bundle --file macos/Brewfile
brew update
brew upgrade
brew doctor || true
