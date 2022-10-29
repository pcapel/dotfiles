local utils = require('../utils')

vim.cmd([[
func! AddToWatch()
  let word =expand("<cexpr>")
  call vimspector#AddWatch(word)
endfunction
]])

utils.generate_mappings(utils.n_no, {
  {'<leader>da', ':call vimspector#Launch()<CR>'},
  {'<leader>dx', ':call vimspector#Reset()<CR>'},
  {'<C-k>', ':call vimspector#StepOut()<CR>'},
  {'<C-l>', ':call vimspector#StepInto()<CR>'},
  {'<C-j>', ':call vimspector#StepOver()<CR>'},
  {'<leader>d_', ':call vimspector#Restart()<CR>'},
  {'<leader>dn', ':call vimspector#Continue()<CR>'},
  {'<leader>drc', ':call vimspector#RunToCursor()<CR>'},
  {'<leader>dh', ':call vimspector#ToggleBreakpoint()<CR>'},
  {'<leader>dX', ':call vimspector#ClearBreakpoints()<CR>'},
  {'<leader>d?', ':call AddToWatch()<CR>'},
})
