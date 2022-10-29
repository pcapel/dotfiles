require('external_plugins')
require('lsp_setup')
require('autocompletion_setup')

configured_plugins = {
  'evil_lualine',
  'vimspector'
}

for _,plugin in ipairs(configured_plugins) do
  require(string.format('plugin_config/%s', plugin))
end

local utils = require('utils')

-- Standard vim.opts
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.hidden = true                   -- Enable background buffers
vim.opt.ignorecase = true               -- Ignore case
vim.opt.joinspaces = false              -- No double spaces with join
vim.opt.list = true                     -- Show some invisible characters
vim.opt.number = true                   -- Show line numbers
vim.opt.scrolloff = 4                   -- Lines of context
vim.opt.shiftround = true               -- Round indent
vim.opt.shiftwidth = 2                  -- Size of an indent
vim.opt.sidescrolloff = 8               -- Columns of context
vim.opt.smartcase = true                -- Do not ignore case with capitals
vim.opt.smartindent = true              -- Insert indents automatically
vim.opt.splitbelow = true               -- Put new windows below current
vim.opt.splitright = true               -- Put new windows right of current
vim.opt.tabstop = 2                     -- Number of spaces tabs count for
vim.opt.termguicolors = true            -- True color support
vim.opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
vim.opt.wrap = false                    -- Disable line wrap
vim.opt.syntax = 'enable'
vim.opt.termguicolors = true
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

-- colorscheme installed in external plugins
vim.cmd 'colorscheme nightfly'

utils.generate_mappings(utils.n_no, {
  {';;', '<cmd>noh<CR>'},
  {'<up>', '10k'},
  {'<down>', '10j'},
  {'<s-up>', '25k'},
  {'<s-down>', '25j'},
  {'<silent><expr> <c-t>', ':TSPlaygroundToggle<CR>'},
  {'<C-b>', ':Buffers<CR>'},
  {'<C-p>', ':Files<CR>'},
  {'<leader>f', ':Neoformat<CR>'},
  {'<leader>gb', ':Git blame<CR>'},
  {'<leader>ww', ':bw<CR>'},
  {'<leader>qq', ':q!<CR>'},
  {'<C-J>', '<C-W><C-J>'},
  {'<C-K>', '<C-W><C-K>'},
  {'<C-L>', '<C-W><C-L>'},
  {'<C-H>', '<C-W><C-H>'},
  {'<silent> <leader>t', ':TestNearest<CR>'},
  {'<silent> <leader>T', ':TestFile<CR>'},
})

utils.generate_mappings(utils.v_no, {
  {'<up>', '10k'},
  {'<down>', '10j'},
  {'<s-up>', '25k'},
  {'<s-down>', '25j'},
  {'<C-S>', ':YodeCreateSeditorFloating<CR>'},
  -- yank to system buffer
  {'<leader>y', '"*y'},
})

vim.cmd([[
let test#strategy = "kitty"
]])
