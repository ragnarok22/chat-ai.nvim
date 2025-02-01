local M = {}
local config = require("ai_chat.config")

local state = {
	chat_buf = nil,
	chat_win = nil,
}

local function is_valid(bufnr)
	return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

local function set_keymaps()
	vim.api.nvim_buf_set_keymap(
		state.chat_buf,
		"n",
		"<CR>",
		":lua require('ai_chat.chat_manager').send_message()<CR>",
		{
			noremap = true,
			silent = true,
		}
	)

	vim.api.nvim_buf_set_keymap(state.chat_buf, "n", "q", '<cmd>lua require("ai_chat.ui").close_chat()<CR>', {
		noremap = true,
		silent = true,
	})
end

function M.create_chat_window()
	if state.chat_win and vim.api.nvim_win_is_valid(state.chat_win) then
		vim.api.nvim_set_current_win(state.chat_win)
		return state.chat_buf, state.chat_win
	end

	-- Create a new buffer if it doesn't exist
	if not is_valid(state.chat_buf) then
		state.chat_buf = vim.api.nvim_create_buf(false, true)

		vim.api.nvim_buf_set_lines(state.chat_buf, -2, -1, false, { "## Question:", "" })

		vim.api.nvim_set_option_value("filetype", "markdown", { buf = state.chat_buf })
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.chat_buf })
	end

	local width = math.floor(vim.o.columns * config.user_config.window.width)
	local height = vim.o.lines - 3 -- leave some space for status line

	-- Create window
	state.chat_win = vim.api.nvim_open_win(state.chat_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = vim.o.columns - width,
		row = 0,
		style = "minimal",
		border = "single",
	})

	-- Window settings
	vim.wo[state.chat_win].wrap = true
	vim.wo[state.chat_win].number = false
	vim.wo[state.chat_win].relativenumber = false

	-- Key mappings
	set_keymaps()

	vim.api.nvim_command("startinsert")

	-- Set cursor to the end
	vim.api.nvim_win_set_cursor(state.chat_win, { vim.api.nvim_buf_line_count(state.chat_buf), 0 })
	return state.chat_buf, state.chat_win
end

function M.close_chat()
	if state.chat_win and vim.api.nvim_win_is_valid(state.chat_win) then
		vim.api.nvim_win_close(state.chat_win, true)
		state.chat_win = nil
		state.chat_buf = nil
	end
end

return M
