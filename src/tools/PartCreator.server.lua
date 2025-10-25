-- src/tools/PartCreator.server.lua

local PartCreator = {}
PartCreator.Name = "PartCreator"
PartCreator.Description = "Creates a new part in the workspace with the specified properties."
PartCreator.Arguments = {
    { Name = "Shape", Type = "string", Description = "The shape of the part (e.g., 'Block', 'Sphere', 'Cylinder')." },
    { Name = "Size", Type = "Vector3", Description = "The size of the part." },
    { Name = "Position", Type = "Vector3", Description = "The position of the part." },
    { Name = "Color", Type = "Color3", Description = "The color of the part." },
    { Name = "Anchored", Type = "boolean", Description = "Whether the part should be anchored." }
}

function PartCreator.Execute(args)
    local part = Instance.new("Part")
    part.Shape = args.Shape or Enum.PartType.Block
    part.Size = args.Size or Vector3.new(4, 1, 2)
    part.Position = args.Position or Vector3.new(0, 5, 0)
    part.Color = args.Color or Color3.fromRGB(255, 0, 0)
    part.Anchored = args.Anchored or true
    part.Parent = workspace

    return "Created a new " .. tostring(part.Shape) .. " part at " .. tostring(part.Position)
end

return PartCreator
