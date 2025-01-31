local M = {}
local ui = require("ai_chat.ui")
local models = require("ai_chat.models")

local current_model = nil
local chat_history = {}
local DEFAULT_MODEL = "chatgpt"

function M.start_chat(model_name)
	current_model = models.get_model(model_name or DEFAULT_MODEL)
	ui.create_chat_window()
end

function M.send_message()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local prompt = table.concat(lines, "\n")

	-- Add user question to history
	table.insert(chat_history, {
		role = "user",
		content = prompt,
	})

	-- Clear input area
	vim.api.nvim_buf_set_lines(0, -2, -1, false, {})

	-- Add question to chat display
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { "## Question", prompt, "" })

	-- TODO: For now, just echo the question - implement model response later
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { "## Response", "Response placeholder", "" })
end

return M
