#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# submodules
git submodule foreach git remote prune origin
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard
