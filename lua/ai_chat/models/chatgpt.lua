local M = {}
local config = require("ai_chat.config")

function M.query_sync(messages)
	local api_key = config.user_config.models.chatgpt.api_key
	local endpoint = config.user_config.models.chatgpt.endpoint
	local model = config.user_config.models.chatgpt.model

	-- Convert messages to [{"role": "user": "content": messages}]
	local formatted_messages = {}
	for _, message in ipairs(messages) do
		table.insert(formatted_messages, { role = "user", content = message })
	end

	local cmd = string.format(
		[[curl -s -X POST "%s" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer %s" \
		-d '%s']],
		endpoint,
		api_key,
		vim.fn.json_encode({
			model = model,
			messages = formatted_messages,
			temperature = 0.7,
		})
	)

	local response = vim.fn.system(cmd)
	return vim.fn.json_decode(response)
end

function M.query_async(messages, callback)
	local uv = vim.loop
	local api_key = config.user_config.models.chatgpt.api_key
	local endpoint = config.user_config.models.chatgpt.endpoint
	local model = config.user_config.models.chatgpt.model

	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. api_key,
	}

	local req_body = vim.fn.json_encode({
		model = model,
		messages = messages,
		temperature = 0.7,
		stream = true, -- Opcional: para streaming
	})

	local client = uv.new_tcp()
	if not client then
		callback(nil, "Failed to create TCP client")
		return
	end

	client:connect("api.chatgpt.com", 443, function(err)
		if err then
			callback(nil, err)
			return
		end

		client:write("POST /v1/chat/completions HTTP/1.1\r\n" .. "Host: api.chatgpt.com\r\n" .. table.concat({
			"Content-Length: " .. #req_body,
			"Content-Type: application/json",
			"Authorization: Bearer " .. api_key,
		}, "\r\n") .. "\r\n\r\n" .. req_body)

		client:read_start(function(err, chunk)
			if err then
				client:close()
				callback(nil, err)
			elseif chunk then
				-- Procesar respuesta (necesitarías parsear HTTP y JSON)
				local json_str = chunk:match("{.+}")
				if json_str then
					local ok, response = pcall(vim.fn.json_decode, json_str)
					if ok then
						callback(response)
					else
						callback(nil, "JSON decode error")
					end
				end
				client:close()
			end
		end)
	end)
end

return M
