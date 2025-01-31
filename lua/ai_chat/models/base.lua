local M = {}

function M.get_model(model_name)
	if model_name == "deepseek" then
		return require("ai_chat.models.deepseek")
	elseif model_name == "chatgpt" then
		return require("ai_chat.models.chatgpt")
	end
end

return M
