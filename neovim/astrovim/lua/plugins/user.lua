---@type LazySpec
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      view_options = { show_hidden = true },
    },
  },
  {
    "folke/sidekick.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["<Leader>a"] = { desc = require("astroui").get_icon("Sidekick", 1, true) .. "Sidekick" },
                ["<Leader>aa"] = { function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
                ["<Leader>as"] = { function() require("sidekick.cli").select() end, desc = "Select CLI" },
                ["<Leader>ad"] = { function() require("sidekick.cli").close() end, desc = "Detach a CLI Session" },
                ["<Leader>at"] = { function() require("sidekick.cli").send { msg = "{this}" } end, desc = "Send This" },
                ["<Leader>af"] = { function() require("sidekick.cli").send { msg = "{file}" } end, desc = "Send File" },
                ["<Leader>ap"] = { function() require("sidekick.cli").prompt() end, desc = "Select Prompt" },
                ["<C-.>"] = { function() require("sidekick.cli").toggle {} end, desc = "Sidekick Toggle" },
              },
              x = {
                ["<Leader>a"] = { desc = require("astroui").get_icon("Sidekick", 1, true) .. "Sidekick" },
                ["<Leader>at"] = { function() require("sidekick.cli").send { msg = "{this}" } end, desc = "Send This" },
                ["<Leader>av"] = {
                  function() require("sidekick.cli").send { msg = "{selection}" } end,
                  desc = "Send Visual Selection",
                },
                ["<Leader>ap"] = { function() require("sidekick.cli").prompt {} end, desc = "Select Prompt" },
                ["<C-.>"] = { function() require("sidekick.cli").toggle {} end, desc = "Sidekick Toggle" },
              },
              i = {
                ["<C-.>"] = { function() require("sidekick.cli").toggle {} end, desc = "Sidekick Toggle" },
              },
              t = {
                ["<C-.>"] = { function() require("sidekick.cli").toggle {} end, desc = "Sidekick Toggle" },
              },
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
            cmd = { "zsh", "-ic", "c" },
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
        diff_buf_read = function()
          vim.opt_local.wrap = true
        end,
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
}
