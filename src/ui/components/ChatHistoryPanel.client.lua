-- src/ui/components/ChatHistoryPanel.client.lua

local Roact = require("Roact")
local config = require("config")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getChatList = ReplicatedStorage:WaitForChild("AI_Remotes"):WaitForChild("GetChatList")
local loadChat = ReplicatedStorage:WaitForChild("AI_Remotes"):WaitForChild("LoadChat")

local ChatHistoryPanel = Roact.Component:extend("ChatHistoryPanel")

function ChatHistoryPanel:init()
    self.state = {
        chatList = {}
    }
    self:fetchChatList()
end

function ChatHistoryPanel:fetchChatList()
    spawn(function()
        local list = getChatList:InvokeServer()
        self:setState({ chatList = list })
    end)
end

function ChatHistoryPanel:render()
    return Roact.createElement("Frame", {
        Name = "ChatHistoryPanel",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(1, -200, 0, 0),
        BackgroundColor3 = config.UI_THEME.SECONDARY_COLOR
    }, {
        Title = Roact.createElement("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 50),
            Text = "Chat History",
            TextColor3 = config.UI_THEME.TEXT_COLOR,
            Font = config.UI_THEME.FONT
        }),
        HistoryList = Roact.createElement("ScrollingFrame", {
            Name = "HistoryList",
            Size = UDim2.new(1, 0, 1, -50),
            Position = UDim2.new(0, 0, 0, 50)
        }, self:renderHistory())
    })
end

function ChatHistoryPanel:renderHistory()
    local historyElements = {}

    for i, chatName in ipairs(self.state.chatList) do
        historyElements[i] = Roact.createElement("TextButton", {
            Name = "HistoryItem" .. i,
            Text = chatName,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, (i - 1) * 30),
            [Roact.Event.MouseButton1Click] = function()
                self.props.onChatSelected(chatName)
            end
        })
    end

    return historyElements
end

return ChatHistoryPanel
