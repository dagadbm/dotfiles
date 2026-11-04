#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

sudo -v
# keep sudo ticket alive until script exits so later tasks do not re-prompt
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &

mise run --jobs 1 \
  ::: tmux:update \
  ::: submodules:update \
  ::: brew:update \
  ::: shell:update \
  ::: mise:update \
  ::: hk:update \
  ::: herdr:update \
  ::: nvim:update \
  ::: claude:update \
  ::: macos:update \
  ::: tailscale:update
