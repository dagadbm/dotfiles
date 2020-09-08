# submodules
git submodule foreach --recursive git reset --hard
git submodule update --recursive --remote --merge
git submodule foreach --recursive git reset --hard

# nvim
nvim +PlugClean +PlugInstall +PlugUpdate +CocInstall +CocUpdateSync +CocRebuild +qall

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# asdf
asdf plugin update --all

# brew
brew cleanup && brew update && brew upgrade
