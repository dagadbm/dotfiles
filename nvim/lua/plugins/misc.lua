return {
  -- [[ Color Schemes ]]
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'dark',
        toggle_style_key = nil,
      }
      vim.cmd 'colorscheme onedark'
    end
  },

  -- basically everyone is using this package as a dependency
  'nvim-lua/plenary.nvim',

  -- icons everyone is using
  'kyazdani42/nvim-web-devicons',

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
    cmd = { 'Dirbuf' },
  },
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle' },
    config = function()
      require('nvim-tree').setup {}
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
  -- Buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    config = function()
      require('bufferline').setup {
        options = {
          numbers = 'buffer_id',
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = true,
          tab_size = 16,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = 'thin',
        }
      }
    end
  },
  -- Light as air status-bar
  {
    'hoob3rt/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      local navic = require('nvim-navic')
      require('lualine').setup {
        options = {
          theme = 'onedark',
          icons_enabled = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { { navic.get_location, cond = navic.is_available } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
          lualine_z = { 'location', 'progress' },
        },
        inactive_sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { { navic.get_location, cond = navic.is_available } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
          lualine_z = {},
        },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 3 } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 3 } },
          lualine_x = {},
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
    event = 'BufReadPost',
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
    event = 'VeryLazy',
    config = function()
      require('bqf').setup {
        auto_resize_height = true,
        show_title = true,
        wrap = true,
      }
    end
  },

  -- [[ Undo history ]]
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_WindowLayout = 2
    end,
  },

  -- [[ Session Management ]]
  {
    'dhruvasagar/vim-prosession',
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
      vim.g.prosession_default_session = 0
    end,
  },

  -- [[ Code Navigation ]]
  'ThePrimeagen/harpoon',
  -- Vim matchit plugin (makes % match with other tags)
  {
    'andymass/vim-matchup',
    -- this is currently not working and I dont know why
    enabled = false,
  },
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    -- remove this after https://github.com/nvim-telescope/telescope.nvim/issues/2192 is closed
    version = '0.1.x',
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
          path_display = { truncate = 5, },
          dynamic_preview_title = true,
          mappings = {
            i = {
              ['<Esc>'] = actions.close,
              -- replace current quick fix list with selected item
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              -- add to existing quick fix list with selected item
              ['<C-l>'] = actions.smart_send_to_loclist + actions.open_loclist,
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
        pickers = {
          buffers = {
            sort_mru = true,
            mappings = {
              i = {
                ['<C-d>'] = actions.delete_buffer,
              },
            },
          },
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

  {
    'folke/which-key.nvim',
    lazy = false,
    config = function()
      local wk = require('which-key')
      wk.setup {}
      wk.register({}, {})
    end
  },

  -- [[ External Integrations ]]
  -- Git
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup {
        keymaps = nil,
      }
    end
  },

  -- Tmux
  {
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
    dependencies = {
      'roxma/vim-tmux-clipboard',
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
  {
    'vim-test/vim-test',
    cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit', },
    config = function()
      -- https://github.com/vim-test/vim-test#strategies
      vim.g['test#strategy'] = 'neovim'
    end
  },
}
