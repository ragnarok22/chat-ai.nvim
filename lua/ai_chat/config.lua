local M = {}

-- @class AIChat.Config
-- @field models table<string, AIChat.Model>: List of available models
-- @field window table<string, AIChat.Window>: Window configuration

-- @class AIChat.Model
-- @field api_key string: API key for the model
-- @field endpoint string: API endpoint for the model
-- @field model "deepseek" or "chatgpt": Model name

-- @class AIChat.Window
-- @field width number: Width of the window
-- @field position string: Position of the window

M.defaul_config = {
	models = {
		deepseek = {
			api_key = nil,
			endpoint = "https://api.deepseek.com/chat/completions",
			model = "deepseek-chat",
		},
		chatgpt = {
			api_key = nil,
			endpoint = "https://api.openai.com/v1/chat/completions",
			model = "gpt-4",
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
