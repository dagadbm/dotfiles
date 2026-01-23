return {
  -- [[ Snippets ]]
  -- engine
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      -- snippets
      'honza/vim-snippets',
      'rafamadriz/friendly-snippets',
      'sdras/vue-vscode-snippets',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_snipmate').lazy_load()
      require('luasnip.loaders.from_lua').lazy_load()
      -- support for honza/vim-snippets
      require('luasnip').filetype_extend('all', { '_' })
    end
  },

  -- [[ Completion ]]
  -- engine
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'onsails/lspkind-nvim',
      'mgalliou/blink-cmp-tmux',
    },
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      keymap = {
        preset = 'super-tab',
        -- Match your existing nvim-cmp keybindings
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Esc>'] = { 'hide', 'fallback' },
        ['<Enter>'] = { 'select_and_accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },

      snippets = {
        preset = 'luasnip',
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'tmux', 'cmdline', },
        providers = {
          tmux = {
            module = 'blink-cmp-tmux',
          },
        },
      },

      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },

      completion = {
        documentation = {
          window = {
            border = 'rounded',
          },
        },
        -- https://cmp.saghen.dev/configuration/keymap.html#super-tab
        trigger = {
          show_in_snippet = false,
        },
        list = {
          selection = {
            auto_insert = true,
          },
        },
        ghost_text = {
          enabled = true,
          show_with_menu = false,
        },
        menu = {
          auto_show = true,
          border = 'rounded',
        },
      },
    },
  },
}
