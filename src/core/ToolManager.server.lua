-- src/core/ToolManager.server.lua

local HttpService = game:GetService("HttpService")
local ArgumentHandler = require(script.Parent.ArgumentHandler)

local ToolManager = {}

local toolsFolder = script.Parent.Parent.tools
local tools = {}

function ToolManager.loadTools()
    if next(tools) ~= nil then return end -- Correct way to check if a dictionary-style table is not empty
    for _, toolModule in ipairs(toolsFolder:GetChildren()) do
        if toolModule:IsA("ModuleScript") then
            local success, tool = pcall(require, toolModule)
            if success and tool.Name then
                tools[tool.Name] = tool
            end
        end
    end
end

function ToolManager.getTools()
    return tools
end

function ToolManager.executeTool(toolName, args)
    if not tools[toolName] or not tools[toolName].Execute then
        return "Error: Tool '" .. tostring(toolName) .. "' not found."
    end

    local tool = tools[toolName]

    -- Use the ArgumentHandler to validate and convert the arguments
    local success, processedArgsOrError = ArgumentHandler.process(tool, args)

    if not success then
        return "Argument Error: " .. processedArgsOrError
    end

    -- Execute the tool with the correctly typed arguments
    local executeSuccess, result = pcall(tool.Execute, processedArgsOrError)

    if executeSuccess then
        return result
    else
        return "Error executing tool '" .. tool.Name .. "': " .. tostring(result)
    end
end

return ToolManager
