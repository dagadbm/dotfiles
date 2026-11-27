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
    "mason-org/mason.nvim",
    -- project binaries (mise, .venv/bin) win over mason's
    opts = { PATH = "append" },
  },
  {
    "folke/which-key.nvim",
    -- default no_overlap shrinks the popup to nothing when the cursor sits near the bottom
    opts = { win = { no_overlap = false } },
  },
  {
    "rebelot/heirline.nvim",
    -- keep AstroNvim's default winbar, only prefix the active window's breadcrumbs
    -- with the file path relative to the project root (inactive windows unchanged)
    opts = function(_, opts)
      local status = require "astroui.status"
      local rooter = require "astrocore.rooter"
      local breadcrumbs = opts.winbar[2]
      opts.winbar[2] = {
        status.component.separated_path {
          max_depth = 0,
          path_func = function(self)
            local bufnr = self.bufnr or 0
            local file = rooter.bufpath(bufnr)
            if not file then return "" end -- unnamed buffer: bufpath returns nil
            local root = (rooter.detect(bufnr)[1] or { paths = { vim.uv.cwd() } }).paths[1]
            return (vim.fn.fnamemodify(file, ":h"):gsub("^" .. vim.pesc(root) .. "/?", ""))
          end,
        },
        status.component.file_info {
          file_icon = { padding = { left = 0 } },
          filename = {},
          filetype = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbar", true),
          surround = false,
          update = { "BufEnter", "BufFilePost" },
        },
        breadcrumbs,
      }
    end,
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
