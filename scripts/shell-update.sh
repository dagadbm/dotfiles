#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# fzf
"$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# bat
bat cache --build

# zsh
## fast-syntax-highlighting
zsh -c 'source "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" && fast-theme -q "$HOME/.config/shell/fsh.astrodark.ini"'
