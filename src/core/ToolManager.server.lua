-- src/core/ToolManager.server.lua

local ToolManager = {}

local toolsFolder = script.Parent.Parent.tools
local tools = {}

function ToolManager.loadTools()
    for _, toolModule in ipairs(toolsFolder:GetChildren()) do
        if toolModule:IsA("ModuleScript") then
            local tool = require(toolModule)
            tools[tool.Name] = tool
        end
    end
end

function ToolManager.getTools()
    return tools
end

function ToolManager.executeTool(toolName, args)
    if tools[toolName] and tools[toolName].Execute then
        local validationError = ToolManager.validateArgs(tools[toolName], args)
        if validationError then
            return "Error: " .. validationError
        end
        local success, result = pcall(tools[toolName].Execute, args)
        if success then
            return result
        else
            return "Error executing tool: " .. tostring(result)
        end
    else
        return "Error: Tool not found."
    end
end

function ToolManager.validateArgs(tool, args)
    for _, argDef in ipairs(tool.Arguments) do
        if not args[argDef.Name] then
            return `Missing argument '${argDef.Name}' for tool '${tool.Name}'.`
        end
        if type(args[argDef.Name]) ~= argDef.Type then
            -- This is a basic type check. A more robust solution would be needed for complex types.
            -- For now, we'll just check for the existence of the argument.
        end
    end
    return nil
end


return ToolManager
