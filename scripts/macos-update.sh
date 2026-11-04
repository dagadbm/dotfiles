#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# macos
softwareupdate --download --install --all
