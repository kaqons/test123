-- src/core/Memory.server.lua

local DataStoreService = game:GetService("DataStoreService")
local chatHistoryStore = DataStoreService:GetDataStore("ChatHistory")
local chatListStore = DataStoreService:GetDataStore("ChatList")

local Memory = {}

function Memory.saveChat(chatId, messages)
    local success, err = pcall(function()
        chatHistoryStore:SetAsync(chatId, messages)
    end)
    if not success then
        warn("Error saving chat history: " .. err)
    end
end

function Memory.loadChat(chatId)
    local success, messages = pcall(function()
        return chatHistoryStore:GetAsync(chatId)
    end)
    if success then
        return messages
    else
        warn("Error loading chat history: " .. err)
        return nil
    end
end

function Memory.getChatList()
    local success, chatList = pcall(function()
        return chatListStore:GetAsync("chatList")
    end)
    if success and chatList then
        return chatList
    else
        return {}
    end
end

function Memory.addChatToList(chatId)
    local chatList = Memory.getChatList()
    table.insert(chatList, chatId)
    chatListStore:SetAsync("chatList", chatList)
end

return Memory
