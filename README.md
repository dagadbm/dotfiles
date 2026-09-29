# dotfiles

Welcome to my humble dotfiles repo.

# Install

First run install script `./bootstrap.sh` to download and setup everything

# Updates

Run `./dotbot.sh` to relink after changing `dotbot.conf.yaml`
Run `./update.sh` to update everything
Run `./nvim-update.sh` to update Neovim, LSP, plugins
Run `./herdr-update.sh` to update herdr
Run `./submodules-update.sh` to update submodules
Run `./brew-update.sh` to update Homebrew
Run `./mise-update.sh` to update mise
Run `./prune.sh` to prune everything (brew + mise)
Run `./brew-prune.sh` to prune Homebrew to match Brewfile
Run `./mise-prune.sh` to prune mise
Run `./macos/defaults.sh` to apply macOS preferences

# Helpers

## Git Submodules
### Add
```bash
git submodule add https://github.com/wfxr/forgit.git submodules/forgit
```
### Delete
```bash
export MODULE=submodules/repo_name && git submodule deinit -f $MODULE && rm -rf .git/modules/$MODULE && git rm -f $MODULE
```
