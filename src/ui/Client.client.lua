-- src/ui/Client.client.lua

-- This variable is injected by Main.server.lua
local SHARED_UI_FOLDER_NAME = SHARED_UI_FOLDER_NAME

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for the shared folder to be created
local sharedUiFolder = ReplicatedStorage:WaitForChild(SHARED_UI_FOLDER_NAME, 30)
if not sharedUiFolder then
    error("AI Plugin: Failed to find the shared UI folder in ReplicatedStorage.")
    return
end

-- Define the paths for easy access
local paths = {
    lib = sharedUiFolder:WaitForChild("lib"),
    ui = sharedUiFolder:WaitForChild("ui"),
    components = sharedUiFolder:WaitForChild("ui"):WaitForChild("components")
}

-- Add the paths to the package path so require can find them
package.path = package.path .. ";" .. paths.lib:GetFullName() .. "?.lua"
package.path = package.path .. ";" .. paths.ui:GetFullName() .. "?.lua"
package.path = package.path .. ";" .. paths.components:GetFullName() .. "?.lua"


-- Now we can require the modules using their names
local Roact = require("Roact")
local MainFrame = require("MainFrame")

-- The script's parent is the plugin widget.
local target = script.Parent

-- Create the Roact app and mount it to the target.
local app = Roact.createElement(MainFrame)
local handle = Roact.mount(app, target, "AI_Assistant_UI")

-- Unmount the component when the script is destroyed.
script.Destroying:Connect(function()
    Roact.unmount(handle)
end)
