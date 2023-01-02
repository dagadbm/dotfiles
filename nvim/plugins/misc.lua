return {
  -- [[ Color Schemes ]]
  { 'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'dark',
        toggle_style_key = '<NOP>'
      }
    end
  },

  -- basically everyone is using this package as a dependency
  'nvim-lua/plenary.nvim',

  -- [[ Vim Config Debugging ]]
  -- https://vimways.org/2018/debugging-your-vim-config/
  -- 'dstein64/vim-startuptime',
  -- 'tpope/vim-scriptease',

  -- [[ UI ]]
  --- Files and Folders Navigation
  -- 'justinmk/vim-dirvish'
  {
    'elihunter173/dirbuf.nvim',
    keys = '-',
  },
  -- show registers automatically when using " or <Ctrl-R>
  {
    'tversteeg/registers.nvim',
    keys = {
      [["]],
      { [[<C-R>]], mode = 'i' },
    },
    config = function()
      require('registers').setup {}
    end
  },
  -- show line preview when using :<Number>
  {
    'nacro90/numb.nvim',
    event = 'CmdlineEnter',
    config = function()
      require('numb').setup {}
    end
  },
  -- icons
  'kyazdani42/nvim-web-devicons',
  -- Buffer line
  { 'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    config = function()
      require('bufferline').setup {
        options = {
          diagnostics = 'nvim_lsp',
        }
      }
    end
  },
  -- Light as air status-bar
  { 'hoob3rt/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'onedark',
          icons_enabled = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { { 'filename', path = 2 } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
          lualine_z = { 'location', 'progress' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', full_path = true, shorten = true } },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        extensions = { 'fugitive' }
      }
    end
  },

  -- [[ Editting ]]
  -- best way to have indentation kind of working everywhere
  {
    'sheerun/vim-polyglot',
    -- it is faster to run vim-polyglot on start
    lazy = false,
  },

  -- Surround text with s motion
  -- 'tpope/vim-surround'
  {
    'kylechui/nvim-surround',
    event = 'InsertEnter',
    config = function()
      require('nvim-surround').setup {}
    end
  },
  -- Allow the dot command to work on plugin actions for surround
  {
    'tpope/vim-repeat',
    keys = '.',
  },
  -- Add commentary key-bindings
  {
    'tpope/vim-commentary',
    keys = 'gc',
  },
  -- Add additional text objects to vim
  -- indentation as an object (i)
  {
    'michaeljsmith/vim-indent-object',
    event = 'InsertEnter',
  },
  {
    'wellle/targets.vim',
    event = 'InsertEnter',
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        auto_resize_height = true
      }
    end
  },

  -- ui related
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    config = function ()
      require('fidget').setup {}
    end
  },
  {
    'kosayoda/nvim-lightbulb',
    event = 'VeryLazy',
    config = function ()
      require('nvim-lightbulb').setup {
        autocmd = {
          enabled = true
        }
      }
    end
  },
  -- pictograms for completion items (check nvim-cmp for integration)
  {
    'onsails/lspkind-nvim',
    event = 'VeryLazy',
  },
  -- better UI for lsp
  { 'RishabhRD/nvim-lsputils',
    event = 'VeryLazy',
    dependencies = {
      { 'RishabhRD/popfix' },
    },
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
      vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
      vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
      vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
      vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
    end
  },
  -- show diagnostics in virtual text
  {
    url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'VeryLazy',
    config = function()
      require('lsp_lines').setup {}
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = true,
      })
    end,
  },

  -- [[ Undo history ]]
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
  },

  -- [[ Session Management ]]
  { 'dhruvasagar/vim-prosession',
    -- this loads faster if its not lazy
    lazy = false,
    event = 'VimEnter',
    dependencies = {
      'tpope/vim-obsession',
    },
    config = function()
      vim.g.prosession_dir = vim.fn.expand('~/.cache/nvim/sessions')
      vim.g.prosession_on_startup = 1
      vim.g.prosession_per_branch = 1
      vim.g.prosession_per_branch = 1
      vim.g.prosession_default_session = 1
    end,
  },

  -- [[ Code Navigation ]]
  -- Vim matchit plugin (makes % match with other tags)
  {
    'andymass/vim-matchup',
    keys = '%',
  },
  -- Fuzzy finder
  { 'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup {
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
              ['<C-s>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
            },
          },
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              preview_cutoff = 100,
              preview_width = 0.6,
              prompt_position = 'top',
            },
          },
          sorting_strategy = 'ascending',
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown()
          },
          live_grep_args = {
            auto_quoting = false,
          }
        }
      }

      -- native lua implementation of fzf
      telescope.load_extension('fzf')
      -- set vim.ui.select to telescope
      telescope.load_extension('ui-select')
      -- pass arguments to rg similar to vim.agriculture
      telescope.load_extension('live_grep_args')
      -- dap support
      telescope.load_extension('dap')
    end
  },

  -- [[ Key Bindings ]]
  {
    'tpope/vim-unimpaired',
    keys = { '[', ']'},
  },

  { 'folke/which-key.nvim',
    lazy = false,
    config = function()
      require('which-key').setup {
        registers = false,
      }
    end
  },

  -- [[ External Integrations ]]
  -- Git
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  { 'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup {
        keymaps = nil,
      }
    end
  },

  -- Tmux
  { 'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
    dependencies = {
    'roxma/vim-tmux-clipboard',
    -- Make vim color scheme integrate automatically with tmux
    'edkolev/tmuxline.vim',
    },
  },

  -- Terminal
  -- 'voldikss/vim-floaterm'
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'ToggleTermToggleAll', 'ToggleTermSendVisualSelection', },
    config = function ()
      require('toggleterm').setup {
        insert_mappings = false,
        terminal_mappings = false,
      }
    end,
  },

  -- Testing
  { 'vim-test/vim-test',
    cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit', },
    config = function()
      -- https://github.com/vim-test/vim-test#strategies
      vim.g['test#strategy'] = 'neovim'
    end
  },
}
