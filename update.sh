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

# brew
brew bundle --no-lock --file macos/Brewfile
brew cleanup && brew update && brew upgrade

# nvim
brew upgrade neovim --fetch-HEAD
nvim +PackerSync
