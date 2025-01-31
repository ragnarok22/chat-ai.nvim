local M = {}

local function send_request(prompt)
	print(prompt)
end

function M.start()
	-- Crear un buffer para el chat
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

	-- Configurar el buffer
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	-- Función para enviar el mensaje
	local function send_message()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local prompt = table.concat(lines, "\n")
		local response = send_request(prompt)
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Deepseek:", response })
	end

	-- Mapear una tecla para enviar el mensaje
	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		':lua require("deepseek_chat.chat").send_message()<CR>',
		{ noremap = true, silent = true }
	)

	-- Entrar en modo inserción automáticamente
	vim.api.nvim_command("startinsert")
end

return M
