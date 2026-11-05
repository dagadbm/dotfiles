#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

_sudo_keepalive

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
