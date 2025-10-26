-- Main.server.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Create a unique folder in ReplicatedStorage for our UI modules
local SHARED_UI_FOLDER_NAME = "RobloxAIPlugin_SharedUI_" .. HttpService:GenerateGUID(false)
local sharedUiFolder = Instance.new("Folder")
sharedUiFolder.Name = SHARED_UI_FOLDER_NAME
sharedUiFolder.Parent = ReplicatedStorage

-- Clean up the shared folder when the plugin unloads
plugin.Unloading:Connect(function()
    sharedUiFolder:Destroy()
end)

-- Find the source directories
local srcFolder = script.Parent
local libFolder = srcFolder:FindFirstChild("lib")
local uiFolder = srcFolder:FindFirstChild("ui")

-- Clone the lib and ui folders into the shared location
if libFolder then
    libFolder:Clone().Parent = sharedUiFolder
end
if uiFolder then
    uiFolder:Clone().Parent = sharedUiFolder
end
local configFile = srcFolder:FindFirstChild("config.lua")
if configFile then
    configFile:Clone().Parent = sharedUiFolder
end

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
    450,                        -- Initial width
    600,                        -- Initial height
    300,                        -- Minimum width
    200                         -- Minimum height
)

local widget = plugin:CreateDockWidgetPluginGui("AI_Assistant", widgetInfo)
widget.Title = "AI Assistant"

-- Handle button clicks to show/hide the widget
button.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

-- Create and parent the client script to the widget.
if uiFolder then
    local clientScriptSource = uiFolder:FindFirstChild("Client.client.lua")
    if clientScriptSource then
        local clientScript = Instance.new("LocalScript")
        clientScript.Name = "Client"
        clientScript.Source = clientScriptSource.Source
        clientScript.Parent = widget
        -- Pass the shared folder to the client script
        clientScript:SetAttribute("SharedUiFolder", sharedUiFolder)
    else
        warn("AI Plugin: Client.client.lua not found in ui folder.")
    end
end

-- ====== SERVER-SIDE LOGIC ====== --
local coreFolder = srcFolder:FindFirstChild("core")
local remotesModule = require(srcFolder:FindFirstChild("remotes.server"))

-- Initialize remotes
local remotes = remotesModule.initialize()

-- Connect the AI service to the remote function
local AI = require(coreFolder:FindFirstChild("AI"))
local Memory = require(coreFolder:FindFirstChild("Memory"))
local ToolManager = require(coreFolder:FindFirstChild("ToolManager"))
ToolManager.loadTools(srcFolder)
Memory.initialize(plugin) -- Initialize the memory module with the plugin object
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
local getChatList = remotes:FindFirstChild("GetChatList")
if getChatList then
    getChatList.OnServerInvoke = function(player)
        return Memory.getChatList()
    end
end

-- Remote function to load a chat
local loadChat = remotes:FindFirstChild("LoadChat")
if loadChat then
    loadChat.OnServerInvoke = function(player, chatId)
        currentChatId = chatId
        return Memory.loadChat(chatId)
    end
end

-- Remote function to create a new chat
local createNewChat = remotes:FindFirstChild("CreateNewChat")
if createNewChat then
    createNewChat.OnServerInvoke = function(player)
        local newChatId = "Chat_" .. tostring(os.time())
        Memory.addChatToList(newChatId)
        currentChatId = newChatId
        return newChatId
    end
end
