-- Keybindings {{{
local map = require('dotfiles.utils').map

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
map('i', 'jk', '<Esc>')
-- Traverse only display lines (like normal text editors)
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- [[ Git mappings ]]
map('n', '<Leader>gg', '<Cmd>LazyGit<CR>')
-- Mnemonics for merging conflicts (Use :Gdiffsplit on conflicting file)
-- H is left side, L is right side (similar to vim hjkl motions)
-- left side is the target branch (where HEAD points to), the active branch you are merging into
-- right side is the merge branch passed onto the git merge command
map('n', '<Leader>gdh', 'd2o')
map('n', '<Leader>gdl', 'd3o')
-- Hunk navigation
map('n', '<Leader>gn', [[<Cmd>lua require('gitsigns').next_hunk()<CR>]])
map('n', '<Leader>gp', [[<Cmd>lua require('gitsigns').prev_hunk()<CR>]])
map('n', '<Leader>gu', [[<Cmd>lua require('gitsigns').reset_hunk()<CR>]])
map('n', '<Leader>gi', [[<Cmd>lua require('gitsigns').preview_hunk()<CR>]])
map('n', '<Leader>gb', [[<Cmd>lua require('gitsigns').blame_line()<CR>]])

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
local t = require('dotfiles.utils').t
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
