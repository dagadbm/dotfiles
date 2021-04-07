# submodules
git submodule foreach --recursive git reset --hard
git submodule update --recursive --remote
git submodule foreach --recursive git reset --hard

# nvim
brew upgrade neovim --fetch-HEAD
nvim +PackerSync +LspSync +qall

# tmux
~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# asdf
asdf plugin update --all

# brew
brew bundle --no-lock --file macos/Brewfile
brew cleanup && brew update && brew upgrade
