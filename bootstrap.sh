# mandatory install for mac
xcode-select --install

# handle git sub modules
git submodule update --recursive --init
./update.sh

# setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --no-lock --file macos/Brewfile

# setup macos defaults
./macos/defaults.sh

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
asdf global yarn $(asdf latest yarn)

## python
brew install openssl readline xz zlib
asdf plugin add python
asdf install python latest:2
asdf install python latest:3
asdf global python $(asdf latest python 3) $(asdf latest python 2)
#python will point to version 3 latest
#python3 will point to version 3 latest
#python2 will point to version 2 latest

## ruby
asdf plugin add ruby
asdf install ruby latest
asdf global ruby $(asdf latest ruby)

## direnv
asdf plugin add direnv
asdf install direnv latest
asdf global direnv $(asdf latest direnv)

# set homebrew's zsh as the default shell for everyone
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# neovim checkhealth fixes
## nvr
pip install neovim-remote
## nodejs provider
npm install -g neovim
## ruby provider
gem install neovim
## python provider
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
asdf reshim
## perl provider
brew install perl cpanminus
cpanm Neovim::Ext
cpanm Neovim::Ext --force # Just in case it fails the first time
## install coc-extensions
cd ~/.config/coc/extensions
yarn install --frozen-lockfile
## install plugins on neovim
nvim +PlugInstall +PlugUpdate +CocInstall +CocUpdateSync +CocRebuild +CocRestart +qall
