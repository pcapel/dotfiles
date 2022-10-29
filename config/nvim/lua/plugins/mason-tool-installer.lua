local installer_present, installer = pcall(require, "mason-tool-installer")

if not installer_present then
	vim.notify("Failed to initialize Mason Tool Installer!")
	return
end

local M = {}

M.setup = function()
	installer.setup({

		-- a list of all tools you want to ensure are installed upon
		-- start; they should be the names Mason uses for each tool
		ensure_installed = {
			-- Null LS
			"actionlint",
			"codespell",
			"eslint_d",
			"prettierd",
			"shellcheck",
			"shfmt",
			"stylua",
			"yamllint",
			"black",
			"mypy",

			-- LSPs

			"ansible-language-server",
			"arduino-language-server",
			"bash-language-server",
			"clangd",
			"cmake-language-server",
			"css-lsp",
			"dockerfile-language-server",
			"elixir-ls",
			"elm-language-server",
			-- "erlang-ls",
			"eslint-lsp",
			-- "gopls",
			"html-lsp",
			"json-lsp",
			"lua-language-server",
			"prosemd-lsp",
			"pyright",
			"rust-analyzer",
			"sqlls",
			"tailwindcss-language-server",
			"taplo",
			"terraform-ls",
			"typescript-language-server",
			"vim-language-server",
			"yaml-language-server",
			"zls",
		},
	})
end

return M
