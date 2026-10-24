#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# shell
shellcheck -x -S warning scripts/*.sh macos/*.sh

# zsh
for f in zsh/*.zsh; do zsh -n "$f"; done

# toml
find . -path ./submodules -prune -o -name '*.toml' -print0 | xargs -0 taplo check

# yaml
find . -path ./submodules -prune -o \( -name '*.yml' -o -name '*.yaml' \) -print0 |
  xargs -0 ruby -ryaml -e 'ARGV.each { |f| YAML.load_file(f) }'

# json (vscode/*.json is JSONC, jq rejects it)
find . \( -path ./submodules -o -path ./vscode -o -path ./.git \) -prune -o -name '*.json' -print0 |
  xargs -0 -n1 jq empty >/dev/null

# git config
git config -f git/gitconfig --list >/dev/null
git config -f git/gitconfig_global --list >/dev/null
git config -f git/gitconfig_personal --list >/dev/null
git config -f git/gitconfig_work --list >/dev/null
git config -f git/delta.astrodark.gitconfig --list >/dev/null

# tmux
tmux -L t -f tmux/tmux.conf start-server \; kill-server

# brewfile
brew bundle check --no-upgrade --file=macos/Brewfile >/dev/null

# lua
stylua neovim/astrovim neovim/lazyvim neovim/dagadbm
(cd neovim/astrovim && selene .)

# markdown
rumdl fmt . --no-cache --exclude submodules
rumdl check . --no-cache --exclude submodules
