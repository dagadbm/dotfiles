utils = {}

--[[
  Vimscript automatically escapes termcodes like \<C-n>
  This does the same thing
]]
function utils.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function utils.map(mode, key, binding, opts)
  local options = {
    silent = true,
    noremap = true,
  }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, binding, options)
end

return utils
