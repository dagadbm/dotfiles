# dotfiles

Welcome to my humble dotfiles repo.

# Install

First run install script `./scripts/bootstrap.sh` to download and setup everything

# Updates

Scripts live in `scripts/` and run as mise tasks from `mise.toml` (`mise tasks` lists them):

Run `mise run` to pick a task interactively
Run `mise run dotbot` to relink after changing `dotbot.conf.yaml`
Run `mise run update` to update everything
Run `mise run update:nvim` to update Neovim, LSP, plugins
Run `mise run update:herdr` to update herdr
Run `mise run update:submodules` to update submodules
Run `mise run update:brew` to update Homebrew
Run `mise run update:mise` to update mise
Run `mise run update:claude` to update agent tooling
Run `mise run prune` to prune everything (brew + mise + claude)
Run `mise run prune:brew` to prune Homebrew to match Brewfile
Run `mise run prune:mise` to prune mise
Run `mise run prune:claude` to prune claude to match scripts/claude-update.sh
Run `mise run macos:defaults` to apply macOS preferences

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

### Tailscale

```bash
sudo scutil --set ComputerName dagadbm-personal-mac
sudo scutil --set HostName dagadbm-personal-mac
sudo scutil --set LocalHostName dagadbm-personal-mac
```
