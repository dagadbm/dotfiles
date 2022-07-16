-- Settings {{{
-- <Leader> key avoids default vim key collision
vim.g.mapleader = ' '

-- Open new split panes to right and bottom, which feels more natural than the default
vim.o.splitbelow = true
vim.o.splitright = true

-- Enable filetype plugins
vim.cmd 'filetype plugin indent on'
-- Enable syntax highlighting
vim.cmd 'syntax enable'

-- set foldmethod to markers
vim.wo.foldmethod = 'marker'
-- Allows to hide buffers instead of closing them when files are not saved
vim.o.hidden = true

-- Turn swap files off
vim.o.swapfile = false

-- Mandatory for nvim-compe to work correctly
vim.o.completeopt = 'menuone,noselect'

-- Show tabs and space
vim.wo.list = true
vim.bo.tabstop = 4
vim.cmd [[set listchars=tab:→\ ,nbsp:␣,extends:»,precedes:«,trail:•]]

-- updatetime for cursor events and time to wait until next key press
vim.o.updatetime = 2000
vim.o.timeoutlen = 1000

-- Better display for messages
vim.o.cmdheight = 2

-- always show signcolumns
vim.wo.signcolumn = 'yes'
-- Setup 256 color support
vim.o.termguicolors = true

-- set utf8 as standard encoding
vim.o.encoding = 'utf8'

-- Indent wrapped lines
vim.wo.breakindent = true

-- Set absolute and relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Make ripgrep be the default vimgrep
vim.bo.grepprg='rg --vimgrep --no-heading --smart-case'
vim.o.grepprg='rg --vimgrep --no-heading --smart-case'

-- buffer title
vim.o.title = true
vim.o.titlestring = '%f'

-- Add vertical bar when reaching 80 chars
vim.wo.colorcolumn = '80'

-- Maintain undo history between sessions
vim.bo.undofile = true
vim.o.undodir = vim.fn.expand('~/.cache/vim/undos')

-- Ignore case when searching
vim.o.ignorecase = true

-- When searching try to be smart about cases
vim.o.smartcase = true

-- Highlight search results when /?
vim.o.hlsearch = false

-- Show matching brackets when text indicator is over them
vim.o.showmatch = true

-- Always show the status line
vim.o.laststatus = 2

-- Dont show mode (handled by status line)
vim.o.showmode = false
-- }}}
-- Custom Commands {{{
vim.cmd ':command! -nargs=0 Tabs2Spaces :set et|retab'
vim.cmd ':command! -nargs=0 Spaces2Tabs :set noet|retab!'
-- }}}
-- Auto Commands {{{
-- run Packer when changing config
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'
-- Automatically check and refresh when a file is changed from the outside
vim.cmd 'autocmd FocusGained,BufEnter * :checktime'
-- Lsp related auto commands
vim.api.nvim_exec([[
  augroup lsp_document_highlight
  autocmd! * <buffer>
  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  augroup END
]], false)
-- }}}
