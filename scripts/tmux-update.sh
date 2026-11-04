#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# tmux
"$HOME/.tmux/plugins/tpm/bin/clean_plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
"$HOME/.tmux/plugins/tpm/bin/update_plugins" all
## tmux-thumbs
if command -v cargo >/dev/null 2>&1; then
  pushd "$HOME/.tmux/plugins/tmux-thumbs" || exit
  cargo build --release --target-dir=target
  popd || exit
fi
