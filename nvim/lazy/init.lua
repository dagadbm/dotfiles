local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
  vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  -- reference: https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
  defaults = { lazy = true, version = '*' },
  lockfile = vim.fn.expand('~/.config/nvim/lua/lazy/lazy-lock.json'),
  concurrency = nil,
  install = { missing = true, colorscheme = { 'onedark' } },
  checker = { enabled = false },
  diff = {
    cmd = 'terminal_git',
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
