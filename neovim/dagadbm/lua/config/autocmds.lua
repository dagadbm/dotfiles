-- auto refresh files
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, { command = [[:checktime]] })

-- Change vim backupfile name: filename@2000-01-01.00:00
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[let &bex = '@' .. strftime("%F_%H:%M")]],
})
