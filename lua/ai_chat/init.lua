local M = {}
local chat_manager = require("ai_chat.chat_manager")

M.chat_manager = chat_manager
M.models = require("ai_chat.models")

vim.notify("Plugin cargado corectamente", vim.log.levels.INFO)

function M.setup(user_config)
	require("ai_chat.config").setup(user_config)

	-- Create commands
	vim.api.nvim_create_user_command("AIChat", function()
		chat_manager.start_chat()
	end, {})
end

return M
