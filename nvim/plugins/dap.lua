local M = {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    {
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require('nvim-dap-virtual-text').setup { }
      end
    },
    {
      'rcarriga/nvim-dap-ui',
      config = function()
        require('dapui').setup { }
      end
    },
    'mxsdev/nvim-dap-vscode-js',
  }
}

function M.config()
  require('mason-nvim-dap').setup {
    -- automatically detect which servers to install
    -- (based on which servers are set up via nvim-dap)
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
  }

  -- this still needs to be installed and setup
  -- chrome is a mess to work with:
  -- https://github.com/jay-babu/mason-nvim-dap.nvim/issues/17
  -- https://github.com/mxsdev/nvim-dap-vscode-js
end

return M
