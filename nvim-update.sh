#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

## nvr
pip3 install --upgrade neovim-remote

## python provider
pip3 install --upgrade pynvim

## node provider
pnpm add -g neovim@latest

## tree-sitter
brew upgrade tree-sitter --fetch-HEAD

## nvim
bob update latest
bob update nightly

## nvim plugins
update_nvim_lua=$(
  cat <<'LUA'
-- :LazySync
local has_lazy, lazy = pcall(require, "lazy")
if has_lazy then
  lazy.sync({ wait = true })
end

-- :MasonUpdate
local has_mason_registry, mason_registry = pcall(require, "mason-registry")
if has_mason_registry then
  local mason_updated = vim.async.run(vim.async.await, mason_registry.update):wait()
  assert(mason_updated, "MasonUpdate Failed")
end

-- :MasonToolsUpdateSync
local has_mason_tools, mason_tools = pcall(require, "mason-tool-installer")
if has_mason_tools then
  mason_tools.check_install(true, true)
end

-- :TSUpdate
local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
if has_treesitter then
  local treesitter_updated = treesitter.update():wait()
  assert(treesitter_updated, "TSUpdate Failed")
end

vim.cmd.qall()
LUA
)

NVIM_APPNAME="nvim-dagadbm" command nvim --headless -c "lua $update_nvim_lua"
NVIM_APPNAME="nvim-lazyvim" command nvim --headless -c "lua $update_nvim_lua"
NVIM_APPNAME="nvim-astrovim" command nvim --headless -c "lua $update_nvim_lua"
