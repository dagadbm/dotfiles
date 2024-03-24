return {
  -- [[ LSP Setup ]]
  {
    'williamboman/mason.nvim',
    event = 'BufReadPre',
    dependencies = {
      'RubixDev/mason-update-all',
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-null-ls.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'neovim/nvim-lspconfig',
      'folke/neodev.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'nvimtools/none-ls.nvim',
      'nvimtools/none-ls-extras.nvim',
      -- plugins that need direct hook into lsp_config
      'SmiteshP/nvim-navic',
    },
    config = function()
      -- this sets up tsserver under the hood
      require('typescript').setup {}
      -- this sets up neovim lua development under the hood
      require('neodev').setup {}

      require('mason').setup {}
      require('mason-update-all').setup {}

      -- [[ LSP CONFIG ]]
      local lsp_servers = {
        -- front-end
        html = {},
        cssls = {},
        volar = {},
        vuels = {},
        eslint = {},
        stylelint_lsp = {},
        -- setup by typescript.nvim
        -- tsserver = {},
        tailwindcss = {},
        -- back-end
        gopls = {},
        pyright = {},
        -- pylsp = {},
        -- jedi_language_server = {},
        -- markup
        yamlls = {},
        jsonls = {},
        -- misc
        bashls = {},
        lua_ls = {},
      }

      -- call lspconfig for above servers
      local navic = require('nvim-navic')
      for server_name, config in pairs(lsp_servers) do
        -- capabilities
        config.capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- on_attach
        local on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
          require('config.mappings').lsp_mappings(bufnr)
          if on_attach then
            on_attach(client, bufnr)
            -- navic specific config
            if client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end
          end
        end

        require('lspconfig')[server_name].setup(config)
      end

      require('mason-lspconfig').setup {
        -- automatically detect which servers to install
        -- (based on which servers are set up via lspconfig)
        automatic_installation = true,
      }

      -- [[ NULL LS ]]
      -- setup formatters / linters
      local null_ls = require('null-ls')
      null_ls.setup {
        sources = {
          -- diagnostics
          null_ls.builtins.diagnostics.stylelint,

          require('none-ls.diagnostics.eslint_d').with({
            env = {
              ESLINT_D_LOCAL_ESLINT_ONLY = true,
            },
          }),

          require('none-ls.diagnostics.flake8').with({
            prefer_local = ".venv/bin",
          }),
          null_ls.builtins.diagnostics.mypy.with({
            prefer_local = ".venv/bin",
          }),
          null_ls.builtins.diagnostics.pylint.with({
            prefer_local = ".venv/bin",
          }),

          -- formatting
          null_ls.builtins.formatting.prettierd.with({
            env = {
              PRETTIERD_LOCAL_PRETTIER_ONLY = true,
            },
          }),
          require('none-ls.formatting.ruff'),

          -- code_actions
          require('none-ls.code_actions.eslint_d').with({
            env = {
              ESLINT_D_LOCAL_ESLINT_ONLY = true,
            },
          }),
          require('typescript.extensions.null-ls.code-actions'),
        },
      }

      -- this must be called *after* null_ls.setup
      require('mason-null-ls').setup {
        -- automatically detect which servers to install
        -- (based on which servers are set up via null-ls)
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      }
    end
  },

  -- [[ UI ]]
  -- better UI for lsp
  {
    'RishabhRD/nvim-lsputils',
    event = 'VeryLazy',
    dependencies = {
      { 'RishabhRD/popfix' },
    },
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] = require('lsputil.codeAction').code_action_handler
      vim.lsp.handlers['textDocument/references'] = require('lsputil.locations').references_handler
      vim.lsp.handlers['textDocument/definition'] = require('lsputil.locations').definition_handler
      vim.lsp.handlers['textDocument/declaration'] = require('lsputil.locations').declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] = require('lsputil.locations').typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] = require('lsputil.locations').implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] = require('lsputil.symbols').document_handler
      vim.lsp.handlers['workspace/symbol'] = require('lsputil.symbols').workspace_handler
    end
  },
  -- show lsp status updates on the bottom right corner
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    config = function()
      require('fidget').setup {}
    end
  },
}
