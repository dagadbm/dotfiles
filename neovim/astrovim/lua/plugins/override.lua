-- https://docs.astronvim.com/configuration/customizing_plugins/
---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        picker = {
          win = {
            input = {
              keys = {
                -- close pickers on Esc
                ["<Esc>"] = { "close", mode = { "n", "i" } },
              },
            },
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "folke/todo-comments.nvim",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        highlight = {
          before = "",
          keyword = "wide_fg",
          after = "",
        },
      })
    end,
  },
}
