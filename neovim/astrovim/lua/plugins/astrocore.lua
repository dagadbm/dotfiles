-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- https://docs.astronvim.com/recipes/sessions/
-- function for calculating the current session name
local get_session_name = function()
  local name = vim.fn.getcwd()
  local branch = vim.fn.system "git branch --show-current"
  if vim.v.shell_error == 0 then
    return name .. vim.trim(branch --[[@as string]])
  else
    return name
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      -- Configure core features of AstroNvim
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        autopairs = true, -- enable autopairs at start
        cmp = true, -- enable completion at start
        diagnostics = { virtual_text = true, virtual_lines = true }, -- diagnostic settings on startup
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
      },
      -- Configuration of treesitter features in Neovim
      treesitter = {
        highlight = true, -- enable/disable treesitter based highlighting
        indent = true, -- enable/disable treesitter based indentation
        auto_install = true, -- enable/disable automatic installation of detected languages
      },
      -- Configure project root detection, check status with `:AstroRootInfo`
      rooter = {
        -- automatically update working directory (update manually with `:AstroRoot`)
        autochdir = false,
        detector = {
          { ".git" },
          "lsp",
        },
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = false,
        underline = true,
      },
      -- passed to `vim.filetype.add`
      filetypes = {
        -- see `:h vim.filetype.add` for usage
        extension = {},
        filename = {},
        pattern = {},
      },
      -- vim options can be configured here
      options = {
        opt = { -- vim.opt.<key>
          relativenumber = true, -- sets vim.opt.relativenumber
          number = true, -- sets vim.opt.number
          spell = false, -- sets vim.opt.spell
          signcolumn = "yes", -- sets vim.opt.signcolumn to yes
          wrap = false, -- sets vim.opt.wrap
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        n = {
          -- update save dirsession mapping to get the correct session name
          ["<Leader>SS"] = {
            function() require("resession").save(get_session_name(), { dir = "dirsession" }) end,
            desc = "Save this dirsession",
          },
          -- update load dirsession mapping to get the correct session name
          ["<Leader>S."] = {
            function() require("resession").load(get_session_name(), { dir = "dirsession" }) end,
            desc = "Load current dirsession",
          },
        },
      },
      -- Configuration table of session options for AstroNvim's session management powered by Resession
      sessions = {
        -- Configure auto saving
        -- disable the auto-saving of directory sessions
        autosave = {
          cwd = false,
        },
      },
      autocmds = {
        -- https://docs.astronvim.com/recipes/sessions/#git-branch-specific-directory-sessions
        git_branch_sessions = {
          -- auto save directory sessions on leaving
          {
            event = "VimLeavePre",
            desc = "Save git branch directory sessions on close",
            callback = vim.schedule_wrap(function()
              if require("astrocore.buffer").is_valid_session() then
                require("resession").save(get_session_name(), { dir = "dirsession", notify = false })
              end
            end),
          },
          -- auto restore previous previous directory session, remove if necessary
          {
            event = "VimEnter",
            desc = "Restore previous directory session if neovim opened with no arguments",
            nested = true, -- trigger other autocommands as buffers open
            callback = function()
              -- Only load the session if nvim was started with no args
              if vim.fn.argc(-1) == 0 then
                -- try to load a directory session using the current working directory
                require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true })
              end
            end,
          },
        },
      },
    })
  end,
}
