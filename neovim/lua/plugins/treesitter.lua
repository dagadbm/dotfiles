return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  dependencies = {
    { 'windwp/nvim-ts-autotag', opts = {} },
  },
  build = ':TSUpdate',
  opts = {
    -- install missing treesitter automatically per buffer
    auto_install = true,
    -- modules
    highlight = { enable = true },
    -- treesitter indentation is not stable at all
    indent = { enable = false },
    incremental_selection = {
      enable = true,
      -- mappings for incremental selection (visual mappings)
      keymaps = {
        -- maps in normal mode to init the node/scope selection
        init_selection = '<C-n>',
        -- increment to the upper named parent
        node_incremental = '<C-n>',
        -- decrement to the previous node
        node_decremental = '<C-p>'
      }
    },
  },
};
