require("mason-nvim-dap").setup {
  -- automatically detect which servers to install
  -- (based on which servers are set up via null-ls)
  ensure_installed = nil,
  automatic_installation = true,
  automatic_setup = false,
}

-- this still needs to be installed and setup
-- chrome is a mess to work with:
-- https://github.com/jay-babu/mason-nvim-dap.nvim/issues/17
-- https://github.com/mxsdev/nvim-dap-vscode-js

