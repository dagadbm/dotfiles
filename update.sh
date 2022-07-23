#!/usr/bin/env bash
set -x

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# asdf
asdf plugin update --all
asdf direnv setup --shell zsh --version $(asdf latest direnv)

# brew
brew bundle --no-lock --file macos/Brewfile
brew cleanup && brew update && brew upgrade

# submodules
./submodules.sh

# nvim
brew upgrade neovim --fetch-HEAD

## nvr
pip2 install --upgrade neovim-remote
pip3 install --upgrade neovim-remote

## python provider
pip2 install --upgrade pynvim
pip3 install --upgrade pynvim

## node provider
npm update -g neovim@latest
npm update -g neovim@latest

## neovim lsp specific installs
npm update -g eslint_d@latest @fsouza/prettierd@latest

nvim +PackerSync
