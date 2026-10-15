-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable smooth scrolling animation
vim.g.snacks_animate = false

-- Maintain undo history between sessions
vim.opt.undodir = vim.fn.expand('~/.cache/nvim-lazyvim/undos//')
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.undoreload = 100000
-- Backup everything to prevent code loss catastrophes
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.expand('~/.cache/nvim-lazyvim/backups//')
vim.opt.swapfile = false
