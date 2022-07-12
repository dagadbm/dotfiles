local packer_install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..packer_install_path)
  vim.cmd 'packadd packer.nvim'
end

require('packer').startup { function(use)
  use 'wbthomason/packer.nvim'
  -- basically everyone is using this package as a dependency
  use 'nvim-lua/plenary.nvim'

  -- [[ Vim Config Debugging ]]
  -- https://vimways.org/2018/debugging-your-vim-config/
  -- use 'dstein64/vim-startuptime'
  -- use 'tpope/vim-scriptease'

  -- [[ UI ]]
  --- Files and Folders Navigation
  use 'justinmk/vim-dirvish'
  use { 'kyazdani42/nvim-tree.lua',
    cmd  = { 'NvimTreeToggle', 'NvimTreeRefresh', 'NvimTreeFindFile' },
  }
  -- icons
  use 'kyazdani42/nvim-web-devicons'
  -- Buffer line
  use { 'akinsho/bufferline.nvim',
    config = function ()
      require("bufferline").setup { }
    end
  }
  -- Light as air status-bar
  use { 'hoob3rt/lualine.nvim',
    config = function ()
      require('lualine').setup {
        options = {
          theme = 'onedark',
          icons_enabled = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {{'filename', path = 2 }},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = { {'diagnostics', sources = { 'nvim_diagnostic' }} },
          lualine_z = {'location', 'progress'},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{'filename', full_path = true, shorten = true}},
          lualine_x = {'location'},
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
  use 'tpope/vim-surround'
  -- Allow the dot command to work on plugin actions for surround
  use 'tpope/vim-repeat'
  -- Add commentary with gcc for line.
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- Add additional text objects to vim
  -- indentation as an object (i)
  use 'michaeljsmith/vim-indent-object'
  use 'wellle/targets.vim'
  use 'wellle/line-targets.vim'
  -- Make vim current directory the project root
  use { 'airblade/vim-rooter',
    config = function ()
      vim.g.rooter_manual_only = 0
    end
  }
  use 'kevinhwang91/nvim-bqf'
  -- Auto close tags
  use 'alvan/vim-closetag'

  -- [[ Extra vim behavior ]]
  use 'tpope/vim-eunuch'

  -- [[ LSP ]]
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  -- add lsp hightlight support for every colorscheme
  use 'folke/lsp-colors.nvim'
  use {
    "folke/lsp-trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  -- pictograms for completion items
  use { 'onsails/lspkind-nvim',
    config = function ()
      require('lspkind').init{
      }
    end
  }
  -- better UI for lsp
  -- use { 'glepnir/lspsaga.nvim', config = function() require('lspsaga').init_lsp_saga() end }
  use { 'RishabhRD/nvim-lsputils',
    requires = {
      {'RishabhRD/popfix'},
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
  use { 'jose-elias-alvarez/nvim-lsp-ts-utils',
    config = function ()
      require("lspconfig").tsserver.setup {
        on_attach = function (client)
          require("nvim-lsp-ts-utils").setup {
            enable_import_on_completion = true,
            eslint_enable_diagnostics = true,
            enable_formatting = true,
            formatter = "eslint_d",
            formatter_args = {
              "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME"
            },
            format_on_save = true
          }
          require("nvim-lsp-ts-utils").setup_client(client)
        end
      }
    end
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
      {'nvim-treesitter/nvim-treesitter-refactor'},
      {'nvim-treesitter/nvim-treesitter-textobjects'},
    },
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        highlight = { enable = true },
        ignore_install = { 'phpdoc' },
        -- treesitter indentation is not stable at all
        indent = { enable = false },
        -- vim-matchup supports treesitter
        matchup = { enable = true},
        incremental_selection = {
          enable = false,
          disable = {},
          keymaps = { -- mappings for incremental selection (visual mappings)
            init_selection = 'gnn', -- maps in normal mode to init the node/scope selection
            node_incremental = 'grn', -- increment to the upper named parent
            scope_incremental = 'grc', -- increment to the upper scope (as defined in locals.scm)
            node_decremental = 'grm' -- decrement to the previous node
          }
        },
        refactor = {
          highlight_definitions = {enable = false},
          highlight_current_scope = {enable = false},
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
        },
        textobjects = { -- syntax-aware textobjects
          select = {
            enable = true,
            disable = {},
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['aC'] = '@class.outer',
              ['iC'] = '@class.inner',
              ['ac'] = '@conditional.outer',
              ['ic'] = '@conditional.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['is'] = '@statement.inner',
              ['as'] = '@statement.outer',
              ['am'] = '@call.outer',
              ['ad'] = '@comment.outer',
              ['id'] = '@comment.inner',
            }
          },
          swap = {
            enable = true,
            swap_next = {['gs'] = '@parameter.inner'},
            swap_previous = {['gS'] = '@parameter.inner'}
          }
        }
      }
    end
  }

  -- [[ Code Navigation ]]
  -- Vim matchit plugin (makes % match with other tags)
  use { 'andymass/vim-matchup', event = 'VimEnter' }
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
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
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              preview_cutoff = 80,
              prompt_position = 'top',
            },
          },
          sorting_strategy = 'ascending',
        },
      }
      -- use native lua implementation of fzf
      require('telescope').load_extension('fzf')
    end
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
  use { 'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        preselect = 'always',
        source = {
          nvim_lsp = true,
          nvim_lua = true,
          tmux = true,
          path = true,
          buffer = true,
          tags = true,
          spell = true,
          calc = true,
          vsnip = true,
          omni = false,
          emoji = false,
        };
      }
      -- don't give |ins-completion-menu| messages. nvim-compe config
      vim.cmd 'set shortmess+=c'
    end
  }
  -- sources
  use { 'andersevenrud/cmp-tmux', branch = 'compe' }
  -- [[ External Integrations ]]
  -- Git
  use 'tpope/vim-fugitive'
  use { 'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup {
        keymaps = nil,
      }
    end
  }
  use 'kdheepak/lazygit.nvim'

  -- Tmux
  use 'christoomey/vim-tmux-navigator'
  use 'roxma/vim-tmux-clipboard'
  -- Make vim color scheme integrate automatically with tmux
  use 'edkolev/tmuxline.vim'

  -- [[ Color Schemes ]]
  use { 'navarasu/onedark.nvim',
    config = function ()
      vim.cmd 'colorscheme onedark'
    end
  }
  -- use { 'tiagovla/tokyodark.nvim',
  --   opt = true,
  --   config = function ()
  --     vim.g.tokyodark_transparent_background = true
  --     vim.g.tokyodark_enable_italic_comment = true
  --     vim.g.tokyodark_enable_italic = true
  --     vim.g.tokyodark_color_gamma = "1.0"
  --   end
  -- }
  -- use { 'marko-cerovac/material.nvim',
  --   opt = true,
  --   config = function ()
  --     -- The theme comes in five styles, 'darker', 'lighter', 'palenight', 'oceanic' and 'deep ocean'
  --     vim.g.material_style = 'darker'
  --     vim.g.material_italic_comments = true
  --     vim.g.material_italic_keywords = true
  --     vim.g.material_italic_functions = true
  --     vim.g.material_italic_variables = true
  --     vim.g.material_contrast = true
  --     vim.g.material_borders = true
  --     vim.g.material_disable_background = true
  --   end
  -- }
end, config = {
  profile = {
    enable = true,
    threshold = 1
  }
}} -- require('packer').startup

-- LSP
local lsp_installer = require("nvim-lsp-installer")
-- server list to be used
local lsp_servers = {
  -- front-end
  'html',
  'cssls',
  'tsserver',
  'volar',
  'vuels',
  'graphql',
  -- back-end
  'pyright',
  'jedi_language_server',
  --'gopls',
  -- markup
  'yamlls',
  'jsonls',
  -- vim
  'vimls',
  'sumneko_lua',
}
-- server config (has to match above name)
-- lsp setup configuration
local lsp_config = {
  sumneko_lua = function ()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    return {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end
}

-- auto install lsps
for _, name in pairs(lsp_servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end

-- setup lsp config
lsp_installer.on_server_ready(function(server)
  local opts = {}

  if lsp_config[server.name] ~= nil then
      opts = lsp_config[server.name]()
   end

  server:setup(opts)
end)