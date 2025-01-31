local M = {}

M.defaul_config = {
	models = {
		deepseek = {
			api_key = nil,
			endpoint = "https://api.deepseek.com/v1/chat",
		},
		chatgpt = {
			api_key = nil,
			endpoint = "https://api.openai.com/v1/chat",
		},
	},
	window = {
		width = 0.4, -- 40% of Neovim width
		position = "right",
	},
}

M.user_config = {}

function M.setup(user_config)
	local user_options = user_config or {}

	if type(user_options) ~= "table" then
		error("Configuration must be a table, got: " .. type(user_options))
	end

	M.user_config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaul_config), user_options)
end

return M
