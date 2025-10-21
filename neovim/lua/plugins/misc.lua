return {
  -- [[ Dependencies  ]]
  -- basically everyone is using this package as a dependency
  'nvim-lua/plenary.nvim',

  -- icons everyone is using
  'nvim-tree/nvim-web-devicons',

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
      require('onedark').load()
    end
  },

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
  -- show line preview when using :<Number>
  {
    'nacro90/numb.nvim',
    event = 'CmdlineEnter',
    opts = {},
  },
  -- Buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
        tab_size = 16,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = 'thin',
      }
    }
  },
  -- Light as air status-bar
  {
    'hoob3rt/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'onedark',
        icons_enabled = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { { 'diagnostics', sources = { 'nvim_diagnostic' } } },
        lualine_z = { 'location', 'progress' },
      },
      inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
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
  },
  -- improved quick fix list
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      auto_resize_height = true,
      show_title = true,
      wrap = true,
    }
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
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
  },
  {
    'nvim-mini/mini.ai',
    version = '*',
    opts = {},
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
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      git_use_branch_name = true,
      git_auto_restore_on_branch_change = true,
      root_dir = vim.fn.expand('~/.cache/nvim/sessions/'),
      session_control = {
        control_dir = vim.fn.expand('~/.cache/nvim/sessions/'),
        control_filename = "session_control.json",
      },
    },
  },

  -- [[ Code Navigation ]]
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
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
          },
        }
      }

      -- native lua implementation of fzf
      telescope.load_extension('fzf')
      -- set vim.ui.select to telescope
      telescope.load_extension('ui-select')
      -- pass arguments to rg similar to vim.agriculture
      telescope.load_extension('live_grep_args')
    end
  },

  -- [[ Key Bindings ]]
  {
    'tpope/vim-unimpaired',
    keys = { '[', ']' },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
  },

  -- [[ External Integrations ]]
  -- File Actions
  {
    'tpope/vim-eunuch',
    event = 'VeryLazy',
  },
  -- Git
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  {
    'tpope/vim-rhubarb',
    event = 'VeryLazy',
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      keymaps = nil,
    }
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
    opts = {
      insert_mappings = false,
      terminal_mappings = false,
    }
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
