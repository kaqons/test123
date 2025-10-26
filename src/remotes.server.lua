-- src/remotes.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesModule = {}

function remotesModule.initialize()
    -- Create a folder to store the remotes
    local remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "AI_Remotes"
    remotesFolder.Parent = ReplicatedStorage

    -- Create the remote function for AI completion
    local getAICompletion = Instance.new("RemoteFunction")
    getAICompletion.Name = "GetAICompletion"
    getAICompletion.Parent = remotesFolder

    -- Create the remote function for getting the chat list
    local getChatList = Instance.new("RemoteFunction")
    getChatList.Name = "GetChatList"
    getChatList.Parent = remotesFolder

    -- Create the remote function for loading a chat
    local loadChat = Instance.new("RemoteFunction")
    loadChat.Name = "LoadChat"
    loadChat.Parent = remotesFolder

    -- Create the remote function for creating a new chat
    local createNewChat = Instance.new("RemoteFunction")
    createNewChat.Name = "CreateNewChat"
    createNewChat.Parent = remotesFolder

    return remotesFolder
end

return remotesModule
