-- Enable local per project config files (.nvim.lua in root of project)
vim.opt.exrc = true
vim.opt.secure = true

-- <Leader> key avoids default vim key collision
vim.g.mapleader = ' '

-- Open new split panes to right and bottom, which feels more natural than the default
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable filetype plugins
vim.cmd 'filetype plugin indent on'
-- Enable syntax highlighting
vim.cmd 'syntax enable'

-- set foldmethod to markers
vim.opt.foldmethod = 'marker'
-- using nvim_treesitter
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldmethod = "expr"
-- Allows to hide buffers instead of closing them when files are not saved
vim.opt.hidden = true

-- Show tabs and space
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.listchars = { tab = '→ ', nbsp = '␣', extends = '»', precedes = '«', trail = '•' }

-- updatetime for cursor events and time to wait until next key press
vim.opt.updatetime = 2000
vim.opt.timeoutlen = 500

-- Better display for messages
vim.opt.cmdheight = 1

-- always show signcolumns
vim.opt.signcolumn = 'yes'
-- Setup 256 color support
vim.opt.termguicolors = true

-- set utf8 as standard encoding
vim.opt.encoding = 'utf8'

-- Indent wrapped lines
vim.opt.breakindent = true

-- Set absolute and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Make ripgrep be the default vimgrep
vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- buffer title
vim.opt.title = true
vim.opt.titlestring = '%f'

-- Add vertical bar when reaching 80 chars
vim.opt.colorcolumn = '80'

-- [[ Backups ]]
-- Maintain undo history between sessions
vim.opt.undodir = vim.fn.expand('~/.cache/nvim/undos/')
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.undoreload = 100000
-- Backup everything to prevent code loss catastrophes
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.expand('~/.cache/nvim/backups/')
-- Swap files
vim.opt.swapfile = true
vim.opt.directory = vim.fn.expand('~/.cache/nvim/swaps/')

-- [[ Sessions ]]
-- recommended options from auto-session
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Ignore case when searching
vim.opt.ignorecase = true

-- When searching try to be smart about cases
vim.opt.smartcase = true

-- Highlight search results when /?
vim.opt.hlsearch = false

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true

-- Always show the status line
vim.opt.laststatus = 2

-- Dont show mode (handled by status line)
vim.opt.showmode = false
