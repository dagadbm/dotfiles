#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip3 install --upgrade pynvim

## node provider
pnpm add -g neovim@latest

brew upgrade tree-sitter --fetch-HEAD
brew upgrade neovim --fetch-HEAD
nvim -c 'autocmd User MasonUpdateAllComplete TSUpdate | qall' \
     -c 'autocmd User LazySync MasonUpdateAll' \
     -c 'autocmd User VeryLazy Lazy sync' \
     "$(basename "$0")"
