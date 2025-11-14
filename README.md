# dotfiles

Welcome to my humble dotfiles repo.

# Install

First run install script `./bootstrap.sh` to download and setup everything

# Updates

Run `./update-nvim.sh` to update nvim
Run `./update-submodules.sh` to update submodules
Run `./update.sh` to update everything
Run `./dotbot.sh` to re-run dotbot

# Helpers
## Git Submodules
### Add
git submodule add https://github.com/wfxr/forgit.git submodules/forgit
### Delete
export MODULE=submodules/repo_name && git submodule deinit -f $MODULE && rm -rf .git/modules/$MODULE && git rm -f $MODULE
