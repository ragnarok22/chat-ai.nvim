local M = {}
local config = require("ai_chat.config")

local chat_buf = nil
local chat_win = nil

function M.create_chat_window()
	if chat_win and vim.api.nvim_win_is_valid(chat_win) then
		vim.api.nvim_set_current_win(chat_win)
		return
	end

	local width = math.floor(vim.o.columns * config.user_config.window.width)
	local height = vim.o.lines - 3 -- leave some space for status line

	-- Create buffer
	chat_buf = vim.api.nvim_create_buf(false, true)

	-- Create window
	chat_win = vim.api.nvim_open_win(chat_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = vim.o.columns - width,
		row = 0,
		style = "minimal",
		border = "single",
	})

	-- Window settings
	vim.wo[chat_win].wrap = true
	vim.bo[chat_win].filetype = "markdown"
	vim.bo[chat_win].buftype = "nofile"

	-- Key mappings
	vim.api.nvim_buf_set_keymap(chat_buf, "n", "<CR>", ":lua require('ai_chat.chat_manager').send_message()<CR>", {
		noremap = true,
		silent = true,
	})

	vim.api.nvim_command("startinsert")
end

return M
