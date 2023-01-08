local M = {
  'williamboman/mason.nvim',
  event = 'BufReadPre',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'williamboman/mason-lspconfig.nvim',
    'jayp0521/mason-null-ls.nvim',
    'jayp0521/mason-nvim-dap.nvim',
    'neovim/nvim-lspconfig',
    'folke/neodev.nvim',
    'jose-elias-alvarez/typescript.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    -- plugins that need direct hook into lsp_config
    'SmiteshP/nvim-navic',
  },
}

function M.config()
  require('mason').setup {}
  require('mason-tool-installer').setup {
    auto_update = true,
    run_on_start = true,
  }

  -- [[ LSP CONFIG ]]
  require('mason-lspconfig').setup {
    -- automatically detect which servers to install
    -- (based on which servers are set up via lspconfig)
    automatic_installation = true,
  }

  -- this sets up tsserver under the hood
  require('typescript').setup {}
  -- this sets up neovim lua development under the hood
  require('neodev').setup {}

  local lsp_servers = {
    -- front-end
    html = {},
    cssls = {},
    volar = {},
    eslint = {},
    stylelint_lsp = {},
    -- setup by typescript.nvim
    -- tsserver = {},
    tailwindcss = {},
    -- back-end
    gopls = {},
    pyright = {},
    pylsp = {},
    jedi_language_server = {},
    -- markup
    yamlls = {},
    jsonls = {},
    -- misc
    bashls = {},
    sumneko_lua = {},
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

  -- [[ NULL LS ]]
  -- setup formatters / linters
  local null_ls = require('null-ls')
  null_ls.setup {
    sources = {
      -- diagnostics
      null_ls.builtins.diagnostics.stylelint,

      null_ls.builtins.diagnostics.eslint_d.with({
        env = {
          ESLINT_D_LOCAL_ESLINT_ONLY = true,
        },
      }),

      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.pylint,

      -- formatting
      null_ls.builtins.formatting.prettierd.with({
        env = {
          PRETTIERD_LOCAL_PRETTIER_ONLY = true,
        },
      }),

      -- code_actions
      null_ls.builtins.code_actions.eslint_d.with({
        env = {
          ESLINT_D_LOCAL_ESLINT_ONLY = true,
        },
      }),
    }
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

return M
