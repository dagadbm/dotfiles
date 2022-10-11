#!/usr/bin/env bash
set -x

# Ask for the administrator password upfront
sudo -v

# mandatory install for mac
xcode-select --install

# setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# setup macos defaults
./macos/defaults.sh

# setup dotfiles
./submodules.sh
./dotbot.sh

# include common gitconfig file on dotfiles repo
git config --global include.path .gitconfig_global

# setup tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
pushd ~/.tmux/plugins/tmux-thumbs
./tmux-thumbs-install.sh update
popd

# setup brew
brew bundle --no-lock --file macos/Brewfile

# setup asdf
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

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# neovim
## nvr
pip install --upgrade neovim-remote
pip install --upgrade neovim-remote

## python provider
pip install --upgrade pynvim
pip install --upgrade pynvim

## nodejs provider
npm install -g neovim@latest

## neovim lsp specific installs
npm install -g eslint_d@latest @fsouza/prettierd@latest

# reshim asdf just in case
asdf reshim

## install plugins on neovim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
