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
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
