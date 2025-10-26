-- src/core/AI.server.lua

local HttpService = game:GetService("HttpService")
local coreFolder = script.Parent
local srcFolder = coreFolder.Parent
local config = require(srcFolder:FindFirstChild("config"))
local ToolManager = require(coreFolder:FindFirstChild("ToolManager"))

local AI = {}

-- Helper to convert the chat history to Gemini's 'contents' format
local function formatMessagesForGemini(messages)
    local contents = {}
    for _, msg in ipairs(messages) do
        local role = (msg.role == "assistant") and "model" or "user"
        table.insert(contents, {
            role = role,
            parts = { { text = msg.content } }
        })
    end
    return contents
end

function AI.getCompletion(messages)
    -- ToolManager is now loaded from the Main server script
    local tools = ToolManager.getTools()

    -- Updated system prompt to request JSON for tool calls
    local systemInstructionText = config.DEFAULT_PROMPT ..
        "\n\nWhen you need to use a tool, respond ONLY with a JSON object in the following format: " ..
        "{\"toolName\": \"name_of_the_tool\", \"args\": {\"argName1\": \"value1\", \"argName2\": value2}}. " ..
        "Do not include any other text, just the JSON. Available tools:\n"

    for toolName, tool in pairs(tools) do
        systemInstructionText = systemInstructionText .. "- " .. toolName .. ": " .. tool.Description .. "\n"
        for _, arg in ipairs(tool.Arguments) do
            systemInstructionText = systemInstructionText .. "  - " .. arg.Name .. " (" .. arg.Type .. "): " .. arg.Description .. "\n"
        end
    end

    local body = {
        contents = formatMessagesForGemini(messages),
        systemInstruction = {
            parts = {
                { text = systemInstructionText }
            }
        },
        generationConfig = {
            temperature = config.TEMPERATURE,
            maxOutputTokens = config.MAX_OUTPUT_TOKENS,
        },
        thinkingConfig = config.THINKING_CONFIG
    }

    local url = config.API_ENDPOINT .. "?key=" .. config.API_KEY

    local success, response
    for i = 1, 3 do -- Retry up to 3 times
        success, response = pcall(function()
            return HttpService:RequestAsync({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(body),
                RequestType = Enum.HttpRequestType.Default,
                Timeout = 20
            })
        end)
        if success and response and response.Success then
            break
        end
        wait(1)
    end

    if success and response and response.Success then
        local decodedResponse = HttpService:JSONDecode(response.Body)
        if decodedResponse and decodedResponse.candidates and #decodedResponse.candidates > 0 then
            local candidate = decodedResponse.candidates[1]
            if candidate.content and candidate.content.parts and #candidate.content.parts > 0 then
                local content = candidate.content.parts[1].text
                return AI.handleResponse(content)
            else
                return "Error: AI response was empty. Finish reason: " .. tostring(candidate.finishReason)
            end
        else
            return "Error: Invalid response format from Gemini service. Body: " .. response.Body
        end
    else
        local errorMsg = "Error: Failed to get response from Gemini service."
        if response then
             errorMsg = errorMsg .. " Details: " .. response.Body
        else
            errorMsg = errorMsg .. " An unknown error occurred."
        end
        return errorMsg
    end
end

function AI.handleResponse(response)
    -- Attempt to decode the response as a JSON object for tool execution
    local success, decodedJson = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if success and type(decodedJson) == "table" and decodedJson.toolName and decodedJson.args then
        -- It's a valid tool call, execute it
        local toolName = decodedJson.toolName
        local args = decodedJson.args
        return ToolManager.executeTool(toolName, args)
    else
        -- Not a JSON tool call, so treat it as a regular text response
        return response
    end
end

return AI
