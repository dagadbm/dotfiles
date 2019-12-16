# taken from https://docs.brew.sh/Homebrew-on-Linux#alternative-installation

# better to use /home/linuxbrew/.linuxbrew but I haven't tested this yet
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir ~/.linuxbrew/bin
ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)
