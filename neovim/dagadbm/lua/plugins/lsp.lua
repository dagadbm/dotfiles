return {
  -- [[ LSP Setup ]]
  {
    'williamboman/mason.nvim',
    dependencies = {
      'RubixDev/mason-update-all',
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'neovim/nvim-lspconfig',
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      'pmizio/typescript-tools.nvim',
      {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        init = function()
          vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
        end,
      },
      'zapling/mason-conform.nvim',
      {
        'mfussenegger/nvim-lint',
        event = { 'BufWritePre' },
      },
      'rshkarin/mason-nvim-lint',
    },
    config = function()
      -- this sets up tsserver under the hood
      require('typescript-tools').setup {}

      require('mason').setup {}
      require('mason-update-all').setup {}

      -- [[ LSP CONFIG ]]
      -- Configure individual LSP servers
      local lsp_servers = {
        -- front-end
        'html',
        'cssls',
        'vue_ls',
        'eslint',
        'stylelint_lsp',
        -- setup done by pmizio/typescript-tools.nvim
        -- 'ts_ls',
        'tailwindcss',
        -- back-end
        'gopls',
        'pyright',
        -- markup
        'yamlls',
        'jsonls',
        -- misc
        'bashls',
        'lua_ls',
      }

      -- Enable all configured servers
      vim.lsp.enable(lsp_servers)

      -- LspAttach autocmd for setting up custom LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(args)
          require('config.mappings').lsp_mappings(args.buf)
        end,
      })

      require('mason-lspconfig').setup {
        automatic_installation = true,
      }

      -- [[ FORMATTERS ]]
      require('conform').setup {
        format_on_save = nil,
        formatters_by_ft = {
          lua = { 'stylua' },
          sh = { 'shfmt' },
          python = { 'isort', 'black' },

          -- prettier
          css = { 'prettierd' },
          graphql = { 'prettierd' },
          handlebars = { 'prettierd' },
          html = { 'prettierd' },
          javascript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          json = { 'prettierd' },
          jsonc = { 'prettierd' },
          less = { 'prettierd' },
          markdown = { 'prettierd' },
          ['markdown.mdx'] = { 'prettierd' },
          scss = { 'prettierd' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          vue = { 'prettierd' },
          yaml = { 'prettierd' },

          ['*'] = { 'codespell' },
          ['_'] = { 'trim_whitespace' },
        },
        formatters = {
          stylua = {
            indent_type = 'Spaces'
          },
          prettierd = {
            env = {
              PRETTIERD_LOCAL_PRETTIER_ONLY = 'true',
            },
          },
        },
      }

      require('mason-conform').setup {
        automatic_installation = true,
      }

      -- [[ LINTERS ]]
      require('lint').setup = {
        linters_by_ft = {
          javascript = { 'eslint_d' },
          typescript = { 'eslint_d' },
          javascriptreact = { 'eslint_d' },
          typescriptreact = { 'eslint_d' },
          vue = { 'eslint_d' },
          css = { 'stylelint' },
          scss = { 'stylelint' },
          python = { 'flake8', 'mypy', 'pylint' },
        },
        linters = {
          eslint_d = {
            env = {
              ESLINT_D_LOCAL_ESLINT_ONLY = 'true',
            },
          },
        }
      }

      require('mason-nvim-lint').setup {
        automatic_installation = true,
      }
    end
  },

  -- [[ UI ]]
  -- show lsp status updates on the bottom right corner
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
