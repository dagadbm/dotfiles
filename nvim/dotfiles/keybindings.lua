-- Keybindings {{{
local map = vim.keymap.set

-- [[ Terminal mappings ]]
-- Allow hitting <Esc> [or to switch to normal mode
map('t', '<Esc>', [[<C-\><C-n>]])
map('t', '<C-[>', [[<C-\><C-n>]])
-- Ctrl+[hjkl] to navigate through windows in insert mode
map('t', '<C-h>', [[<C-\><C-n><C-w>h]])
map('t', '<C-j>', [[<C-\><C-n><C-w>j]])
map('t', '<C-k>', [[<C-\><C-n><C-w>k]])
map('t', '<C-l>', [[<C-\><C-n><C-w>l]])
-- Terminal usage
map({ 'n', 't' }, [[<C-\><C-o>]], [[<Cmd>execute v:count . "ToggleTerm direction=float"<CR>]])
map({ 'n', 't' }, [[<C-\><C-v>]], [[<Cmd>execute v:count . "ToggleTerm direction=vertical size=70"<CR>]])
map({ 'n', 't' }, [[<C-\><C-s>]], [[<Cmd>execute v:count . "ToggleTerm direction=horizontal size=20"<CR>]])
map({ 'n', 't' }, [[<C-\><C-\>]], [[<Cmd>ToggleTermToggleAll<CR>]])
map('v', '<Leader>tl', [[<Cmd>ToggleTermSendVisualSelection<CR>]])
-- floatterm support if needed
-- map({ 'n', 't' }, '<Leader>to', [[<Cmd>FloattermNew<CR>]])
-- map({ 'n', 't' }, '<Leader>tt', [[<Cmd>FloatermToggle<CR>]])
-- map({ 'n', 't' }, '<Leader>tn', [[<Cmd>FloatermNext<CR>]])
-- map({ 'n', 't' }, '<Leader>tp', [[<Cmd>FloatermPrev<CR>]])
-- map({ 'n', 't' }, '<Leader>tk', [[<Cmd>FloatermKill<CR>]])
-- map({ 'n', 't' }, '<Leader>tK', [[<Cmd>FloatermKill!<CR>]])

local lazygit = require('toggleterm.terminal').Terminal:new({ cmd = "lazygit", direction = 'float', hidden = true })
function _G.lazygit_toggle()
  lazygit:toggle()
end
map({ 'n', 't' }, '<Leader>gg', '<cmd>lua lazygit_toggle()<CR>')

-- [[ Testing mappings ]]
map('n', '<Leader>Tt', '<Cmd>TestNearest<CR>')
map('n', '<Leader>Tf', '<Cmd>TestFile<CR>')
map('n', '<Leader>TF', '<Cmd>TestSuite<CR>')
map('n', '<Leader>Tl', '<Cmd>TestLast<CR>')
map('n', '<Leader>Tg', '<Cmd>TestVisit<CR>')

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
-- search current buffer
map('n', '<Leader>/', [[<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
-- Type <Leader>* to search everywhere for the selected word on normal and visual mode
map('n', '<Leader>*', [[<Cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>]])
-- file search
map('n', '<Leader>p', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]])
-- Type <Leader>P to search for files with the content of the word under cursor
map('n', '<Leader>P',
  [[<Cmd>lua require('telescope.builtin').find_files({ find_command = {'fd', vim.fn.expand('<cword>')} })<CR>]])
-- global search
map('n', '<Leader>f', [[<Cmd>lua require('telescope.builtin').grep_string({ search = '' })<CR>]])
-- Type <Leader>F to pass args to rp
map('n', '<Leader>F', [[<Cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])

-- vim related searches
map('n', '<Leader>c', [[<Cmd>lua require('telescope.builtin').commands()<CR>]])
map('n', '<Leader>C', [[<Cmd>lua require('telescope.builtin').command_history()<CR>]])
map('n', '<Leader>h', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]])
map('n', '<Leader>o', [[<Cmd>lua require('telescope.builtin').oldfiles()<CR>]])
map('n', '<Leader>m', [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]])
map('n', '<Leader>b', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]])
-- git related searches
map('n', '<Leader>gf', [[<Cmd>lua require('telescope.builtin').git_files()<CR>]])
-- lsp related searches
map('n', '<Leader>lf', [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]])
map('n', '<Leader>ls', [[<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
map('n', '<Leader>lS', [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbol()<CR>]])
map('n', '<Leader>ld', [[<Cmd>lua require('telescope.builtin').diagnostics({ bufnr = 0 })<CR>]])
map('n', '<Leader>lD', [[<Cmd>lua require('telescope.builtin').diagnostics()<CR>]])

-- [[ LSP Buffer mappings ]]
local M = {}

function M.lsp_mappings(bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- Navigation
    map('n', '<Leader>lgd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map('n', '<Leader>lgD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    map('n', '<Leader>lgt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map('n', '<Leader>lgi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map('n', '<Leader>lgc', '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    map('n', '<Leader>lgC', '<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    map('n', '<Leader>lgr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    map('n', '<Leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map('n', '<Leader>lK', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- Actions
    map('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    map('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map('v', '<Leader>la', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    map('n', '<Leader>lt', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
    map('v', '<Leader>lt', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    -- Diagnostics
    map('n', '<Leader>ldi', '<Cmd>lua vim.lsp.buf.show_line_diagnostics()<CR>', opts)
    map('n', '<Leader>ldp', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    map('n', '<Leader>ldn', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    map('n', '<Leader>ldq', '<Cmd>lua vim.lsp.buf.set_loclist()<CR>', opts)
    -- Virtual Lines
    map('n', '<Leader>lvt', '<Cmd>lua vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })<CR>', opts)
    map('n', '<Leader>lvl', '<Cmd>lua vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })<CR>', opts)
end

return M
-- }}}
