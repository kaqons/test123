-- src/ui/Client.client.lua

-- The shared folder is passed as an attribute from the server script
local sharedUiFolder = script:GetAttribute("SharedUiFolder")
if not sharedUiFolder then
    error("AI Plugin: Client script did not receive the SharedUiFolder attribute.")
    return
end

-- Now we can require modules using relative paths from the shared folder's children
local Roact = require(sharedUiFolder.lib.Roact)
local MainFrame = require(sharedUiFolder.ui.MainFrame)

-- The script's parent is the plugin widget.
local target = script.Parent

-- Create the Roact app and mount it to the target.
local app = Roact.createElement(MainFrame)
local handle = Roact.mount(app, target, "AI_Assistant_UI")

-- Unmount the component when the script is destroyed.
script.Destroying:Connect(function()
    Roact.unmount(handle)
end)
