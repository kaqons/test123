-- src/tools/PropertyChanger.server.lua

local PropertyChanger = {}
PropertyChanger.Name = "PropertyChanger"
PropertyChanger.Description = "Changes a property of a specified object in the workspace."
PropertyChanger.Arguments = {
    { Name = "Object", Type = "string", Description = "The name of the object to modify." },
    { Name = "Property", Type = "string", Description = "The name of the property to change." },
    { Name = "Value", Type = "any", Description = "The new value for the property." }
}

function PropertyChanger.Execute(args)
    local object = workspace:FindFirstChild(args.Object, true)
    if object then
        local success, err = pcall(function()
            object[args.Property] = args.Value
        end)
        if success then
            return "Changed property '" .. args.Property .. "' of '" .. args.Object .. "' to '" .. tostring(args.Value) .. "'."
        else
            return "Error changing property: " .. err
        end
    else
        return "Error: Object not found."
    end
end

return PropertyChanger
