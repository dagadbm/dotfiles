return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  -- dock cmdline to bottom like classic vim instead of floating popup
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
    },
  },
  -- automatically load previous session on startup
  {
    "folke/persistence.nvim",
    opts = {},
    init = function()
      vim.schedule(function()
        require("persistence").load()
      end)
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
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
    },
  },
}
