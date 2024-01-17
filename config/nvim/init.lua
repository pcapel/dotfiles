-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enables the experimental Lua module loader:
-- • overrides loadfile
-- • adds the lua loader using the byte-compilation cache
-- • adds the libs loader
-- • removes the default Neovim loader
vim.loader.enable()

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Local config (useful for customizing config on another machine which is not
-- transferable)
if vim.fn.filereadable(vim.fn.expand("~/.vimrc.local")) == 1 then
	vim.cmd([[source ~/.vimrc.local]])
end

local modules = {
	"core.globals",
	"core.options",
	"core.commands",
	"core.mappings",
	"plugins",
}

for _, module in ipairs(modules) do
	local ok, err = pcall(require, module)
	if not ok then
		print("issue with", module, "with error", err)
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
