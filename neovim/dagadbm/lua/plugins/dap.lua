return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'nvim-neotest/nvim-nio',
      },
      opts = {},
    },
    'mxsdev/nvim-dap-vscode-js',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      automatic_setup = true,
    }
  end
}
