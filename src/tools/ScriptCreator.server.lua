-- src/tools/ScriptCreator.server.lua

local ScriptCreator = {}
ScriptCreator.Name = "ScriptCreator"
ScriptCreator.Description = "Creates a new script and inserts it into a specified object."
ScriptCreator.Arguments = {
    { Name = "Parent", Type = "string", Description = "The name of the object to parent the script to." },
    { Name = "Name", Type = "string", Description = "The name of the script." },
    { Name = "Source", Type = "string", Description = "The source code of the script." }
}

function ScriptCreator.Execute(args)
    local parent = workspace:FindFirstChild(args.Parent, true)
    if parent then
        local script = Instance.new("Script")
        script.Name = args.Name or "NewScript"
        script.Source = args.Source or ""
        script.Parent = parent
        return "Created a new script named '" .. script.Name .. "' in '" .. parent.Name .. "'."
    else
        return "Error: Parent object not found."
    end
end

return ScriptCreator
