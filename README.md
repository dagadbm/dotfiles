# dotfiles

Welcome to my humble dotfiles repo.

This was done with a lot of love and I occasionally update it.

# Install

First run install script `./install` to set up the install scripts
Switch over to zsh or even better make it your default one `sudo chsh $(which zsh)`
Reload the shell now using zsh
go into the dotfiles repo and run the command `dotfiles_update` which is an alias to setup git submodules

For mac I recommend installing iterm2 as well as Fira Code font.

# Features

This uses the amazing dotbot to handle all the symlinking.
These dotfiles are mainly for zsh, vim and space-macs (though I haven't been using emacs for a while now).

# Support

For now this works on linux/mac and windows (via WSL only)
If you have any questions please feel free to open an Issue


# Git Submodules
## Add
git submodule add https://github.com/url_to/awesome_submodule.git path_to_awesome_submodule
## Update
./submodules.sh
## Delete
Delete the relevant section from the .gitmodules file.
Stage the .gitmodules changes git add .gitmodules
Delete the relevant section from .git/config.
Run git rm --cached path_to_submodule (no trailing slash).
Run rm -rf .git/modules/path_to_submodule (no trailing slash).
Commit git commit -m "Removed submodule "
Delete the now untracked submodule files rm -rf path_to_submodule
