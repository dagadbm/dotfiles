#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# mandatory install for mac
xcode-select --install

# setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# setup macos defaults
./macos/defaults.sh

# setup dotfiles
git submodule update --init --recursive
./submodules.sh
./dotbot.sh

# setup submodules
git submodule update --recursive --remote

# include common gitconfig file on dotfiles repo
git config --global include.path .gitconfig_global

# setup tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# setup brew
brew bundle --no-lock --file macos/Brewfile

# setup asdf
## nodejs
brew install coreutils gpg
asdf plugin add nodejs
/bin/bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)

## yarn
asdf plugin add yarn
asdf install yarn latest
asdf global yarn $(asdf latest yarn)

## python
brew install openssl readline xz zlib
asdf plugin add python
asdf install python latest:2
asdf install python latest:3
asdf global python $(asdf latest python 3) $(asdf latest python 2)

## ruby
asdf plugin add ruby
# support for m1 mac
# https://github.com/asdf-vm/asdf-ruby/issues/285
optflags=-Wno-error=implicit-function-declaration ASDF_RUBY_BUILD_VERSION=v20220630 asdf install ruby latest
asdf global ruby $(asdf latest ruby)

## go
asdf plugin add golang
asdf install golang latest
asdf global golang $(asdf latest golang)

## rust
asdf plugin add rust
asdf install rust latest
asdf global rust $(asdf latest rust)

## perl
asdf plugin add perl
asdf install perl latest
asdf global perl $(asdf latest perl)

## direnv
asdf plugin add direnv
asdf install direnv latest
asdf global direnv $(asdf latest direnv)

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# neovim checkhealth fixes
## nvr
pip install neovim-remote

## nodejs provider
npm install -g neovim

## python provider
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

## ruby provider
gem install neovim

## perl provider
cpanm Neovim::Ext

# reshim asdf just in case
asdf reshim

## install plugins on neovim
nvim +PackerInstall +PackerCompile +PackerSync
