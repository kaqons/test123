-- src/ui/MainFrame.client.lua

local uiFolder = script.Parent
local libFolder = uiFolder.Parent.lib
local componentsFolder = uiFolder.components

local Roact = require(libFolder.Roact)
local config = require(uiFolder.Parent.config) -- This will be cloned to the shared folder root

local NewChatButton = require(componentsFolder.NewChatButton)
local ChatHistoryPanel = require(componentsFolder.ChatHistoryPanel)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getAICompletion = ReplicatedStorage:WaitForChild("AI_Remotes"):WaitForChild("GetAICompletion")
local loadChatRemote = ReplicatedStorage:WaitForChild("AI_Remotes"):WaitForChild("LoadChat")
local createNewChatRemote = ReplicatedStorage:WaitForChild("AI_Remotes"):WaitForChild("CreateNewChat")

local MainFrame = Roact.Component:extend("MainFrame")

function MainFrame:init()
    self.state = {
        messages = {},
        inputText = "",
        showHistory = false,
        isAITyping = false
    }
end

function MainFrame:render()
    return Roact.createElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = config.UI_THEME.BACKGROUND_COLOR
    }, {
        TitleLabel = Roact.createElement("TextLabel", {
            Name = "TitleLabel",
            Size = UDim2.new(1, 0, 0, 50),
            Text = "AI Assistant",
            TextColor3 = config.UI_THEME.TEXT_COLOR,
            BackgroundColor3 = config.UI_THEME.SECONDARY_COLOR,
            Font = config.UI_THEME.FONT,
            TextSize = 24
        }),
        ChatWindow = Roact.createElement("ScrollingFrame", {
            Name = "ChatWindow",
            Size = UDim2.new(1, self.state.showHistory and -200 or 0, 1, -100),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundColor3 = config.UI_THEME.BACKGROUND_COLOR,
            CanvasSize = UDim2.new(0, 0, 0, (#self.state.messages + (self.state.isAITyping and 1 or 0)) * 50)
        }, self:renderMessages()),
        InputBox = Roact.createElement("TextBox", {
            Name = "InputBox",
            Size = UDim2.new(1, self.state.showHistory and -260 or -60, 0, 50),
            Position = UDim2.new(0, 0, 1, -50),
            PlaceholderText = "Type your message here...",
            Text = self.state.inputText,
            [Roact.Change.Text] = function(rbx)
                self:setState({ inputText = rbx.Text })
            end
        }),
        SendButton = Roact.createElement("TextButton", {
            Name = "SendButton",
            Size = UDim2.new(0, 60, 0, 50),
            Position = UDim2.new(1, self.state.showHistory and -260 or -60, 1, -50),
            Text = "Send",
            [Roact.Event.MouseButton1Click] = function()
                self:sendMessage()
            end
        }),
        NewChatButton = Roact.createElement(NewChatButton, {
            onClick = function()
                self:createNewChat()
            end
        }),
        ToggleHistoryButton = Roact.createElement("TextButton", {
            Name = "ToggleHistoryButton",
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0, 120, 0, 10),
            Text = "History",
            [Roact.Event.MouseButton1Click] = function()
                self:setState({ showHistory = not self.state.showHistory })
            end
        }),
        ChatHistoryPanel = self.state.showHistory and Roact.createElement(ChatHistoryPanel, {
            onChatSelected = function(chatName)
                self:loadChat(chatName)
            end
        }) or nil
    })
end

function MainFrame:renderMessages()
    local messageElements = {}
    for i, message in ipairs(self.state.messages) do
        local role = message.role or (message.from == "user" and "user" or "assistant")
        messageElements[i] = Roact.createElement("TextLabel", {
            Name = "Message" .. i,
            Text = message.content or message.text,
            TextColor3 = config.UI_THEME.TEXT_COLOR,
            TextXAlignment = role == "user" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 0, (i - 1) * 50)
        })
    end

    if self.state.isAITyping then
        table.insert(messageElements, Roact.createElement("TextLabel", {
            Name = "TypingIndicator",
            Text = "Typing...",
            TextColor3 = config.UI_THEME.TEXT_COLOR,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 0, #self.state.messages * 50)
        }))
    end

    return messageElements
end

function MainFrame:sendMessage()
    if self.state.inputText == "" or self.state.isAITyping then return end

    local newMessages = self.state.messages
    table.insert(newMessages, { role = "user", content = self.state.inputText })

    self:setState({
        messages = newMessages,
        inputText = "",
        isAITyping = true
    })

    -- Get AI response
    spawn(function()
        local aiResponse = getAICompletion:InvokeServer(self.state.messages)
        local newMessages = self.state.messages
        table.insert(newMessages, { role = "assistant", content = aiResponse })
        self:setState({
            messages = newMessages,
            isAITyping = false
        })
    end)
end

function MainFrame:loadChat(chatId)
    spawn(function()
        local messages = loadChatRemote:InvokeServer(chatId)
        if messages then
            self:setState({ messages = messages })
        end
    end)
end

function MainFrame:createNewChat()
    spawn(function()
        local newChatId = createNewChatRemote:InvokeServer()
        self:setState({ messages = {} })
    end)
end

return MainFrame
