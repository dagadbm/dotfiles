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
./update-submodules.sh

# setup dotfiles
./dotbot.sh

# setup brew
brew bundle --file macos/Brewfile

# set homebrew's zsh as the default shell for everyone
sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

# setup mise
mise install

# neovim
./update-nvim.sh

# update
./update.sh
