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

	local processed_lines = {}
	for _, line in ipairs(lines) do
		local sub_lines = vim.split(line, "\n")
		vim.list_extend(processed_lines, sub_lines)
	end

	local prompt = table.concat(processed_lines, "\n")

	-- Clean up input area
	local input_start = #processed_lines - #lines + 1
	local input_end = #processed_lines
	vim.api.nvim_buf_set_lines(0, input_start, input_end, false, {})

	-- Add question to chat display
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { "## Question", unpack(processed_lines), "", "## Response", "..." })

	-- Keep final scroll
	vim.api.nvim_command("normal! G")
end

return M
