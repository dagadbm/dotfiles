---@type LazySpec
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      view_options = { show_hidden = true },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["-"] = { "<Cmd>Oil<CR>", desc = "Open parent directory" },
              },
            },
          })
        end,
      },
    },
  },
  {
    "folke/sidekick.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local sidekick_cli = function() return require "sidekick.cli" end

          local function cli(args)
            args = args or {}
            local state = function() return require "sidekick.cli.state" end
            local filter = { name = "claude", terminal = true }
            if #state().get(vim.tbl_extend("force", filter, { attached = true })) > 0 then
              if args.action then sidekick_cli()[args.action] { filter = filter } end
            else
              local session = vim.iter(state().get { name = "claude" }):find(function(s) return not s.external end)
              if session then state().attach(session, { show = true, focus = args.focus }) end
            end
            if args.msg then sidekick_cli().send { msg = args.msg, filter = filter } end
          end

          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["<Leader>a"] = { desc = require("astroui").get_icon("Sidekick", 1, true) .. "Sidekick" },
                ["<Leader>aa"] = {
                  function() cli { action = "toggle", focus = true } end,
                  desc = "Sidekick Toggle CLI",
                },
                ["<Leader>as"] = { function() cli { action = "show", focus = true } end, desc = "Select CLI" },
                ["<Leader>ac"] = {
                  function() sidekick_cli().close { name = "claude" } end,
                  desc = "Close a CLI Session",
                },
                ["<Leader>at"] = { function() cli { msg = "{this}", focus = false } end, desc = "Send This" },
                ["<Leader>af"] = { function() cli { msg = "{file}", focus = false } end, desc = "Send File" },
                ["<Leader>ap"] = { function() sidekick_cli().prompt() end, desc = "Select Prompt" },
                ["<C-.>"] = { function() cli { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
              },
              x = {
                ["<Leader>a"] = { desc = require("astroui").get_icon("Sidekick", 1, true) .. "Sidekick" },
                ["<Leader>at"] = { function() cli { msg = "{this}", focus = false } end, desc = "Send This" },
                ["<Leader>av"] = {
                  function() cli { msg = "{selection}", focus = false } end,
                  desc = "Send Visual Selection",
                },
                ["<Leader>ap"] = { function() sidekick_cli().prompt {} end, desc = "Select Prompt" },
                ["<C-.>"] = { function() cli { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
              },
              i = { ["<C-.>"] = { function() cli { action = "toggle", focus = true } end, desc = "Sidekick Toggle" } },
              t = { ["<C-.>"] = { function() cli { action = "toggle", focus = true } end, desc = "Sidekick Toggle" } },
            },
          })
        end,
      },
    },
    opts = {
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          enabled = false,
        },
        tools = {
          claude = {
            cmd = { "zsh", "-ic", "claude --model haiku --effort low" },
            native_scroll = true,
          },
        },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewLog",
    },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function() vim.opt_local.wrap = true end,
      },
      view = {
        merge_tool = {
          layout = "diff1_plain",
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["<Leader>gD"] = { "<Cmd>DiffviewOpen<CR>", desc = "Git diffview" },
              },
            },
          })
        end,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
