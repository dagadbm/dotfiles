local M = {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPre',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'JoosepAlviste/nvim-ts-context-commentstring' },
    { 'RRethy/nvim-treesitter-textsubjects' },
    { 'windwp/nvim-ts-autotag' },
  },
  build = ':TSUpdate',
}

function M.config()
  -- external modules config
  local refactor = {
    highlight_definitions = {
      enable = true
    },
    highlight_current_scope = {
      enable = false
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = 'grr' -- mapping to rename reference under cursor
      }
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gd', -- mapping to go to definition of symbol under cursor
        list_definitions = 'gD' -- mapping to list all definitions in current file
      }
    }
  }

  local autotag = {
    enable = true,
  }

  -- from andymass/vim-matchup plugin
  local matchup = {
    enable = true,
  }

  require('nvim-treesitter.configs').setup {
    -- install missing treesitter automatically per buffer
    auto_install = true,

    -- modules
    highlight = { enable = true },
    -- treesitter indentation is not stable at all
    indent = { enable = false },
    incremental_selection = {
      enable = true,
      keymaps = { -- mappings for incremental selection (visual mappings)
        init_selection = '<C-n>', -- maps in normal mode to init the node/scope selection
        node_incremental = '<C-n>', -- increment to the upper named parent
        node_decremental = '<C-p>' -- decrement to the previous node
      }
    },

    -- external modules
    refactor = refactor,
    textsubjects = textsubjects,
    autotag = autotag,
    matchup = matchup,
  }
end

return M
