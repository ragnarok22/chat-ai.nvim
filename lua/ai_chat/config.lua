local M = {}

M.defaul_config = {
	models = {
		deepseek = {
			api_key = nil,
			endpoint = "https://api.deepseek.com/v1/chat",
		},
	},
	window = {
		width = 0.4, -- 40% of Neovim width
		position = "right",
	},
}

M.user_config = {}

function M.setup(user_config)
	M.user_config = vim.tbl_deep_extend("force", M.default_config, user_config or {})
end

return M
