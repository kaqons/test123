-- src/ui/Client.client.lua

-- This script is the client-side entry point for the plugin's UI.
-- It loads Roact and mounts the main UI component to the plugin widget.

local Roact = require(script.Parent.Parent.lib.Roact)
local MainFrame = require(script.Parent.MainFrame)

-- The script's parent will be the plugin widget.
local target = script.Parent

-- Create the Roact app and mount it to the target.
local app = Roact.createElement(MainFrame)
local handle = Roact.mount(app, target, "AI_Assistant_UI")

-- Unmount the component when the script is destroyed.
script.Destroying:Connect(function()
    Roact.unmount(handle)
end)
