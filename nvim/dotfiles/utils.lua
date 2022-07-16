local M = {}

--[[
  Vimscript automatically escapes termcodes like \<C-n>
  This does the same thing
]]
function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.map(mode, key, binding, opts)
  local options = {
    silent = true,
    noremap = true,
  }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, binding, options)
end

return M
