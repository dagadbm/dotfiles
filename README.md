# dotfiles

Welcome to my humble dotfiles repo.

## Install

First run install script `./scripts/bootstrap.sh` to download and setup
everything.

## Commands

Commands live in `scripts/` and run as mise tasks from `mise.toml`:

```bash
mise tasks                                # list tasks
mise run                                  # pick a task interactively
mise run dotbot                           # relink after changing dotbot.conf.yaml
mise run update                           # update everything
mise run nvim:update                      # update Neovim, LSP, plugins
mise run herdr:update                     # update herdr
mise run hk:update                        # update hk, install git hooks
mise run claude:update                    # update agent tooling
mise run submodules:update                # update submodules
mise run brew:update                      # update Homebrew
mise run mise:update                      # update mise
mise run prune                            # prune everything
mise run brew:prune                       # prune Homebrew to match Brewfile
mise run mise:prune                       # prune mise
mise run claude:prune                     # prune claude to match scripts/claude-update.sh
mise run macos:defaults                   # apply macOS preferences
mise run lint                             # format and lint all configs and scripts
```

## Helpers

### Git Submodules

#### Add

```bash
git submodule add https://github.com/wfxr/forgit.git submodules/forgit
```

#### Delete

```bash
export MODULE=submodules/repo_name && \
  git submodule deinit -f $MODULE && \
  rm -rf .git/modules/$MODULE && \
  git rm -f $MODULE
```

### Tailscale

#### Setup name

```bash
sudo scutil --set ComputerName dagadbm-personal-mac
sudo scutil --set HostName dagadbm-personal-mac
sudo scutil --set LocalHostName dagadbm-personal-mac
```
