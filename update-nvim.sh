#!/usr/bin/env bash

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip3 install --upgrade pynvim

## node provider
npm install -g neovim@latest

brew upgrade tree-sitter --fetch-HEAD
brew upgrade neovim --fetch-HEAD
nvim -c 'autocmd User MasonUpdateAllComplete TSUpdateSync | qall' \
     -c 'autocmd User LazySync MasonUpdate' \
     -c 'autocmd User VeryLazy Lazy sync' \
     "$(realpath $0)"
