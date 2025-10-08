local Library = loadfile("idk/Library.lua")()

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService('TextChatService')
local UserInputService = game:GetService('UserInputService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local lplr = Players.LocalPlayer

local clonefunction = clonefunction or function(func)
    return function(...)
        func(...)
    end
end
local isnetworkowner = isnetworkowner or function(part)
    return true;
end

local Combat = Library.library.CreateTab("Combat")
local Player = Library.library.CreateTab("Player")
local Movement = Library.library.CreateTab("Movement")
local Visuals = Library.library.CreateTab("Render")
local World = Library.library.CreateTab("World")
local Exploit = Library.library.CreateTab("Exploit")

BedwarZ = {
    SwordHit = ReplicatedStorage.Remotes.ItemsRemotes.SwordHit,
    PlaceBlock = ReplicatedStorage.Remotes.ItemsRemotes.PlaceBlock,
    EquipTool = ReplicatedStorage.Remotes.ItemsRemotes.EquipTool,
    MineBlock = ReplicatedStorage.Remotes.ItemsRemotes.MineBlock,
    ShootProjectile = ReplicatedStorage.Remotes.ItemsRemotes.ShootProjectile,

    getMap = function()
        return ReplicatedStorage.GameInfo.Map.Value
    end,
}

print("not done yet lmao")