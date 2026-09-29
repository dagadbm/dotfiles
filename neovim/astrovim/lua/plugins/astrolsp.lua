-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      -- Configuration table of features provided by AstroLSP
      features = {
        codelens = false, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = true, -- enable/disable semantic token highlighting
        signature_help = true, -- enable automatic signature help popup globally on startup
      },
      -- customize lsp formatting options
      formatting = {
        -- control auto formatting on save
        format_on_save = {
          enabled = false, -- enable or disable format on save globally
          allow_filetypes = { -- enable format on save for specified filetypes only
          },
          ignore_filetypes = { -- disable format on save for specified filetypes
          },
        },
        disabled = { -- disable formatting capabilities for the listed language servers
          -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        },
        timeout_ms = 1000, -- default format timeout
        -- filter = function(client) -- fully override the default formatting function
        --   return true
        -- end
      },
      -- enable servers that you already have installed without mason
      servers = {
        -- "pyright"
      },
      -- customize language server configuration passed to `vim.lsp.config`
      -- client specific configuration can also go in `lsp/` in your configuration root (see `:h lsp-config`)
      config = {
        -- ["*"] = { capabilities = {} }, -- modify default LSP client settings such as capabilities
      },
      -- customize how language servers are attached
      handlers = {
        -- a function with the key `*` modifies the default handler, functions takes the server name as the parameter
        -- ["*"] = function(server) vim.lsp.enable(server) end

        -- the key is the server that is being setup with `vim.lsp.config`
        -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      },
      -- Configure buffer local auto commands to add when attaching a language server
      autocmds = {
        -- first key is the `augroup` to add the auto commands to (:h augroup)
        -- https://docs.astronvim.com/recipes/advanced_lsp/#automatic-signature-help
        no_insert_inlay_hints = {
          -- only create for language servers that support inlay hints
          cond = "textDocument/inlayHint",
          {
            -- when going into insert mode
            event = "InsertEnter",
            desc = "disable inlay hints on insert",
            callback = function(args)
              local filter = { bufnr = args.buf }
              -- if the inlay hints are currently enabled
              if vim.lsp.inlay_hint.is_enabled(filter) then
                -- disable the inlay hints
                vim.lsp.inlay_hint.enable(false, filter)
                -- create a single use autocommand to turn the inlay hints back on
                -- when leaving insert mode
                vim.api.nvim_create_autocmd("InsertLeave", {
                  buffer = args.buf,
                  once = true,
                  callback = function() vim.lsp.inlay_hint.enable(true, filter) end,
                })
              end
            end,
          },
        },
        -- mappings to be set up on attaching of a language server
        mappings = {},
      },
    })
  end,
}
