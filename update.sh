#!/usr/bin/env bash

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
pushd ~/.tmux/plugins/tmux-thumbs
./tmux-thumbs-install.sh update
popd

# submodules
./update-submodules.sh

# brew
brew bundle --file macos/Brewfile
brew update && brew upgrade && brew cleanup && brew doctor

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# macos
softwareupdate --download --install --all
