-- src/core/AI.server.lua

local HttpService = game:GetService("HttpService")
local config = require(script.Parent.Parent.config)
local ToolManager = require(script.Parent.ToolManager)

local AI = {}

function AI.getCompletion(messages)
    ToolManager.loadTools()
    local tools = ToolManager.getTools()
    local systemPrompt = config.DEFAULT_PROMPT .. "\n\nAvailable tools:\n"

    for toolName, tool in pairs(tools) do
        systemPrompt = systemPrompt .. `- ${toolName}: ${tool.Description}\n`
        for _, arg in ipairs(tool.Arguments) do
            systemPrompt = systemPrompt .. `  - ${arg.Name} (${arg.Type}): ${arg.Description}\n`
        end
    end

    local fullMessages = {
        { role = "system", content = systemPrompt }
    }
    for _, msg in ipairs(messages) do
        table.insert(fullMessages, msg)
    end

    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. config.API_KEY
    }

    local body = {
        model = config.AI_MODEL,
        messages = fullMessages,
        max_tokens = config.MAX_TOKENS,
        temperature = config.TEMPERATURE
    }

    local success, response
    for i = 1, 3 do -- Retry up to 3 times
        success, response = pcall(function()
            return HttpService:RequestAsync({
                Url = config.API_ENDPOINT,
                Method = "POST",
                Headers = headers,
                Body = HttpService:JSONEncode(body),
                RequestType = Enum.HttpRequestType.Default,
                HttpContentType = Enum.HttpContentType.ApplicationJson,
                Timeout = 10 -- Add a 10-second timeout
            })
        end)
        if success and response.Success then
            break
        end
        wait(1)
    end

    if success and response.Success then
        local decodedResponse = HttpService:JSONDecode(response.Body)
        if decodedResponse and decodedResponse.choices and #decodedResponse.choices > 0 then
            local content = decodedResponse.choices[1].message.content
            return AI.handleResponse(content)
        else
            return "Error: Invalid response from AI service. " .. (decodedResponse and decodedResponse.error and decodedResponse.error.message or "")
        end
    else
        return "Error: Failed to get response from AI service. " .. (response and response.Body or tostring(response))
    end
end

function AI.handleResponse(response)
    -- Check for tool commands
    if string.sub(response, 1, string.len(config.TOOL_PREFIX)) == config.TOOL_PREFIX then
        local command = string.sub(response, string.len(config.TOOL_PREFIX) + 1)
        local parts = string.split(command, " ")
        local toolName = parts[1]
        local args = {}

        -- A more robust argument parser would be needed for complex arguments
        for i = 2, #parts do
            local argParts = string.split(parts[i], "=")
            if #argParts == 2 then
                args[argParts[1]] = argParts[2]
            end
        end

        return ToolManager.executeTool(toolName, args)
    else
        return response
    end
end

return AI
