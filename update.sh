#!/usr/bin/env bash

# submodules
./submodules.sh

# brew
brew bundle --file macos/Brewfile
brew update && brew upgrade && brew cleanup && brew doctor

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

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip2 install --upgrade pynvim
pip3 install --upgrade pynvim

## node provider
npm update -g neovim

# wezterm
echo "Update wezterm nightly?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest; break;;
        No ) break;;
    esac
done
# nvim
echo "Update nvim nightly?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew upgrade neovim --fetch-HEAD; break;;
        No ) break;;
    esac
done

## update plugins on neovim
nvim -c 'autocmd User MasonUpdateAllComplete TSUpdateSync | qall' -c 'autocmd User LazySync MasonUpdateAll' -c 'autocmd User VeryLazy Lazy sync'
