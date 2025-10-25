-- src/remotes/init.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a folder to store the remotes
local remotesFolder = Instance.new("Folder")
remotesFolder.Name = "AI_Remotes"
remotesFolder.Parent = ReplicatedStorage

-- Create the remote function for AI completion
local getAICompletion = Instance.new("RemoteFunction")
getAICompletion.Name = "GetAICompletion"
getAICompletion.Parent = remotesFolder

return remotesFolder
