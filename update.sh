#!/usr/bin/env bash

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
pushd ~/.tmux/plugins/tmux-thumbs
./tmux-thumbs-install.sh update
popd

# submodules
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard

# brew
brew bundle --file macos/Brewfile
brew update && brew upgrade && brew cleanup && brew doctor

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# asdf
asdf plugin update --all
asdf direnv setup --shell zsh --version $(asdf latest direnv)

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip3 install --upgrade pynvim

## node provider
npm update -g neovim

# nvim
echo "Update nvim nightly?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) brew upgrade neovim --fetch-HEAD; break;;
        No ) break;;
    esac
done

## update plugins on neovim
nvim -c 'autocmd User MasonUpdateAllComplete TSUpdateSync | qall' -c 'autocmd User LazySync MasonUpdateAll' -c 'autocmd User VeryLazy Lazy sync' "$(realpath $0)"

# macos
softwareupdate --install --all
