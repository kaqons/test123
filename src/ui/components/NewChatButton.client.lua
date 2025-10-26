-- src/ui/components/NewChatButton.client.lua

local componentsFolder = script.Parent
local uiFolder = componentsFolder.Parent
local libFolder = uiFolder.Parent.lib

local Roact = require(libFolder.Roact)
local config = require(uiFolder.Parent.config)

local NewChatButton = Roact.Component:extend("NewChatButton")

function NewChatButton:render()
    return Roact.createElement("TextButton", {
        Name = "NewChatButton",
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        Text = "New Chat",
        BackgroundColor3 = config.UI_THEME.PRIMARY_COLOR,
        TextColor3 = config.UI_THEME.TEXT_COLOR,
        Font = config.UI_THEME.FONT,
        [Roact.Event.MouseButton1Click] = self.props.onClick
    })
end

return NewChatButton
