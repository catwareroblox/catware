local Library = loadfile("idk/Library.lua")()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
local LightingService = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local workspace = game:GetService("Workspace")

local lplr = Players.LocalPlayer
local Combat = Library.library.CreateTab("Combat")
local Player = Library.library.CreateTab("Player")
local Movement = Library.library.CreateTab("Movement")
local Render = Library.library.CreateTab("Render")
local Utility = Library.library.CreateTab("Utility")

local isnetworkowner = isnetworkowner or function(part)
    return true
end

BedwarZ = {
    sHit = ReplicatedStorage.Remotes.ItemsRemotes.SwordHit,
    blockThing = ReplicatedStorage.Remotes.ItemsRemotes.PlaceBlock,
    etool = ReplicatedStorage.Remotes.ItemsRemotes.EquipTool,
    mblock = ReplicatedStorage.Remotes.ItemsRemotes.MineBlock,
    ditm = ReplicatedStorage.Remotes.ItemsRemotes.DropItem,
    sproj = ReplicatedStorage.Remotes.ItemsRemotes.ShootProjectile,
    veloutils = ReplicatedStorage.Modules.VelocityUtils,

    getMap = function()
        return ReplicatedStorage.GameInfo.Map.Value
    end,
}
-- Skidded src/pasted src :money:

local Speed
Speed = Movement:CreateModule({
    ["Name"] = "Sprint",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                repeat
                    if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
                        lplr.Character.Humanoid.WalkSpeed = 23
                    end
                    task.wait()
                until not Speed.Enabled
            end)
        else
            if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
                lplr.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})