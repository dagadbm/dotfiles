#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# setup brew
# brew automatically install and updated xcode
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# print commands
# do this after setup brew else brew will print the shell script
set -x

# setup macos defaults
./macos/defaults.sh

# setup dotfiles
./submodules.sh
./dotbot.sh

# include common gitconfig file on dotfiles repo
git config --global include.path .gitconfig_global

# setup brew
brew bundle --no-lock --file macos/Brewfile

# set homebrew's zsh as the default shell for everyone
sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

# setup asdf
## go
asdf plugin add golang
asdf install golang latest
asdf global golang $(asdf latest golang)

## rust
asdf plugin add rust
asdf install rust latest
asdf global rust $(asdf latest rust)

## nodejs
brew install coreutils gpg
asdf plugin add nodejs
/bin/bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)

## python
brew install openssl readline xz zlib
asdf plugin add python
asdf install python latest:2
asdf install python latest:3
asdf global python $(asdf latest python 3) $(asdf latest python 2)

## direnv
asdf plugin add direnv
asdf install direnv latest
asdf global direnv $(asdf latest direnv)
asdf direnv setup --shell zsh --version $(asdf latest direnv)

# neovim
## nvr
pip3 install --upgrade neovim-remote

## python provider
pip2 install --upgrade pynvim
pip3 install --upgrade pynvim

## nodejs provider
npm install -g neovim@latest

# reshim asdf just in case
asdf reshim

# setup tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
pushd ~/.tmux/plugins/tmux-thumbs
./tmux-thumbs-install.sh
popd

# setup fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

## install plugins on neovim
nvim --headless "+Lazy! restore" +qa
nvim -c 'autocmd User LazySync Copilot auth' -c 'autocmd User LazySync TSUpdate' -c "autocmd User VeryLazy Lazy sync"
