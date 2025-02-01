local M = {}
local ui = require("ai_chat.ui")
local models = require("ai_chat.models")

local current_model = nil
local DEFAULT_MODEL = "chatgpt"

function M.start_chat(model_name)
	current_model = models.get_model(model_name or DEFAULT_MODEL)
	ui.create_chat_window()
end

function M.send_message()
	local buf = vim.api.nvim_get_current_buf()
	local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	local last_user_input = nil
	for i = #all_lines, 1, -1 do
		if all_lines[i]:find("## Question") then
			last_user_input = i + 1
			break
		end
	end

	local new_lines = {}

	if last_user_input then
		new_lines = vim.list_slice(all_lines, last_user_input, #all_lines)
	else
		new_lines = all_lines
	end

	-- Clean just the last user input
	vim.api.nvim_buf_set_lines(buf, last_user_input or 0, -1, false, {})

	-- Build history
	local full_history = {}
	if last_user_input then
		full_history = vim.list_slice(all_lines, 0, last_user_input - 1)
	end

	local response = current_model.query_sync(new_lines)
	if not response then
		vim.api.nvim_buf_set_lines(buf, -2, -1, false, {
			"## Error",
			"",
			"Failed to get response from model",
			"",
			"## Question",
			"",
		})
	end

	local content = response.choices[1].message.content

	vim.schedule(function()
		local response_lines = vim.split(content, "\n")
		vim.api.nvim_buf_set_lines(buf, -2, -1, false, {
			"## Response (" .. os.date("%H:%M") .. ")",
			"",
			table.concat(response_lines, "\n"),
			"",
			"## Question",
			"",
		})

		-- Set cursor to the end
		vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
	end)

	-- Add new question and answer
	vim.list_extend(full_history, new_lines)
	table.insert(full_history, "")

	-- Update all the buffer preserving the history
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, full_history)

	-- Set cursor to the end
	vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
	vim.cmd("startinsert")
end

return M
