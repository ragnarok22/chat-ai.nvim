local M = {}

M.deepseek = require("ai_chat.models.deepseek")
M.chatgpt = require("ai_chat.models.chatgpt")

function M.get_model(model_name)
	if model_name == "deepseek" then
		return M.deepseek
	elseif model_name == "chatgpt" then
		return M.chatgpt
	end

	error("Unknown model: " .. model_name)
end

return M
