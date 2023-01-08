local M = {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPre',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
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

  local textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['is'] = '@statement.inner',
        ['as'] = '@statement.outer',
        ['am'] = '@call.outer',
      }
    },
    swap = {
      enable = true,
      swap_next = { ['gs'] = '@parameter.inner' },
      swap_previous = { ['gS'] = '@parameter.inner' }
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    }
  }

  local context_commentstring = {
    enable = true
  }

  local textsubjects = {
    enable = true,
    prev_selection = ',', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['.'] = 'textsubjects-smart',
      ['a;'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
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
    context_commentstring = context_commentstring,
    refactor = refactor,
    textobjects = textobjects,
    textsubjects = textsubjects,
    autotag = autotag,
    matchup = matchup,
  }
end

return M
