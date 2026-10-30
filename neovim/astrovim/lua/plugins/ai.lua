local cmd = {
  prompt = function()
    require("sidekick.cli").prompt {
      cb = function(_, text)
        if text then require("sidekick.cli").send { text = text, filter = { installed = true } } end
      end,
    }
  end,

  select = function() require("sidekick.cli").select { filter = { installed = true }, focus = true } end,

  close = function() require("sidekick.cli").close { filter = { attached = true, terminal = true } } end,

  run = function(args)
    args = args or {}
    local state = function() return require "sidekick.cli.state" end
    local session = vim.iter(state().get { terminal = true }):find(function(s)
      ---@cast s sidekick.cli.State
      return s.session and not s.external
    end)
    if not session then return require("sidekick.cli").select { filter = { installed = true }, focus = true } end
    if args.action then require("sidekick.cli")[args.action] { filter = { terminal = true }, focus = args.focus } end
    if args.msg then require("sidekick.cli").send { msg = args.msg, filter = { terminal = true } } end
  end,
}

---@type LazySpec
return {
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
                ["<Leader>a"] = { desc = "󰚩 Sidekick" },
                ["<Leader>aa"] = {
                  function() cmd.run { action = "toggle", focus = true } end,
                  desc = "Sidekick Toggle CLI",
                },
                ["<Leader>as"] = { cmd.select, desc = "Select CLI" },
                ["<Leader>ac"] = { cmd.close, desc = "Close a CLI Session" },
                ["<Leader>at"] = { function() cmd.run { msg = "{this}", focus = false } end, desc = "Send This" },
                ["<Leader>af"] = { function() cmd.run { msg = "{file}", focus = false } end, desc = "Send File" },
                ["<Leader>ap"] = { cmd.prompt, desc = "Select Prompt" },
                ["<C-.>"] = { function() cmd.run { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
              },
              x = {
                ["<Leader>a"] = { desc = "󰚩 Sidekick" },
                ["<Leader>at"] = { function() cmd.run { msg = "{this}", focus = false } end, desc = "Send This" },
                ["<Leader>av"] = {
                  function() cmd.run { msg = "{selection}", focus = false } end,
                  desc = "Send Visual Selection",
                },
                ["<Leader>ap"] = { cmd.prompt, desc = "Select Prompt" },
                ["<C-.>"] = { function() cmd.run { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
              },
              i = {
                ["<C-.>"] = { function() cmd.run { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
              },
              t = {
                ["<C-.>"] = { function() cmd.run { action = "toggle", focus = true } end, desc = "Sidekick Toggle" },
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
        prompts = {
          neovim_skill = "@" .. vim.fn.stdpath "config" .. "/lua/plugins/ai-neovim-skill.md",
        },
        tools = {
          claude_haiku = {
            cmd = { "zsh", "-ic", "claude --model haiku --effort low" },
            native_scroll = true,
          },
          claude_fzf = {
            cmd = { "zsh", "-ic", "c" },
            native_scroll = true,
          },
          claude_fzf_resume = {
            cmd = { "zsh", "-ic", "c r" },
            native_scroll = true,
          },
        },
      },
    },
  },
}
