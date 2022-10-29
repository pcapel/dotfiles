local utils = {}

local opt = vim.opt  -- to set options

function utils.map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function utils.n_no(lhs, rhs, opts)
  utils.map('n', lhs, rhs, opts)
end

function utils.v_no(lhs, rhs, opts)
  utils.map('v', lhs, rhs, opts)
end

function utils.i_no(lhs, rhs, opts)
  utils.map('i', lhs, rhs, opts)
end

function utils.generate_mappings(mapper, mappings)
  for _, mapping in ipairs(mappings) do
    mapper(unpack(mapping))
  end
end

return utils
