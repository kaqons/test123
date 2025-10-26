-- src/core/ArgumentHandler.server.lua

local ArgumentHandler = {}

-- A map of type names to their conversion functions
local typeConverters = {
    ["string"] = function(val) return tostring(val) end,
    ["number"] = function(val) return tonumber(val) end,
    ["boolean"] = function(val) return val == true end,
    ["Vector3"] = function(val)
        if type(val) == "table" and val.X and val.Y and val.Z then
            return Vector3.new(val.X, val.Y, val.Z)
        elseif type(val) == "table" and #val == 3 then
             return Vector3.new(val[1], val[2], val[3])
        else
            -- Try to parse from a string like "x,y,z"
            local parts = string.split(tostring(val), ",")
            if #parts == 3 then
                return Vector3.new(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
            end
        end
        return nil -- Invalid format
    end,
    ["Color3"] = function(val)
        if type(val) == "table" and val.R and val.G and val.B then
            return Color3.fromRGB(val.R, val.G, val.B)
        elseif type(val) == "table" and #val == 3 then
            return Color3.fromRGB(val[1], val[2], val[3])
        else
            -- Try to parse from a string like "r,g,b"
            local parts = string.split(tostring(val), ",")
            if #parts == 3 then
                return Color3.fromRGB(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
            end
        end
        return nil -- Invalid format
    end,
    ["any"] = function(val) return val end -- For properties that can be any type
}

--[[
    Validates and converts arguments for a given tool.
    @param tool The tool definition table.
    @param args The raw arguments table from the AI (decoded from JSON).
    @return A tuple: (boolean success, table convertedArgs or string errorMessage)
]]
function ArgumentHandler.process(tool, args)
    local convertedArgs = {}

    for _, argDef in ipairs(tool.Arguments) do
        local argName = argDef.Name
        local argType = argDef.Type
        local rawValue = args[argName]

        if rawValue == nil then
            return false, "Missing required argument '" .. argName .. "' for tool '" .. tool.Name .. "'."
        end

        local converter = typeConverters[argType]
        if not converter then
            return false, "Unknown argument type '" .. argType .. "' for tool '" .. tool.Name .. "'."
        end

        local convertedValue = converter(rawValue)
        if convertedValue == nil then
            return false, "Invalid value for argument '" .. argName .. "'. Expected type '" .. argType .. "', but got '" .. tostring(rawValue) .. "'."
        end

        convertedArgs[argName] = convertedValue
    end

    return true, convertedArgs
end

return ArgumentHandler
