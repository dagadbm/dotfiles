return {
  -- [[ AI Completion ]]
  {
    'milanglacier/minuet-ai.nvim',
    opts = {
      provider = 'claude',
      provider_options = {
        claude = {
          model = 'claude-3-5-sonnet-20241022',
          stream = true,
          max_tokens = 512,
          temperature = 0.7,
          api_key = 'ANTHROPIC_API_KEY',  -- Will read from environment variable
          end_point = 'https://api.anthropic.com/v1/messages',
        },
      },
      -- Configure virtual text appearance
      n_completions = 1,  -- Number of completions to generate
      auto_complete = true,  -- Automatically trigger completions
      debounce_delay = 500,  -- Milliseconds to wait before triggering (500ms = 0.5s)

      -- Default keymaps (can be disabled if you want custom ones)
        default_keymaps = true,
      },
    },

    -- [[ AI Chat & Refactoring ]]
    {
      'olimorris/codecompanion.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      config = function()
        require('codecompanion').setup({
            adapters = {
              anthropic = function()
                return require('codecompanion.adapters').extend('anthropic', {
                    env = {
                      api_key = 'ANTHROPIC_API_KEY',  -- Will read from environment variable
                    },
                    schema = {
                      model = {
                        default = 'claude-3-5-sonnet-20241022',
                      },
                    },
                  })
              end,
            },

            strategies = {
              -- Use Anthropic for chat
              chat = {
                adapter = 'anthropic',
              },
              -- Use Anthropic for inline transformations
              inline = {
                adapter = 'anthropic',
              },
              -- Use Anthropic for agent workflows
              agent = {
                adapter = 'anthropic',
              },
            },

            -- Display settings
            display = {
              chat = {
                window = {
                  layout = 'vertical',  -- or 'horizontal', 'float'
                  width = 0.4,  -- 40% of screen width
                  height = 0.8,  -- 80% of screen height
                },
                show_settings = true,  -- Show model/settings in chat
              },
              inline = {
                diff = {
                  enabled = true,
                  highlights = {
                    removed = 'DiffDelete',
                  },
                },
              },
            },

            -- Enable Claude Code support via Agent Client Protocol
            agent = {
              tools = {
                ['claude-code'] = {
                  enabled = true,
                },
              },
            },

            -- Support CLAUDE.md memory files
            opts = {
              memory = true,
            },
          })
      end,
    },
  }
