local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup { function(use)
  use 'wbthomason/packer.nvim'

  -- make nvim setup faster in a zero effort way
  use { 'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end
  }

  -- basically everyone is using this package as a dependency
  use 'nvim-lua/plenary.nvim'

  -- temporary work-around until nvim has fixed cursor hold issues
  use 'antoinemadec/FixCursorHold.nvim'

  -- [[ Vim Config Debugging ]]
  -- https://vimways.org/2018/debugging-your-vim-config/
  -- use 'dstein64/vim-startuptime'
  -- use 'tpope/vim-scriptease'

  -- [[ UI ]]
  --- Files and Folders Navigation
  -- use 'justinmk/vim-dirvish'
  use 'elihunter173/dirbuf.nvim'
  -- show registers automatically when using " or <Ctrl-R>
  use 'tversteeg/registers.nvim'
  -- show line preview when using :<Number>
  use 'nacro90/numb.nvim'
  -- icons
  use 'kyazdani42/nvim-web-devicons'
  -- Buffer line
  use { 'akinsho/bufferline.nvim',
    config = function()
      require("bufferline").setup {}
    end
  }
  -- Light as air status-bar
  use { 'hoob3rt/lualine.nvim',
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
  }

  -- [[ Editting ]]
  -- best way to have indentation kind of working everywhere
  use 'sheerun/vim-polyglot'
  -- Surround text with s motion
  -- use 'tpope/vim-surround'
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup {}
    end
  })
  -- Allow the dot command to work on plugin actions for surround
  use 'tpope/vim-repeat'
  -- Add commentary key-bindings
  use 'tpope/vim-commentary'
  -- Add additional text objects to vim
  -- indentation as an object (i)
  use 'michaeljsmith/vim-indent-object'
  use 'wellle/targets.vim'
  use {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup {
        auto_resize_height = true
      }
    end
  }

  -- [[ Extra vim behavior ]]
  use 'tpope/vim-eunuch'

  -- [[ LSP ]]
  use 'neovim/nvim-lspconfig'
  use {
    'williamboman/mason.nvim',
    requires = {
      { 'WhoIsSethDaniel/mason-tool-installer.nvim',
        config = function()
          require('mason-tool-installer').setup { }
        end
      },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup { }
    end
  }

  use 'folke/lua-dev.nvim'
  use 'jose-elias-alvarez/typescript.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  -- ui related
  use {
    'j-hui/fidget.nvim',
    config = function ()
      require('fidget').setup { }
    end
  }
  use {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require('nvim-lightbulb').setup {
        autocmd = {
          enabled = true
        }
      }
    end
  }
  -- pictograms for completion items
  use 'onsails/lspkind-nvim' -- check nvim-cmp for integration
  -- better UI for lsp
  use { 'RishabhRD/nvim-lsputils',
    requires = {
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
  }
  -- show diagnostics in virtual text
  use {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({
          virtual_text = true,
          virtual_lines = true,
        })
      end,
    }

  -- [[ Undo history ]]
  use 'mbbill/undotree'

  -- [[ Session Management ]]
  use 'tpope/vim-obsession'
  use { 'dhruvasagar/vim-prosession',
    config = function()
      vim.g.prosession_dir = vim.fn.expand('~/.cache/vim/sessions')
      vim.g.prosession_on_startup = 1
      vim.g.prosession_per_branch = 1
    end
  }

  -- [[ Syntax ]]
  -- tree sitter
  use { 'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-refactor' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
      { 'RRethy/nvim-treesitter-textsubjects' },
      { 'windwp/nvim-ts-autotag' },
    },
    run = ':TSUpdate',
    config = function()
      -- module configs
      local refactor = {
        highlight_definitions = {
          enable = true
        },
        highlight_current_scope = {
          enable = false
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = 'grr' -- mapping to rename reference under cursor
          }
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gd', -- mapping to go to definition of symbol under cursor
            list_definitions = 'gD' -- mapping to list all definitions in current file
          }
        }
      }

      local textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['is'] = '@statement.inner',
            ['as'] = '@statement.outer',
            ['am'] = '@call.outer',
          }
          },
          swap = {
            enable = true,
            swap_next = { ['gs'] = '@parameter.inner' },
            swap_previous = { ['gS'] = '@parameter.inner' }
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          }
        }

        local context_commentstring = {
          enable = true
        }

        local textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            ['a;'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          }
        }

        local autotag = {
          enable = true,
        }

        -- vim.matchup plugin
        local matchup = {
          enable = true
        }

        require('nvim-treesitter.configs').setup {
          -- instalation related config
          ensure_installed = 'all',
          sync_install = true,
          auto_install = true,
          -- https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
          ignore_install = { 'phpdoc' },

          -- modules
          highlight = { enable = true },
          -- treesitter indentation is not stable at all
          indent = { enable = false },
          incremental_selection = {
            enable = true,
            keymaps = { -- mappings for incremental selection (visual mappings)
              init_selection = '<C-n>', -- maps in normal mode to init the node/scope selection
              node_incremental = '<C-n>', -- increment to the upper named parent
              node_decremental = '<C-p>' -- decrement to the previous node
            }
          },

          -- external modules
          context_commentstring = context_commentstring,
          refactor = refactor,
          textobjects = textobjects,
          textsubjects = textsubjects,
          autotag = autotag,
          matchup = matchup,
        }
    end
  }

  -- [[ Code Navigation ]]
  -- Vim matchit plugin (makes % match with other tags)
  use 'andymass/vim-matchup'
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
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

      -- use native lua implementation of fzf
      telescope.load_extension('fzf')
      -- set vim.ui.select to use telescope
      telescope.load_extension('ui-select')
      -- pass arguments to rg similar to vim.agriculture
      telescope.load_extension('live_grep_args')
    end
  }

  -- [[ Key Bindings ]]
  use 'tpope/vim-unimpaired'
  use { 'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        registers = false,
      }
    end
  }

  -- [[ Snippets ]]
  -- engine
  use { 'L3MON4D3/LuaSnip',
    requires = {
      -- snippets
      'honza/vim-snippets',
      'rafamadriz/friendly-snippets',
      'sdras/vue-vscode-snippets',
    },
    config = function ()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_snipmate').lazy_load()
      require('luasnip.loaders.from_lua').lazy_load()
      -- support for honza/vim-snippets
      require('luasnip').filetype_extend('all', { '_' })
    end
  }

  -- [[ Completion ]]
  -- copilot
  -- use 'github/copilot.vim'
  use {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
        require('copilot').setup()
    end
  }
  use 'zbirenbaum/copilot-cmp'

  -- engine
  use { 'hrsh7th/nvim-cmp',
    requires = {
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'andersevenrud/cmp-tmux' },
      { 'hrsh7th/cmp-calc' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-omni' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')

      -- Mandatory for nvim-compe to work correctly
      vim.o.completeopt = 'menu,menuone,noselect'

      -- adapted from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        sources = cmp.config.sources({
          -- from zbirenbaum/copilot-cmp
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp_document_symbol' },
          { name = 'calc' },
          { name = 'nvim_lua', keyword_length = 3 },
          { name = 'luasnip', keyword_length = 3 },
          { name = 'buffer', keyword_length = 3, max_item_count = 5 },
          { name = 'tmux', keyword_length = 3, max_item_count = 5 },
          { name = 'path', keyword_length = 3, max_item_count = 5 },
          { name = 'cmdline', keyword_length = 3, max_item_count = 5 },
          { name = 'omni', keyword_length = 3 },
        }),
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Esc>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 48, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          })
        }
      }
    end
  }

  -- [[ External Integrations ]]
  -- Git
  use 'tpope/vim-fugitive'
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        keymaps = nil,
      }
    end
  }

  -- Tmux
  use 'christoomey/vim-tmux-navigator'
  use 'roxma/vim-tmux-clipboard'
  -- Make vim color scheme integrate automatically with tmux
  use 'edkolev/tmuxline.vim'

  -- Terminal
  -- use 'voldikss/vim-floaterm'
  use  {
    'akinsho/toggleterm.nvim',
    config = function ()
      require('toggleterm').setup {
        insert_mappings = false,
        terminal_mappings = false,
      }
    end
  }

  -- Testing
  use { 'vim-test/vim-test',
    config = function()
      -- https://github.com/vim-test/vim-test#strategies
      vim.g['test#strategy'] = 'neovim'
    end
  }

  -- [[ Color Schemes ]]
  use { 'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup {
        style = 'dark',
        toggle_style_key = '<NOP>'
      }
    end
  }

  -- https://github.com/wbthomason/packer.nvim#bootstrapping
  if packer_bootstrap then
    require('packer').sync()
  end
end, config = {
  profile = {
    enable = false,
    threshold = 1
  }
} } -- require('packer').startup
