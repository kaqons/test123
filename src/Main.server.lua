-- Main.server.lua

-- Create a new toolbar for the plugin
local toolbar = plugin:CreateToolbar("AI Assistant")

-- Create a new button on the toolbar
local button = toolbar:CreateButton(
    "Open AI Assistant",
    "Opens the AI assistant window",
    "rbxassetid://123456789" -- Replace with an appropriate icon ID
)

-- Create the main widget for the plugin's UI
local widgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float, -- Initial dock state
    true,                       -- Enabled
    false,                      -- Override publisher name
    250,                        -- Initial width
    400,                        -- Initial height
    150,                        -- Minimum width
    150                         -- Minimum height
)

local widget = plugin:CreateDockWidgetPluginGui("AI_Assistant", widgetInfo)
widget.Title = "AI Assistant"

-- Handle button clicks to show/hide the widget
button.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

-- Load the UI
local Roact = require(script.Parent.lib.Roact)
local MainFrame = require(script.Parent.ui.MainFrame)

local app = Roact.createElement(MainFrame)
local handle = Roact.mount(app, widget, "AI_Assistant_UI")

-- Unmount the component when the plugin is unloaded
plugin.Unloading:Connect(function()
    Roact.unmount(handle)
end)

-- Initialize remotes
local remotes = require(script.Parent.remotes)

-- Connect the AI service to the remote function
local AI = require(script.Parent.core.AI)
local Memory = require(script.Parent.core.Memory)
local currentChatId = "default" -- Placeholder

remotes.GetAICompletion.OnServerInvoke = function(player, messages)
    local response = AI.getCompletion(messages)
    local fullChat = {}
    for _, msg in ipairs(messages) do
        table.insert(fullChat, msg)
    end
    table.insert(fullChat, { role = "assistant", content = response })
    Memory.saveChat(currentChatId, fullChat)
    return response
end

-- Remote function to get the chat list
local getChatList = Instance.new("RemoteFunction")
getChatList.Name = "GetChatList"
getChatList.Parent = remotes

getChatList.OnServerInvoke = function(player)
    return Memory.getChatList()
end

-- Remote function to load a chat
local loadChat = Instance.new("RemoteFunction")
loadChat.Name = "LoadChat"
loadChat.Parent = remotes

loadChat.OnServerInvoke = function(player, chatId)
    currentChatId = chatId
    return Memory.loadChat(chatId)
end

-- Remote function to create a new chat
local createNewChat = Instance.new("RemoteFunction")
createNewChat.Name = "CreateNewChat"
createNewChat.Parent = remotes

createNewChat.OnServerInvoke = function(player)
    local newChatId = "Chat_" .. tostring(os.time())
    Memory.addChatToList(newChatId)
    currentChatId = newChatId
    return newChatId
end
