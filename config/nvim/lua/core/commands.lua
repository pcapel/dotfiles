local cmd = vim.api.nvim_create_user_command
local utils = require("core.utils")

cmd("PrettyPrintJSON", "%!jq", {})
cmd("PrettyPrintXML", "!tidy -mi -xml -wrap 0 %", {})
cmd("PrettyPrintHTML", "!tidy -mi -xml -wrap 0 %", {})
cmd("BreakLineAtComma", ":normal! f,a<CR><esc>", {})
cmd("Retab", ":set ts=2 sw=2 et<CR>:retab<CR>", {})
cmd("CopyFullName", "let @+=expand('%')", {})
cmd("CopyPath", "let @+=expand('%:h')", {})
cmd("CopyFileName", "let @+=expand('%:t')", {})

cmd("RefreshJsonSchemas", utils.download_json_schemas, {})

cmd("ReloadModules", utils.reload_modules, {})

-- Iteration helpers
cmd("MyPlugins", "e ~/.config/nvim/lua/plugins/init.lua", {})

cmd("MyCommands", "e ~/.config/nvim/lua/core/commands.lua", {})
cmd("MyMappings", "e ~/.config/nvim/lua/core/mappings.lua", {})
cmd("MyOptions", "e ~/.config/nvim/lua/core/options.lua", {})

cmd("MyZsh", "e ~/.zshrc", {})
cmd("MyAliases", "e ~/.config/zsh/aliases.zsh", {})

cmd("MyTmux", "e ~/.config/tmux/tmux.conf", {})
