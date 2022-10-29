local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local opt = vim.opt  -- to set options

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path}
end

-- Installations
require 'paq' {
  -- Org Mode like document editing for NeoVim
  'nvim-neorg/neorg';
  -- Collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig';
  -- Autocompletion plugin
  'hrsh7th/nvim-cmp';
  -- LSP source for nvim-cmp
  'hrsh7th/cmp-nvim-lsp';
  -- Snippets source for nvim-cmp
  'saadparwaiz1/cmp_luasnip';
  -- Snippets plugin
  'L3MON4D3/LuaSnip';
  -- Let Paq manage itself
  'savq/paq-nvim';
  -- for developing my own plugins
  'nvim-lua/plenary.nvim';

  -- Lua development helpers for autocompletion?
  -- TODO: ensure this is configured properly
  'tjdevries/nlua.nvim';
  -- helpers for making your own colorschemes
  'tjdevries/colorbuddy.nvim';
  -- Better syntax highlighting for Lua
  'euclidianAce/BetterLua.vim';

  -- I need treesitter enabled color schemes to be happy
  'bluz71/vim-nightfly-guicolors';
  -- And some line customization
  'nvim-lualine/lualine.nvim';
  -- Make some things work with my line
  'kyazdani42/nvim-web-devicons';

  -- required to work with treesitter
  'nvim-treesitter/nvim-treesitter';

  -- useful for determining the treesitter
  -- values that will work in queries
  'nvim-treesitter/playground';

  -- This is how I get ctrl-b/ctrl-p
  -- file movements with fuzzy finding
  -- I use this a LOT
  {'junegunn/fzf', run=fn['fzf#install']};
  'junegunn/fzf.vim';
  'ojroques/nvim-lspfuzzy';

  -- I really like vinegar for moving around code bases
  -- Like, I really can't live without it.
  -- It's basically the top of my list to re-implement in lua
  -- The feature that I would really love to have is to have
  -- the rendered files be ordered by MRU. This way I don't have to do anything
  -- to get to things that I have recently worked on.
  'tpope/vim-vinegar';
  -- Allows the Git commands that I like to use
  'tpope/vim-fugitive';
  -- Adds configurable projections, like are used in the vim-rails
  -- plugin, but I can configure global and local heuristics for :A
  'tpope/vim-projectionist';
  -- Vim rails is huge, and it has some things that I like, and some that I
  -- don't, but I want to keep the things I like
  'tpope/vim-rails';

  -- Let's get oxidized
  'rust-lang/rust.vim';
  'simrat39/rust-tools.nvim';

  -- JSX was ugly
  'MaxMEllon/vim-jsx-pretty';

  -- Focused windows for maintaining contexts across files
  'hoschi/yode-nvim';
  -- GOTTA GO FAST
  'ggandor/lightspeed.nvim';
  -- Code formatting
  'sbdchd/neoformat';
  -- Possible replacement for commentary
  -- Treesitter aware and maybe better with filetypes?
  'numToStr/Comment.nvim';
  -- This is the equivalent to tslime.vim, but it works for the use of kitty
  -- TODO: configure it to use kitty and look into language configurations
  'jpalardy/vim-slime';
  -- This should function roughly like the turbux plugin, but will likely
  -- support more complex things
  -- They say that there is 0 configuration required. We'll see  :P
  'vim-test/vim-test';
  -- This will allow me to have more intuitive navigation
  -- Although I will probably work on my own hotkeys and bindings based on the
  -- kitty @ approach.
  'knubie/vim-kitty-navigator';

  -- Debugger for Vim
  'puremourning/vimspector';
}
--

-- Plugins Setup
-- hoschi/yode-nvim
require('yode-nvim').setup({})

-- numToStr/Comment.nvim
require('Comment').setup({
  ignore = '^$'
})

-- jpalardy/vim-slime
-- also required changes to kitty.conf
vim.g.slime_target = "kitty"

-- nvim-neorg/neorg
require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.journal"] = {
      config = {
        workspace = 'self',
        strategy = 'flat'
      }
    },
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          hashrocket = "~/workspaces/hashrocket/",
          self = "~/workspaces/self/",
        }
      }
    }
  }
}
