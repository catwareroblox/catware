local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "CatWare",
    Icon = "door-open",
    Author = "For roblox.",
})

local Combat = Window:Tab({
    Title = "Combat",
    Icon = "bird",
    Locked = true,
})

local Premium = Window:Tab({
    Title = "Premium",
    Icon = "bird",
    Locked = false,
})

local BowExploit = Premium:Button({
    Title = "BowExploit",
    Desc = "hookmetamethod required --> fuck xeno/solara users",
    Locked = false,
    Callback = function()
        local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local Teams = game:GetService("Teams")
local remote = ReplicatedStorage.Remotes.ItemsRemotes.ShootProjectile

local cachedPlayers = Players:GetPlayers()
Players.PlayerAdded:Connect(function(p) table.insert(cachedPlayers, p) end)
Players.PlayerRemoving:Connect(function(p)
    for i, v in ipairs(cachedPlayers) do
        if v == p then table.remove(cachedPlayers, i) break end
    end
end)

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    if self == remote and getnamecallmethod() == "FireServer" then
        local args = {...}
        local id, name, startPos, direction, velocity = args[1], args[2], args[3], args[4], args[5]

        local nearest, minDist = nil, math.huge
        for _, p in ipairs(cachedPlayers) do
            if p ~= localPlayer and p.Team ~= localPlayer.Team then
                local char = p.Character
                local hrp = char and char.PrimaryPart
                if hrp then
                    local dist = (localPlayer.Character.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = hrp
                    end
                end
            end
        end

        if nearest then
            repeat task.wait() until nearest.Parent and nearest.Position
            startPos = nearest.Position + Vector3.new(0, 10, 0)
            direction = Vector3.new(0, -100, 0)
            velocity = Vector3.new(0, -5000, 0)
        end

        return old(self, id, name, startPos, direction, velocity)
    end
    return old(self, ...)
end)
    end
})

WindUI:Notify({
    Title = "CatWare",
    Content = "CatWare loaded successfully. | Venom & More",
    Duration = 3, -- 3 seconds
    Icon = "bird",
})

local Keybind = Tab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "RightShift",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

-- All in beta so yeah
