-- src/core/Memory.server.lua

-- This module uses the plugin object to persist settings, which is the correct
-- method for Roblox Studio plugins. DataStoreService is for in-game data.

local Memory = {}

-- The plugin object must be passed from the main script.
local pluginObject = nil

function Memory.initialize(plugin)
    pluginObject = plugin
end

-- Helper function to ensure plugin is initialized
local function checkPlugin()
    if not pluginObject then
        error("Memory module has not been initialized with the plugin object. Call Memory.initialize(plugin) first.")
    end
end

function Memory.saveChat(chatId, messages)
    checkPlugin()
    local success, err = pcall(function()
        -- Save the specific chat log under its ID
        pluginObject:SetSetting("ChatHistory_" .. chatId, messages)
    end)
    if not success then
        warn("Error saving chat history: " .. err)
    end
end

function Memory.loadChat(chatId)
    checkPlugin()
    local success, messages = pcall(function()
        -- Load the specific chat log
        return pluginObject:GetSetting("ChatHistory_" .. chatId)
    end)
    if success and messages then
        return messages
    else
        if not success then
            warn("Error loading chat history: " .. err)
        end
        return nil
    end
end

function Memory.getChatList()
    checkPlugin()
    -- The list of chat IDs is saved under a single key.
    local success, chatList = pcall(function()
        return pluginObject:GetSetting("ChatList")
    end)
    if success and chatList then
        return chatList
    else
        return {} -- Return an empty list if nothing is saved yet
    end
end

function Memory.addChatToList(chatId)
    checkPlugin()
    local chatList = Memory.getChatList()
    -- Avoid duplicates
    if not table.find(chatList, chatId) then
        table.insert(chatList, chatId)
        pluginObject:SetSetting("ChatList", chatList)
    end
end

return Memory
