#!/usr/bin/env bash
set -x

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
pushd ~/.tmux/plugins/tmux-thumbs
./tmux-thumbs-install.sh update
popd

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# asdf
asdf plugin update --all
asdf direnv setup --shell zsh --version $(asdf latest direnv)

# brew
brew bundle --file macos/Brewfile
brew update && brew upgrade && brew cleanup && brew doctor

# submodules
./submodules.sh

# nvim
brew reinstall neovim

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip2 install --upgrade pynvim
pip3 install --upgrade pynvim

## node provider
npm update -g neovim@latest
npm update -g neovim

## install plugins on neovim
nvim -c 'autocmd User LazySync TSUpdateSync | qall' -c "autocmd User VeryLazy Lazy sync"
