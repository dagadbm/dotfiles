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
git submodule add https://github.com/user_name/repo_name.git submodules/repo_name
### Update
./submodules.sh
### Delete
export MODULE=submodules/repo_name && git submodule deinit -f $MODULE && rm -rf .git/modules/$MODULE && git rm -f $MODULE
