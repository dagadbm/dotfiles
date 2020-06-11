# dotfiles

Welcome to my humble dotfiles repo.

This was done with a lot of love and I occasionally update it.

# Install

First run install script `./bootstrap.sh` to download and setup everything

# Features

This uses the amazing dotbot to handle all the symlinking.
These dotfiles are mainly for zsh, vim, and macos apps

# Support

For now this works on mac os only
If you have any questions please feel free to open an Issue

# Helpers
## Git Submodules
### Add
git submodule add https://github.com/url_to/awesome_submodule.git path_to_awesome_submodule
### Update
./submodules.sh
### Delete
Delete the relevant section from the .gitmodules file.
Stage the .gitmodules changes git add .gitmodules
Delete the relevant section from .git/config.
Run git rm --cached path_to_submodule (no trailing slash).
Run rm -rf .git/modules/path_to_submodule (no trailing slash).
Commit git commit -m "Removed submodule "
Delete the now untracked submodule files rm -rf path_to_submodule
