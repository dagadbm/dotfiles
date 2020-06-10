# handle git sub modules
git submodule update --recursive --init
./submodules.sh

# setup macos defaults
./macos/defaults.sh

# setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --file macos/Brewfile

# setup dotfiles
./dotfiles.sh

# setup fzf
~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

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

## python
xcode-select --install 
brew install openssl readline xz zlib
asdf plugin add python
asdf install python latest:2
asdf install python latest:3
asdf global python $(asdf latest python 3) $(asdf latest python 2)
#python will point to version 3 latest
#python3 will point to version 3 latest
#python2 will point to version 2 latest

# set zsh as default shell
chsh -s $(which zsh)
