local map = vim.keymap.set
local M = {}

-- [[ Terminal mappings ]]
-- Allow hitting Ctrl-\<Esc> or [ to switch to normal mode
map('t', [[<C-\><Esc>]], [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
map('t', [[<C-\><C-[>]], [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
-- Ctrl+[hjkl] to navigate through windows in insert mode
map('t', [[<C-h>]], [[<C-\><C-n><C-w>h]], { desc = 'Move to left window' })
map('t', [[<C-j>]], [[<C-\><C-n><C-w>j]], { desc = 'Move to bottom window' })
map('t', [[<C-k>]], [[<C-\><C-n><C-w>k]], { desc = 'Move to top window' })
map('t', [[<C-l>]], [[<C-\><C-n><C-w>l]], { desc = 'Move to right window' })
-- Terminal usage
map({ 'n', 't' }, [[<C-\><C-o>]], [[<Cmd>execute v:count . 'ToggleTerm direction=float'<CR>]], { desc = 'Toggle floating terminal' })
map({ 'n', 't' }, [[<C-\><C-v>]], [[<Cmd>execute v:count . 'ToggleTerm direction=vertical size=70'<CR>]], { desc = 'Toggle vertical terminal' })
map({ 'n', 't' }, [[<C-\><C-s>]], [[<Cmd>execute v:count . 'ToggleTerm direction=horizontal size=20'<CR>]], { desc = 'Toggle horizontal terminal' })
map({ 'n', 't' }, [[<C-\><C-\>]], [[<Cmd>ToggleTermToggleAll<CR>]], { desc = 'Toggle all terminals' })
map('v', [[<Leader>tl]], [[<Cmd>ToggleTermSendVisualSelection<CR>]], { desc = 'Send visual selection to terminal' })
-- floatterm support if needed
-- map({ 'n', 't' }, [[<Leader>to]], [[<Cmd>FloattermNew<CR>]], { desc = 'New float terminal' })
-- map({ 'n', 't' }, [[<Leader>tt]], [[<Cmd>FloatermToggle<CR>]], { desc = 'Toggle float terminal' })
-- map({ 'n', 't' }, [[<Leader>tn]], [[<Cmd>FloatermNext<CR>]], { desc = 'Next float terminal' })
-- map({ 'n', 't' }, [[<Leader>tp]], [[<Cmd>FloatermPrev<CR>]], { desc = 'Previous float terminal' })
-- map({ 'n', 't' }, [[<Leader>tk]], [[<Cmd>FloatermKill<CR>]], { desc = 'Kill float terminal' })
-- map({ 'n', 't' }, [[<Leader>tK]], [[<Cmd>FloatermKill!<CR>]], { desc = 'Force kill float terminal' })
--
-- [[ File tree mappings ]]
-- use - for file tree
-- map('n', [[-]], [[<CMD>Oil<CR>]], { desc = 'Open Oil file browser' })
map('n', [[<Leader>e]], [[<Cmd>NvimTreeToggle<CR>]], { desc = 'Toggle file tree' })

local lazygit = nil
function _G.lazygit_toggle()
    if not lazygit then
        lazygit = require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })
    end
    lazygit:toggle()
end
map({ 'n', 't' }, [[<Leader>gg]], lazygit_toggle, { desc = 'Toggle LazyGit' })

-- [[ Testing mappings ]]
map('n', [[<Leader>Tt]], [[<Cmd>TestNearest<CR>]], { desc = 'Test nearest' })
map('n', [[<Leader>Tf]], [[<Cmd>TestFile<CR>]], { desc = 'Test file' })
map('n', [[<Leader>TF]], [[<Cmd>TestSuite<CR>]], { desc = 'Test suite' })
map('n', [[<Leader>Tl]], [[<Cmd>TestLast<CR>]], { desc = 'Test last' })
map('n', [[<Leader>Tg]], [[<Cmd>TestVisit<CR>]], { desc = 'Test visit' })

-- [[ Editing mappings ]]
-- change star (c*) to to something similar to multiple cursors
-- Use . to repeat the motion
-- Does not pollute the jump list
map('n', [[c*]], [[*<C-o>cgn]], { desc = 'Change next match' })
map('n', [[c#]], [[#<C-o>cgn]], { desc = 'Change previous match' })
-- When using J on normal mode, make the cursor move to the beginning
map('n', [[J]], [[mzJ`z]], { desc = 'Join lines keeping cursor position' })
-- Use J and K on visual mode to move the selection up or down
map('v', [[J]], [[:m '>+1<CR>gv=gv]], { desc = 'Move selection down' })
map('v', [[K]], [[:m '<-2<CR>gv=gv]], { desc = 'Move selection up' })
-- User leader s/S to save save all buffers
map('n', [[<Leader>s]], [[<Cmd>w<CR>]], { desc = 'Save buffer' })
map('n', [[<Leader>S]], [[<Cmd>wa<CR>]], { desc = 'Save all buffers' })
-- make Leader y/Y use system clipboard for easier yanking into clipbord
map('n', [[<leader>y]], [["+y]], { desc = 'Yank to clipboard' })
map('v', [[<leader>y]], [["+y]], { desc = 'Yank to clipboard' })
map('n', [[<leader>Y]], [["+Y]], { desc = 'Yank line to clipboard' })
-- User leader u to open UndoTree
map('n', [[<Leader>u]], [[<Cmd>UndotreeToggle<CR>]], { desc = 'Toggle undo tree' })
-- Make Enter and Shift-Enter insert lines below and above
-- without entering insert mode
map('n', [[<CR>]], [[o<Esc>k]], { desc = 'Insert line below' })
map('n', [[<S-Enter>]], [[O<Esc>j]], { desc = 'Insert line above' })
-- jk to quit to normal mode
map('i', [[jk]], [[<Esc>]], { desc = 'Exit insert mode' })
-- Traverse only display lines (like normal text editors)
map('n', [[j]], [[gj]], { desc = 'Move down (display line)' })
map('n', [[k]], [[gk]], { desc = 'Move up (display line)' })
-- make navigation related actions to stay in the middle
-- for some weird reason this stopped working properly
map('n', [[<C-d>]], [[<C-d>M]], { desc = 'Scroll down half page' })
map('n', [[<C-u>]], [[<C-u>M]], { desc = 'Scroll up half page' })
map('n', [[n]], [[nzzzv]], { desc = 'Next search result' })
map('n', [[N]], [[Nzzzv]], { desc = 'Previous search result' })

-- [[ Git mappings ]]
-- Mnemonics for merging conflicts (Use :Gdiffsplit on conflicting file)
-- H is left side, L is right side (similar to vim hjkl motions)
-- left side is the target branch (where HEAD points to), the active branch you are merging into
-- right side is the merge branch passed onto the git merge command
map('n', [[<Leader>gdh]], [[d2o]], { desc = 'Take left side (HEAD) in conflict' })
map('n', [[<Leader>gdl]], [[d3o]], { desc = 'Take right side (merge) in conflict' })
-- Hunk navigation
map('n', [[<Leader>gn]], [[<Cmd>lua require('gitsigns').next_hunk()<CR>]], { desc = 'Next hunk' })
map('n', [[<Leader>gp]], [[<Cmd>lua require('gitsigns').prev_hunk()<CR>]], { desc = 'Previous hunk' })
map('n', ']g', [[<Cmd>lua require('gitsigns').next_hunk()<CR>]], { desc = 'Next hunk' })
map('n', '[g', [[<Cmd>lua require('gitsigns').prev_hunk()<CR>]], { desc = 'Previous hunk' })
map('n', [[<Leader>gw]], [[<Cmd>lua require('gitsigns').stage_hunk()<CR>]], { desc = 'Stage hunk' })
map('n', [[<Leader>gu]], [[<Cmd>lua require('gitsigns').reset_hunk()<CR>]], { desc = 'Reset hunk' })
map('n', [[<Leader>gi]], [[<Cmd>lua require('gitsigns').preview_hunk()<CR>]], { desc = 'Preview hunk' })
map('n', [[<Leader>gb]], [[<Cmd>lua require('gitsigns').blame_line()<CR>]], { desc = 'Blame line' })

-- [[ Fuzzy search mappings ]]
-- search current buffer
map('n', [[<Leader>/]], function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = 'Search current buffer' })
-- Type <Leader>* to search everywhere for the selected word on normal and visual mode
map('n', [[<Leader>*]], function() require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>'), cwd = cwd }) end, { desc = 'Search word under cursor' })
-- file search
map('n', [[<Leader>p]], function() require('telescope.builtin').find_files({ cwd = cwd }) end, { desc = 'Find files' })
-- Type <Leader>P to search for files with the content of the word under cursor
map('n', [[<Leader>P]], function() require('telescope.builtin').find_files({ find_command = {'fd', vim.fn.expand('<cword>')} }) end, { desc = 'Find files with word under cursor' })
-- global search
map('n', [[<Leader>f]], function() require('telescope.builtin').grep_string({ search = vim.fn.input('Search For > '), cwd = cwd }) end, { desc = 'Search for text' })
-- Type <Leader>F to pass args to rp
map('n', [[<Leader>F]], function() require('telescope.builtin').live_grep({ cwd = cwd }) end, { desc = 'Live grep' })

-- vim related searches
map('n', [[<Leader>:]], function() require('telescope.builtin').commands() end, { desc = 'Search commands' })
map('n', [[<Leader>;]], function() require('telescope.builtin').command_history() end, { desc = 'Command history' })
map('n', [[<Leader>h]], function() require('telescope.builtin').help_tags() end, { desc = 'Search help tags' })
map('n', [[<Leader>o]], function() require('telescope.builtin').oldfiles() end, { desc = 'Old files' })
map('n', [[<Leader>m]], function() require('telescope.builtin').keymaps() end, { desc = 'Search keymaps' })
map('n', [[<Leader>b]], function() require('telescope.builtin').buffers() end, { desc = 'Search buffers' })
-- git related searches
map('n', [[<Leader>gf]], function() require('telescope.builtin').git_status() end, { desc = 'Git status' })
-- lsp related searches
map('n', [[<Leader>lf]], function() require('telescope.builtin').lsp_references() end, { desc = 'LSP references' })
map('n', [[<Leader>ls]], function() require('telescope.builtin').lsp_document_symbols() end, { desc = 'LSP document symbols' })
map('n', [[<Leader>lS]], function() require('telescope.builtin').lsp_workspace_symbol() end, { desc = 'LSP workspace symbols' })
map('n', [[<Leader>ld]], function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, { desc = 'Buffer diagnostics' })
map('n', [[<Leader>lD]], function() require('telescope.builtin').diagnostics() end, { desc = 'Workspace diagnostics' })
-- dap related searches
-- map('n', [[<Leader>dd]], function() require('telescope').extensions.dap.commands() end, { desc = 'DAP commands' })
-- map('n', [[<Leader>dc]], function() require('telescope').extensions.dap.configurations() end, { desc = 'DAP configurations' })
-- map('n', [[<Leader>db]], function() require('telescope').extensions.dap.list_breakpoints() end, { desc = 'DAP list breakpoints' })
-- map('n', [[<Leader>dv]], function() require('telescope').extensions.dap.variables() end, { desc = 'DAP variables' })
-- map('n', [[<Leader>df]], function() require('telescope').extensions.dap.frames() end, { desc = 'DAP frames' })

-- [[ DAP mappings ]]
map('n', [[<Leader>dd]], function() require('dapui').toggle() end, { desc = 'Toggle DAP UI' })
map('n', [[<Leader>dsc]], function() require('dap').step_over() end, { desc = 'Step over' })
map('n', [[<Leader>dsi]], function() require('dap').step_into() end, { desc = 'Step into' })
map('n', [[<Leader>dso]], function() require('dap').step_out() end, { desc = 'Step out' })
map('n', [[<Leader>dS]], function() require('dap').continue() end, { desc = 'Continue' })

map('n', [[<Leader>dh]], function() require('dap.ui.widgets').hover() end, { desc = 'DAP hover' })
map('v', [[<Leader>dH]], function() require('dap.ui.widgets').visual_hover() end, { desc = 'DAP visual hover' })

map('n', [[<Leader>dr]], function() require('dap').repl.toggle() end, { desc = 'Toggle DAP REPL' })

map('n', [[<Leader>dbb]], function() require('dap').toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
map('n', [[<Leader>dbc]], function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition; ')) end, { desc = 'Conditional breakpoint' })
map('n', [[<Leader>dbl]], function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = 'Log point breakpoint' })
map('n', [[<Leader>dbK]], function() require('dap').clear_breakpoints() end, { desc = 'Clear all breakpoints' })

-- [[ AI mappings ]]
-- codecompanion.nvim chat and inline commands
map('n', [[<Leader>ic]], [[<Cmd>CodeCompanionChat Toggle<CR>]], { desc = 'Toggle AI chat' })
map('n', [[<Leader>iC]], [[<Cmd>CodeCompanionChat Add<CR>]], { desc = 'Add to AI chat' })

-- Inline AI assistant with prompt
map('n', [[<Leader>ia]], [[<Cmd>CodeCompanion<CR>]], { desc = 'AI inline assistant' })
map('v', [[<Leader>ia]], [[:CodeCompanion<CR>]], { desc = 'AI inline assistant (visual)' })

-- Quick actions (visual mode)
map('v', [[<Leader>ie]], [[:CodeCompanionChat explain<CR>]], { desc = 'Explain code' })
map('v', [[<Leader>if]], [[:CodeCompanionChat fix<CR>]], { desc = 'Fix code' })
map('v', [[<Leader>it]], [[:CodeCompanionChat tests<CR>]], { desc = 'Generate tests' })
map('v', [[<Leader>io]], [[:CodeCompanionChat optimize<CR>]], { desc = 'Optimize code' })
map('v', [[<Leader>id]], [[:CodeCompanionChat docs<CR>]], { desc = 'Add documentation' })

-- Quick actions (normal mode - will use current buffer)
map('n', [[<Leader>ie]], [[<Cmd>CodeCompanionChat explain<CR>]], { desc = 'Explain code' })
map('n', [[<Leader>if]], [[<Cmd>CodeCompanionChat fix<CR>]], { desc = 'Fix diagnostics' })
map('n', [[<Leader>it]], [[<Cmd>CodeCompanionChat tests<CR>]], { desc = 'Generate tests' })

-- Toggle actions menu
map({ 'n', 'v' }, [[<Leader>im]], [[<Cmd>CodeCompanionActions<CR>]], { desc = 'AI actions menu' })

-- [[ LSP Buffer mappings ]]
function M.lsp_mappings(bufnr)
    local opts = function(tbl)
        return vim.tbl_extend('force', { noremap=true, silent=true, buffer=bufnr }, tbl)
    end

    -- Navigation
    map('n', [[<Leader>lgd]], vim.lsp.buf.definition, opts { desc = 'Go to definition' })
    map('n', [[<Leader>lgD]], vim.lsp.buf.declaration, opts { desc = 'Go to declaration' })
    map('n', [[<Leader>lgt]], vim.lsp.buf.type_definition, opts { desc = 'Go to type definition' })
    map('n', [[<Leader>lgi]], vim.lsp.buf.implementation, opts { desc = 'Go to implementation' })
    map('n', [[<Leader>lgc]], vim.lsp.buf.incoming_calls, opts { desc = 'Incoming calls' })
    map('n', [[<Leader>lgC]], vim.lsp.buf.outgoing_calls, opts { desc = 'Outgoing calls' })
    map('n', [[<Leader>lgr]], vim.lsp.buf.references, opts { desc = 'Go to references' })
    map('n', [[<Leader>lk]], vim.lsp.buf.hover, opts { desc = 'Hover documentation' })
    map('n', [[<Leader>lK]], vim.lsp.buf.signature_help, opts { desc = 'Signature help' })
    -- Actions
    map('n', [[<Leader>lr]], vim.lsp.buf.rename, opts { desc = 'Rename symbol' })
    map('n', [[<Leader>la]], vim.lsp.buf.code_action, opts { desc = 'Code action' })
    map('n', [[<Leader>lt]], function() require('conform').format({ lsp_format = 'fallback' }) end, opts { desc = 'Format buffer' })
    -- Diagnostics
    map('n', [[<Leader>ldi]], vim.diagnostic.open_float, opts { desc = 'Show diagnostic' })
    map('n', [[<Leader>ldp]], vim.diagnostic.goto_prev, opts { desc = 'Previous diagnostic' })
    map('n', [[<Leader>ldn]], vim.diagnostic.goto_next, opts { desc = 'Next diagnostic' })
    map('n', [[<Leader>ldl]], vim.diagnostic.setloclist, opts { desc = 'Diagnostics to loclist' })
    map('n', [[<Leader>ldq]], vim.diagnostic.setqflist, opts { desc = 'Diagnostics to quickfix' })
end

return M
