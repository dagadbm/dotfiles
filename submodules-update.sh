#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# submodules
git submodule foreach git remote prune origin
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard
