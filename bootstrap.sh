#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# To change computer name settings on a mac
# sudo scutil --set ComputerName computername
# sudo scutil --set HostName hostname
# sudo scutil --set LocalHostName localhostname

# setup brew
# brew automatically install and updated xcode
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# print commands
# do this after setup brew else brew will print the shell script
set -x

# setup macos defaults
./macos/defaults.sh

# submodules
git submodule foreach git remote prune origin
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard

# setup dotfiles
./dotbot.sh

# setup brew
brew bundle --file macos/Brewfile

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
./update-nvim.sh

# update
./update.sh
