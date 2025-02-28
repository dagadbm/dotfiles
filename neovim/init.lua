require('config.options')
require('lazy.init')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('config.autocmds')
    require('config.commands')
    require('config.mappings')
  end,
})
