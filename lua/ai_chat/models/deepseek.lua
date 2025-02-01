local M = {}
local config = require("ai_chat.config")

-- @param messages: array of strings
function M.query_sync(messages)
	-- TODO: Implement actual API call here
	return "This is a dummy response from DeepSeek"
end

-- @param messages: array of strings
-- @param callback: function(error, response)
function M.query_async(messages, callback)
	-- TODO: Implement actual API call here
	callback(nil, "This is a dummy response from DeepSeek")
end

return M
