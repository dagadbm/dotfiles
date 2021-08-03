-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/david.maia/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/david.maia/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/david.maia/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/david.maia/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/david.maia/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["compe-tmux"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/compe-tmux"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["line-targets.vim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/line-targets.vim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim"
  },
  ["lsp-trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/lsp-trouble.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n∏\4\0\0\a\0\28\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0034\4\3\0005\5\v\0>\5\1\4=\4\f\0035\4\r\0=\4\14\0034\4\3\0005\5\15\0005\6\16\0=\6\17\5>\5\1\4=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0004\4\0\0=\4\b\0034\4\0\0=\4\n\0034\4\3\0005\5\23\0>\5\1\4=\4\f\0035\4\24\0=\4\14\0034\4\0\0=\4\18\0034\4\0\0=\4\20\3=\3\25\0025\3\26\0=\3\27\2B\0\2\1K\0\1\0\15extensions\1\2\0\0\rfugitive\22inactive_sections\1\2\0\0\rlocation\1\2\2\0\rfilename\14full_path\2\fshorten\2\1\0\0\rsections\14lualine_z\1\3\0\0\rlocation\rprogress\14lualine_y\fsources\1\2\0\0\rnvim_lsp\1\2\0\0\16diagnostics\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\2\2\0\rfilename\14full_path\2\fshorten\2\14lualine_b\1\2\0\0\vbranch\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\1\0\2\ntheme\fonedark\18icons_enabled\2\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["nvim-bqf"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\nñ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\27always_show_bufferline\1\20show_close_icon\1\16diagnostics\rnvim_lsp\28show_buffer_close_icons\1\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n’\1\0\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\0016\0\6\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\21set shortmess+=c\bcmd\bvim\vsource\1\0\v\nemoji\1\tomni\1\nvsnip\2\tcalc\2\ttmux\2\rnvim_lua\2\ttags\2\vbuffer\2\tpath\2\rnvim_lsp\2\nspell\2\1\0\1\14preselect\valways\nsetup\ncompe\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lsp-ts-utils"] = {
    config = { "\27LJ\2\nß\2\0\1\5\0\a\0\0156\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3\3\0005\4\4\0=\4\5\3B\1\2\0016\1\0\0'\3\1\0B\1\2\0029\1\6\1\18\3\0\0B\1\2\1K\0\1\0\17setup_client\19formatter_args\1\5\0\0\20--fix-to-stdout\f--stdin\21--stdin-filename\14$FILENAME\1\0\5\30eslint_enable_diagnostics\2 enable_import_on_completion\2\19format_on_save\2\14formatter\reslint_d\22enable_formatting\2\nsetup\22nvim-lsp-ts-utils\frequire^\1\0\4\0\a\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0005\2\5\0003\3\4\0=\3\6\2B\0\2\1K\0\1\0\14on_attach\1\0\0\0\nsetup\rtsserver\14lspconfig\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-lsp-ts-utils"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-lsputils"] = {
    config = { "\27LJ\2\næ\5\0\0\4\0\23\0A6\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\5\0B\1\2\0029\1\6\1=\1\3\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\t\1=\1\a\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\v\1=\1\n\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\r\1=\1\f\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\15\1=\1\14\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\17\1=\1\16\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\19\0B\1\2\0029\1\20\1=\1\18\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\19\0B\1\2\0029\1\22\1=\1\21\0K\0\1\0\22workspace_handler\21workspace/symbol\21document_handler\20lsputil.symbols textDocument/documentSymbol\27implementation_handler textDocument/implementation\27typeDefinition_handler textDocument/typeDefinition\24declaration_handler\29textDocument/declaration\23definition_handler\28textDocument/definition\23references_handler\22lsputil.locations\28textDocument/references\24code_action_handler\23lsputil.codeAction\frequire\28textDocument/codeAction\rhandlers\blsp\bvim\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-lsputils"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle", "NvimTreeRefresh", "NvimTreeFindFile" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nä\b\0\0\6\0&\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0004\4\0\0=\4\v\0035\4\f\0=\4\r\3=\3\14\0025\3\16\0005\4\15\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0005\5\21\0=\5\r\4=\4\22\0035\4\23\0005\5\24\0=\5\r\4=\4\25\3=\3\26\0025\3\29\0005\4\27\0004\5\0\0=\5\v\0045\5\28\0=\5\r\4=\4\30\0035\4\31\0005\5 \0=\5!\0045\5\"\0=\5#\4=\4$\3=\3%\2B\0\2\1K\0\1\0\16textobjects\tswap\18swap_previous\1\0\1\agS\21@parameter.inner\14swap_next\1\0\1\ags\21@parameter.inner\1\0\1\venable\2\vselect\1\0\0\1\0\15\aac\23@conditional.outer\aib\17@block.inner\ais\21@statement.inner\aab\17@block.outer\aam\16@call.outer\aad\19@comment.outer\aif\20@function.inner\aic\23@conditional.inner\aiC\17@class.inner\aal\16@loop.outer\aaC\17@class.outer\aas\21@statement.outer\aid\19@comment.inner\aaf\20@function.outer\ail\16@loop.inner\1\0\1\venable\2\rrefactor\15navigation\1\0\2\21list_definitions\agD\20goto_definition\agd\1\0\1\venable\2\17smart_rename\1\0\1\17smart_rename\bgrr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\1\26incremental_selection\fkeymaps\1\0\4\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\19init_selection\bgnn\fdisable\1\0\1\venable\1\fmatchup\1\0\1\venable\2\vindent\1\0\1\venable\1\14highlight\1\0\1\venable\2\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme onedark\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nÉ\4\0\0\t\0\28\0(6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0015\3\24\0005\4\18\0005\5\16\0005\6\5\0009\a\4\0=\a\6\0069\a\a\0009\b\b\0 \a\b\a=\a\t\0069\a\n\0009\b\b\0 \a\b\a=\a\v\0069\a\f\0=\a\r\0069\a\14\0=\a\15\6=\6\17\5=\5\19\0045\5\21\0005\6\20\0=\6\22\5=\5\23\4=\4\25\3B\1\2\0016\1\0\0'\3\2\0B\1\2\0029\1\26\1'\3\27\0B\1\2\1K\0\1\0\bfzf\19load_extension\rdefaults\1\0\0\18layout_config\15horizontal\1\0\0\1\0\2\20prompt_position\btop\19preview_cutoff\3P\rmappings\1\0\2\20layout_strategy\15horizontal\21sorting_strategy\14ascending\6i\1\0\0\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-a>\24smart_add_to_qflist\n<C-q>\16open_qflist\25smart_send_to_qflist\n<Esc>\1\0\0\nclose\nsetup\14telescope\22telescope.actions\frequire\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tmuxline.vim"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/tmuxline.vim"
  },
  undotree = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/undotree"
  },
  ["vim-closetag"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-closetag"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dirvish"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-dirvish"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/david.maia/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-obsession"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-prosession"] = {
    config = { "\27LJ\2\n¨\1\0\0\4\0\b\0\0176\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\a\0K\0\1\0\26prosession_per_branch\26prosession_on_startup\26~/.cache/vim/sessions\vexpand\afn\19prosession_dir\6g\bvim\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-prosession"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rooter"] = {
    config = { "\27LJ\2\n4\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\23rooter_manual_only\6g\bvim\0" },
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-snippets"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-clipboard"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-tmux-clipboard"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/david.maia/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n∏\4\0\0\a\0\28\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0034\4\3\0005\5\v\0>\5\1\4=\4\f\0035\4\r\0=\4\14\0034\4\3\0005\5\15\0005\6\16\0=\6\17\5>\5\1\4=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0004\4\0\0=\4\b\0034\4\0\0=\4\n\0034\4\3\0005\5\23\0>\5\1\4=\4\f\0035\4\24\0=\4\14\0034\4\0\0=\4\18\0034\4\0\0=\4\20\3=\3\25\0025\3\26\0=\3\27\2B\0\2\1K\0\1\0\15extensions\1\2\0\0\rfugitive\22inactive_sections\1\2\0\0\rlocation\1\2\2\0\rfilename\14full_path\2\fshorten\2\1\0\0\rsections\14lualine_z\1\3\0\0\rlocation\rprogress\14lualine_y\fsources\1\2\0\0\rnvim_lsp\1\2\0\0\16diagnostics\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\2\2\0\rfilename\14full_path\2\fshorten\2\14lualine_b\1\2\0\0\vbranch\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\1\0\2\ntheme\fonedark\18icons_enabled\2\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: onedark.nvim
time([[Config for onedark.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme onedark\bcmd\bvim\0", "config", "onedark.nvim")
time([[Config for onedark.nvim]], false)
-- Config for: nvim-lsputils
time([[Config for nvim-lsputils]], true)
try_loadstring("\27LJ\2\næ\5\0\0\4\0\23\0A6\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\5\0B\1\2\0029\1\6\1=\1\3\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\t\1=\1\a\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\v\1=\1\n\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\r\1=\1\f\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\15\1=\1\14\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\b\0B\1\2\0029\1\17\1=\1\16\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\19\0B\1\2\0029\1\20\1=\1\18\0006\0\0\0009\0\1\0009\0\2\0006\1\4\0'\3\19\0B\1\2\0029\1\22\1=\1\21\0K\0\1\0\22workspace_handler\21workspace/symbol\21document_handler\20lsputil.symbols textDocument/documentSymbol\27implementation_handler textDocument/implementation\27typeDefinition_handler textDocument/typeDefinition\24declaration_handler\29textDocument/declaration\23definition_handler\28textDocument/definition\23references_handler\22lsputil.locations\28textDocument/references\24code_action_handler\23lsputil.codeAction\frequire\28textDocument/codeAction\rhandlers\blsp\bvim\0", "config", "nvim-lsputils")
time([[Config for nvim-lsputils]], false)
-- Config for: nvim-bufferline.lua
time([[Config for nvim-bufferline.lua]], true)
try_loadstring("\27LJ\2\nñ\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\27always_show_bufferline\1\20show_close_icon\1\16diagnostics\rnvim_lsp\28show_buffer_close_icons\1\nsetup\15bufferline\frequire\0", "config", "nvim-bufferline.lua")
time([[Config for nvim-bufferline.lua]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n’\1\0\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\0016\0\6\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\21set shortmess+=c\bcmd\bvim\vsource\1\0\v\nemoji\1\tomni\1\nvsnip\2\tcalc\2\ttmux\2\rnvim_lua\2\ttags\2\vbuffer\2\tpath\2\rnvim_lsp\2\nspell\2\1\0\1\14preselect\valways\nsetup\ncompe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nä\b\0\0\6\0&\0/6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0004\4\0\0=\4\v\0035\4\f\0=\4\r\3=\3\14\0025\3\16\0005\4\15\0=\4\17\0035\4\18\0=\4\19\0035\4\20\0005\5\21\0=\5\r\4=\4\22\0035\4\23\0005\5\24\0=\5\r\4=\4\25\3=\3\26\0025\3\29\0005\4\27\0004\5\0\0=\5\v\0045\5\28\0=\5\r\4=\4\30\0035\4\31\0005\5 \0=\5!\0045\5\"\0=\5#\4=\4$\3=\3%\2B\0\2\1K\0\1\0\16textobjects\tswap\18swap_previous\1\0\1\agS\21@parameter.inner\14swap_next\1\0\1\ags\21@parameter.inner\1\0\1\venable\2\vselect\1\0\0\1\0\15\aac\23@conditional.outer\aib\17@block.inner\ais\21@statement.inner\aab\17@block.outer\aam\16@call.outer\aad\19@comment.outer\aif\20@function.inner\aic\23@conditional.inner\aiC\17@class.inner\aal\16@loop.outer\aaC\17@class.outer\aas\21@statement.outer\aid\19@comment.inner\aaf\20@function.outer\ail\16@loop.inner\1\0\1\venable\2\rrefactor\15navigation\1\0\2\21list_definitions\agD\20goto_definition\agd\1\0\1\venable\2\17smart_rename\1\0\1\17smart_rename\bgrr\1\0\1\venable\2\28highlight_current_scope\1\0\1\venable\1\26highlight_definitions\1\0\0\1\0\1\venable\1\26incremental_selection\fkeymaps\1\0\4\22scope_incremental\bgrc\21node_incremental\bgrn\21node_decremental\bgrm\19init_selection\bgnn\fdisable\1\0\1\venable\1\fmatchup\1\0\1\venable\2\vindent\1\0\1\venable\1\14highlight\1\0\1\venable\2\1\0\1\21ensure_installed\15maintained\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lsp-trouble.nvim
time([[Config for lsp-trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "lsp-trouble.nvim")
time([[Config for lsp-trouble.nvim]], false)
-- Config for: vim-prosession
time([[Config for vim-prosession]], true)
try_loadstring("\27LJ\2\n¨\1\0\0\4\0\b\0\0176\0\0\0009\0\1\0006\1\0\0009\1\3\0019\1\4\1'\3\5\0B\1\2\2=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\a\0K\0\1\0\26prosession_per_branch\26prosession_on_startup\26~/.cache/vim/sessions\vexpand\afn\19prosession_dir\6g\bvim\0", "config", "vim-prosession")
time([[Config for vim-prosession]], false)
-- Config for: vim-rooter
time([[Config for vim-rooter]], true)
try_loadstring("\27LJ\2\n4\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\23rooter_manual_only\6g\bvim\0", "config", "vim-rooter")
time([[Config for vim-rooter]], false)
-- Config for: nvim-lsp-ts-utils
time([[Config for nvim-lsp-ts-utils]], true)
try_loadstring("\27LJ\2\nß\2\0\1\5\0\a\0\0156\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3\3\0005\4\4\0=\4\5\3B\1\2\0016\1\0\0'\3\1\0B\1\2\0029\1\6\1\18\3\0\0B\1\2\1K\0\1\0\17setup_client\19formatter_args\1\5\0\0\20--fix-to-stdout\f--stdin\21--stdin-filename\14$FILENAME\1\0\5\30eslint_enable_diagnostics\2 enable_import_on_completion\2\19format_on_save\2\14formatter\reslint_d\22enable_formatting\2\nsetup\22nvim-lsp-ts-utils\frequire^\1\0\4\0\a\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0005\2\5\0003\3\4\0=\3\6\2B\0\2\1K\0\1\0\14on_attach\1\0\0\0\nsetup\rtsserver\14lspconfig\frequire\0", "config", "nvim-lsp-ts-utils")
time([[Config for nvim-lsp-ts-utils]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nÉ\4\0\0\t\0\28\0(6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0015\3\24\0005\4\18\0005\5\16\0005\6\5\0009\a\4\0=\a\6\0069\a\a\0009\b\b\0 \a\b\a=\a\t\0069\a\n\0009\b\b\0 \a\b\a=\a\v\0069\a\f\0=\a\r\0069\a\14\0=\a\15\6=\6\17\5=\5\19\0045\5\21\0005\6\20\0=\6\22\5=\5\23\4=\4\25\3B\1\2\0016\1\0\0'\3\2\0B\1\2\0029\1\26\1'\3\27\0B\1\2\1K\0\1\0\bfzf\19load_extension\rdefaults\1\0\0\18layout_config\15horizontal\1\0\0\1\0\2\20prompt_position\btop\19preview_cutoff\3P\rmappings\1\0\2\20layout_strategy\15horizontal\21sorting_strategy\14ascending\6i\1\0\0\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-a>\24smart_add_to_qflist\n<C-q>\16open_qflist\25smart_send_to_qflist\n<Esc>\1\0\0\nclose\nsetup\14telescope\22telescope.actions\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeRefresh lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeRefresh", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-matchup'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(1) end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
