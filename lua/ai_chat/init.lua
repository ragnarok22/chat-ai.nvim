local M = {}
local chat_manager = require("ai_chat.chat_manager")

function M.setup(user_config)
	require("ai_chat.config").setup(user_config)

	-- Create commands
	vim.api.nvim_create_user_command("AIChat", function()
		chat_manager.start_chat()
	end, {})
end

return M
