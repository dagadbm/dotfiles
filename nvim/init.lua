-- Plugins {{{
local packer_install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..packer_install_path)
  vim.cmd 'packadd packer.nvim'
end

local use =require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  --- Files and Folders Navigation
  use 'justinmk/vim-dirvish'

  -- [[ UI ]]
  -- icons
  use 'kyazdani42/nvim-web-devicons'
  -- Light as air status-bar
  use 'hoob3rt/lualine.nvim'
  -- TODO: Use galaxy line which is way better but takes more time to configure

  -- [[ Editting ]]
  -- Surround text with s motion
  use 'tpope/vim-surround'
  -- Allow the . command to work on plugin actions (for surround)
  use 'tpope/vim-repeat'
  -- Add commentary with gcc for line. g<b and g>b for block
  use 'tpope/vim-commentary'
  -- Automatically find correct file indentation while respecting editor config files
  use 'editorconfig/editorconfig-vim'
  use 'tpope/vim-sleuth'
  -- * and # to work on visual mode
  use 'bronson/vim-visual-star-search'
  -- Add additional text objects to vim
  -- indentation as an object (i)
  use 'michaeljsmith/vim-indent-object'
  use 'wellle/targets.vim'
  use 'wellle/line-targets.vim'
  -- Make vim current directory the project root
  use 'airblade/vim-rooter'
  -- Auto close tags
  use 'alvan/vim-closetag'

  -- [[ Extra vim behavior ]]
  use 'tpope/vim-eunuch'

  -- [[ LSP ]]
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'

  -- [[ Testing ]]
  use 'janko/vim-test'
  use 'tpope/vim-dispatch'

  -- [[ Undo history ]]
  use 'mbbill/undotree'

  -- [[ Session Management ]]
  use 'tpope/vim-obsession'
  use 'dhruvasagar/vim-prosession'

  -- [[ Syntax ]]
  -- Syntax pack
  use 'sheerun/vim-polyglot'
  -- tmux.conf support
  use 'tmux-plugins/vim-tmux'
  -- tree  sitter
  use { 'nvim-treesitter/nvim-treesitter', run = '<Cmd>TSUpdate<CR>' }

  -- [[ Code Navigation ]]
  -- Vim matchit plugin (makes % match with other tags)
  use 'andymass/vim-matchup'
  -- Highlight f/F/t/T when needed
  use 'unblevable/quick-scope'
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzy-native.nvim'},
      {'romgrk/fzy-lua-native',  run = 'make' } }
    }

  -- [[ Key Bindings ]]
  use 'tpope/vim-unimpaired'

  -- [[ Snippets ]]
  -- engine
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  -- snippets
  use 'honza/vim-snippets'
  use 'rafamadriz/friendly-snippets'

  -- [[ Completion ]]
  -- engine
  use 'hrsh7th/nvim-compe'
  -- sources
  use 'andersevenrud/compe-tmux'

  -- [[ External Integrations ]]
  -- Git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'
  use 'TimUntersberger/neogit'
  -- Tmux
  use 'tmux-plugins/vim-tmux-focus-events'
  use 'christoomey/vim-tmux-navigator'
  use 'roxma/vim-tmux-clipboard'
  -- Make vim color scheme integrate automatically with tmux
  use 'edkolev/tmuxline.vim'

  -- [[ Color Schemes ]]
  use 'joshdick/onedark.vim'
end)

-- Plugins }}}
-- Settings {{{
-- <Leader> key avoids default vim key collision
vim.g.mapleader = ' '

-- Open new split panes to right and bottom, which feels more natural than the default
vim.o.splitbelow = true
vim.o.splitright = true

-- Enable filetype plugins
vim.cmd 'filetype plugin indent on'

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
vim.o.listchars = [[tab:→\ ,nbsp:␣,extends:»,precedes:«,trail:•]]
vim.wo.listchars = [[tab:→\ ,nbsp:␣,extends:»,precedes:«,trail:•]]
vim.bo.tabstop = 4

-- reduce updatetime and time to next key
vim.o.updatetime = 100
vim.o.timeoutlen = 800

-- Better display for messages
vim.o.cmdheight = 2

-- don't give |ins-completion-menu| messages.
vim.o.shortmess = vim.o.shortmess..'c'

-- always show signcolumns
vim.wo.signcolumn = 'yes'

-- Enable syntax highlighting
vim.cmd 'syntax enable'
-- Setup 256 color support
vim.o.termguicolors = true
vim.cmd 'colorscheme onedark'

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
-- Keybindings {{{
local map = require('utils').map

-- [[ Terminal mappings ]]
-- Allow hitting <Esc> to switch to normal mode
map('t', '<Esc>', [[<C-\><C-n>]])
-- Ctrl+[hjkl] to navigate through windows in insert mode
map('t', '<C-h>', [[<C-\><C-n><C-w>h]])
map('t', '<C-j>', [[<C-\><C-n><C-w>j]])
map('t', '<C-k>', [[<C-\><C-n><C-w>k]])
map('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- [[ Editing mappings ]]
-- change star (c*) to to something similar to multiple cursors
-- Use . to repeat the motion
-- Does not pollute the jump list
map('n', 'c*', '*<C-o>cgn')
map('n', 'c#', '#<C-o>cgn')
-- Use J and K on visual mode to move the selection up or down
map('v', 'J', '<Cmd>m \'>+1<CR>gv=gv')
map('v', 'K', '<Cmd>m \'<-2<CR>gv=gv')
-- User leader s/S to save save all buffers
map('n', '<Leader>s', '<Cmd>w<CR>')
map('n', '<Leader>S', '<Cmd>wa<CR>')
-- Make Enter and Shift-Enter insert lines below and above
-- without entering insert mode
map('n', '<CR>', 'o<Esc>k')
map('n', '<S-Enter>', 'O<Esc>j')
-- jk to quit to normal mode
map('t', 'jk', [[<C-\><C-n>]])
map('i', 'jk', '<Esc>')
-- Traverse only display lines (like normal text editors)
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- [[ Git mappings ]]
-- Mnemonics for merging conflicts (Use :Gdiffsplit on conflicting file)
-- H is left side, L is right side (similar to vim hjkl motions)
-- left side is the target branch (where HEAD points to), the active branch you are merging into
-- right side is the merge branch passed onto the git merge command
map('n', '<Leader>gdh', 'd2o')
map('n', '<Leader>gdl', 'd3o')
-- Hunk navigation
map('n', '<Leader>gn', '<Plug>(GitGutterNextHunk)')
map('n', '<Leader>gp', '<Plug>(GitGutterPrevHunk)')
map('n', '<Leader>gu', '<Plug>(GitGutterUndoHunk)')
map('n', '<Leader>gi', '<Plug>(GitGutterPreviewHunk)')

-- [[ Fuzzy search mappings ]]
-- open telescope file browser
map('n', '<Leader>e', [[<Cmd>lua require('telescope.builtin').file_browser()<CR>]])
-- search current buffer
map('n', '<Leader>/', [[<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
-- Type <Leader>* to search everywhere for the selected word on normal and visual mode
map('n', '<Leader>*', [[<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>]])
-- file search
map('n', '<Leader>p', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]])
-- Type <Leader>P to search for files with the content of the word under cursor
map('n', '<Leader>P', [[<Cmd>lua require('telescope.builtin').find_files({ find_command = {'fd', vim.fn.expand('<cword>')} })<CR>]])
-- global search
map('n', '<Leader>f', [[<Cmd>lua require('telescope.builtin').grep_string({ search = '' })<CR>]])
-- Type <Leader>F to pre populate grep results with query (includes file extensions)
map('n', '<Leader>F', [[<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep for > ') })<CR>]])
-- vim related searches
map('n', '<Leader>.', [[<Cmd>lua require('telescope.builtin').commands()<CR>]])
map('n', '<Leader>:', [[<Cmd>lua require('telescope.builtin').command_history()<CR>]])
map('n', '<Leader>h', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]])
map('n', '<Leader>H', [[<Cmd>lua require('telescope.builtin').oldfiles()<CR>]])
map('n', '<Leader>m', [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]])
map('n', '<Leader>b', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]])
-- git related searches
map('n', '<Leader>gf', [[<Cmd>lua require('telescope.builtin').git_files()<CR>]])

-- [[ LSP mappings ]]
-- Navigation
map('n', '<Leader>lgd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<Leader>lgD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<Leader>lgt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n', '<Leader>lgi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<Leader>lgr', '<Cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<Leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<Leader>lK', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
-- Actions
map('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
map('v', '<Leader>la', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>')
map('n', '<Leader>lt', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
map('v', '<Leader>lt', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>')
-- Diagnostics
map('n', '<Leader>ldi', '<Cmd>lua vim.lsp.buf.show_line_diagnostics()<CR>')
map('n', '<Leader>ldp', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<Leader>ldn', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<Leader>ldq', '<Cmd>lua vim.lsp.buf.set_loclist()<CR>')
-- Telescope
map('n', '<Leader>Lf', [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]])
map('n', '<Leader>Lt', [[<Cmd>lua require('telescope.builtin').treesitter()<CR>]])
map('n', '<Leader>Ls', [[<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
map('n', '<Leader>LS', [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbol()<CR>]])
map('n', '<Leader>La', [[<Cmd>lua require('telescope.builtin').code_actions()<CR>]])
map('n', '<Leader>Ld', [[<Cmd>lua require('telescope.builtin').document_diagnostics()<CR>]])
map('n', '<Leader>LD', [[<Cmd>lua require('telescope.builtin').workspace_diagnostics()<CR>]])

-- [[ completion mappings ]]
-- https://github.com/hrsh7th/nvim-compe#how-to-use-tab-to-navigate-completion-menu
-- Allow tab to trigger auto-complete, refresh on backspace
-- Use <Tab> and <S-Tab> to navigate the completion list:
local t = require('utils').t
local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end
_G.next_completion = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn.call('vsnip#available', {1}) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.previous_completion = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    return t '<S-Tab>'
  end
end
map('i', '<Tab>', 'v:lua.next_completion()', { expr = true })
map('i', '<S-Tab>', 'v:lua.previous_completion()', { expr = true })
map('i', '<C-j>', 'v:lua.next_completion()', { expr = true })
map('i', '<C-k>', 'v:lua.previous_completion()', { expr = true })
-- invoke completion menu (tab also does this)
map('i', '<C-Space>', 'compe#complete()', { expr = true })
-- expand/select completion
map('i', '<CR>', [[compe#confirm('<CR>')]], { expr = true })
-- close
map('i', '<C-e>', [[compe#close('<C-e>')]], { expr = true })
map('i', '<Esc>', [[compe#close('<Esc>')]], { expr = true })
-- scroll
map('i', '<C-d>', [[compe#scroll({ 'delta': +4 })]], { expr = true })
map('i', '<C-u>', [[compe#scroll({ 'delta': -4 })]], { expr = true })
-- }}}
-- Custom Commands {{{
vim.cmd ':command! -nargs=0 Tabs2Spaces :set et|retab'
vim.cmd ':command! -nargs=0 Spaces2Tabs :set noet|retab!'
-- }}}
-- Auto Commands {{{
-- Disabled automatic new line comment (annoying specially when editing vimrc)
vim.api.nvim_exec([[
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]], false)
-- Automatically check and refresh when a file is changed from the outside
vim.api.nvim_exec([[
  augroup auto_refresh
  autocmd! FocusGained,BufEnter *:checktime
  augroup END
]], false)

vim.api.nvim_exec([[
  augroup lsp_document_highlight
  autocmd! * <buffer>
  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  augroup END
]], false)
-- }}}
-- Plugin Configurations {{{
-- LSP
-- server list to be used
local lsp_servers = {
  -- front-end
  'html',
  'css',
  'typescript',
  'vue',
  'efm',
  'graphql',
  -- back-end
  'python',
  'go',
  'rust',
  -- markup
  'yaml',
  'json',
  -- vim
  'vim',
  'lua',
}
local installed_servers = require'lspinstall'.installed_servers()

local function lsp_sync_servers(bootstrap)
  if bootstrap then
    for _, server in pairs(lsp_servers) do
      require'lspinstall'.install_server(server)
    end
  else
    for _, server in pairs(lsp_servers) do
      if vim.tbl_contains(installed_servers, server) then
        require'lspinstall'.install_server(server)
      else
        require'lspinstall'.uninstall_server(server)
      end
    end
  end
end
vim.cmd 'command! -nargs=0 LspBootstrap call v:lua.lsp_sync_servers(true)'
vim.cmd 'command! -nargs=0 LspSync call v:lua.lsp_sync_servers(false)'


function _G.lsp_update_servers()
  local lspinstall = require'lspinstall'
  for _, server in ipairs(lspinstall.installed_servers()) do
    lspinstall.install_server(server)
  end
end

local nvim_lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}
local function lsp_setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  -- this is required to use nvim-compe together with LSP snippets
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  for _, server in pairs(servers) do
    -- nvim settings for lua
    if server == 'lua' then
      require'lspconfig'[server].setup({
          capabilities = capabilities,
          settings = nvim_lua_settings,
        })
    else
      require'lspconfig'[server].setup({
          capabilities = capabilities
        })
    end
  end
end
lsp_setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  lsp_setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


-- netrw
vim.g.netrw_liststyle = 3

-- quick-scope
-- Trigger a highlight in the appropriate direction when pressing these keys:
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }

--  Bufferline integration with airline
vim.g.bufferline_echo=0

-- BufKill
vim.g.BufKillCreateMappings = 0

-- Session Management
vim.g.prosession_dir = '~/.cache/vim/sessions'
vim.g.prosession_on_startup = 1
vim.g.prosession_per_branch = 1

-- Terminal
vim.g.disable_key_mappings = 0

-- Find and replace workflow
vim.g.rg_command = 'rg --vimgrep -S'

-- EditorConfig
vim.g.EditorConfig_exclude_patterns = 'fugitive://.*'

-- vim-test
vim.g['test#strategy'] = 'dispatch'

-- vim-go
vim.g.go_def_mapping_enabled = 0

-- vim-rooter
-- Manually run :Rooter to find project dir
vim.g.rooter_manual_only = 1

-- Telescope
local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = actions.close,
        -- replace current quick fix list with selected item
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        -- add to existing quick fix list with selected item
        ['<C-a>'] = actions.smart_add_to_qflist + actions.open_qflist,
        -- next prev mappings (like fzf)
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
    prompt_position = 'top',
    sorting_strategy = 'ascending'
  },
})
-- use native lua implementation of fzy (fzf alternative)
require('telescope').load_extension('fzy_native')

-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
})

-- Neogit
require('neogit').setup({})

-- nvim-compe
require('compe').setup({
  source = {
    path = true,
    buffer = true,
    tags =  true,
    spell =  true,
    calc = true,
    omni = false,
    emoji = false,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    tmux = true,
  };
})

-- GitGutter
vim.g.gitgutter_map_keys = 0

-- LuaLine
require('lualine').setup({
  options = {
    theme = 'onedark',
    icons_enabled = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = { {'diagnostics', sources = { 'nvim_lsp' }} },
    lualine_z = {'location', 'progress'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'fugitive' }
})
-- }}}
