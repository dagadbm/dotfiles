# nvim
nvim +PlugClean +PlugInstall +PlugUpdate +CocInstall +CocUpdateSync +CocRebuild +qall

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# asdf
asdf plugin update --all

# brew
brew cleanup && brew update && brew upgrade
