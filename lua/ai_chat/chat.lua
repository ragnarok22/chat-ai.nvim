local M = {}

function M.start()
	-- Create a buffer for chat
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 80,
		height = 20,
		col = 10,
		row = 10,
		style = "minimal",
		border = "single",
	})

	-- Buffer settings
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	-- Send message
	local function send_message()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local prompt = table.concat(lines, "\n")
		local response = send_request(prompt)
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Deepseek:", response })
	end

	-- Map enter key to send message
	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		':lua require("deepseek_chat.chat").send_message()<CR>',
		{ noremap = true, silent = true }
	)

	vim.api.nvim_command("startinsert")
end

return M
