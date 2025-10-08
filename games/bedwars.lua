local Library = loadfile("idk/Library.lua")()
local Animations = loadfile("idk/libraries/Animations.lua")()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
local LightingService = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local workspace = game:GetService("Workspace")
local camera = workspace.Camera
local viewmodel = camera:WaitForChild("Viewmodel")
local C1 = viewmodel:WaitForChild("RightHand"):WaitForChild("RightWrist").C1
local C0 = viewmodel:WaitForChild("RightHand"):WaitForChild("RightWrist").C0
local lplr = Players.LocalPlayer

local NetManaged = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
local BlockEngine = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged

local Combat = Library.library.CreateTab("Combat")
local Player = Library.library.CreateTab("Player")
local Movement = Library.library.CreateTab("Movement")
local Render = Library.library.CreateTab("Render")
local Utility = Library.library.CreateTab("Utility")

local isnetworkowner = isnetworkowner or function(part)
    return true
end

local ItemMeta = {
    Weapons = {
        ["wood_sword"] = {Damage = 20, Name = "wood_sword"},
        ["stone_sword"] = {Damage = 25, Name = "stone_sword"},
        ["iron_sword"] = {Damage = 30, Name = "iron_sword"},
        ["diamond_sword"] = {Damage = 42, Name = "diamond_sword"},
        ["emerald_sword"] = {Damage = 55, Name = "emerald_sword"},
        ["rageblade"] = {Damage = 70, Name = "rageblade"},
    }
}

local bedwars = {
    SwordHit = NetManaged.SwordHit,
    StepOnSnapTrap = NetManaged.StepOnSnapTrap,
    PlaceBlock = BlockEngine.PlaceBlock,
    DamageBlock = BlockEngine.DamageBlock,
}

local function isAlive(plr)
    local suc, ret = pcall(function()
        return plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
    end)
    return suc and ret or false
end

local function getRoundedPos(Vec3)
    return Vector3.new(math.round(Vec3.X / 3), math.round(Vec3.Y / 3), math.round(Vec3.Z / 3))
end

local function FindNearestBed(IgnoreBedSheildEndTime, MaxDistance)
    local NearestBedDistance = MaxDistance or math.huge
    local NearestBed = nil
    local AmountOfBeds = 0
    if isAlive(lplr) then
        for _, v in next, CollectionService:GetTagged("bed") do
            if v:FindFirstChild("Bed") and v.Bed.BrickColor ~= lplr.Team.TeamColor then
                AmountOfBeds += 1
            end
        end
        if IgnoreBedSheildEndTime == false then
            for _, v in next, CollectionService:GetTagged("bed") do
                if v:FindFirstChild("Bed") and v.Bed.BrickColor ~= lplr.Team.TeamColor then
                    if v:GetAttribute("BedShieldEndTime") and ((v:GetAttribute("BedShieldEndTime") > workspace:GetServerTimeNow() and AmountOfBeds == 1) or v:GetAttribute("BedShieldEndTime") < workspace:GetServerTimeNow()) then
                        local Distance = (v.Position - lplr.Character.PrimaryPart.Position).Magnitude
                        if Distance < NearestBedDistance then
                            NearestBedDistance = Distance
                            NearestBed = v
                        end
                    end
                    if not v:GetAttribute("BedShieldEndTime") then
                        local Distance = (v.Position - lplr.Character.PrimaryPart.Position).Magnitude
                        if Distance < NearestBedDistance then
                            NearestBedDistance = Distance
                            NearestBed = v
                        end
                    end
                end
            end
        end
        if IgnoreBedSheildEndTime == true then
            for _, v in next, CollectionService:GetTagged("bed") do
                if v:FindFirstChild("Bed") and v.Bed.BrickColor ~= lplr.Team.TeamColor then
                    local Distance = (v.Position - lplr.Character.PrimaryPart.Position).Magnitude
                    if Distance < NearestBedDistance then
                        NearestBedDistance = Distance
                        NearestBed = v
                    end
                end
            end
        end
    end
    return NearestBed, NearestBedDistance
end

local function DamageBlock(Position)
    bedwars.DamageBlock:InvokeServer({
        blockRef = {blockPosition = getRoundedPos(Position)},
        hitPosition = getRoundedPos(Position),
        hitNormal = getRoundedPos(Position)
    })
end

local function getNearestEntity(Range)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lplr and v.Team ~= lplr.Team and v.Character and v.Character.PrimaryPart then
            local Dist = lplr:DistanceFromCharacter(v.Character.PrimaryPart.Position)
            if Dist <= Range then
                return {plr = v, char = v.Character, root = v.Character.PrimaryPart}
            end
        end
    end
end

local function PlayAnimation(Animation)
    if viewmodel and C0 then
        for _, v in next, Animation do
            local TweenInformation = TweenInfo.new(v.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
            local AnimationTween = TweenService:Create(viewmodel.RightHand.RightWrist, TweenInformation, {C0 = (C0 * v.CFrame)})
            AnimationTween:Play()
            task.wait(v.Time)
        end
    end
end

local Inventory = ReplicatedStorage.Inventories[lplr.Name]
local CharAddedFuncs = {}
lplr.CharacterAdded:Connect(function(Char)
    repeat task.wait() until Char
    Inventory = ReplicatedStorage.Inventories[lplr.Name]
    for _, v in pairs(CharAddedFuncs) do
        if typeof(v) == "function" then
            v()
        end
    end
end)

local function hasItem(Name)
    for _, v in Inventory:GetChildren() do
        if v.Name:lower():find(Name:lower()) then
            return true
        end
    end
    return false
end

local function getItem(Name)
    for _, v in Inventory:GetChildren() do
        if v.Name:lower():find(Name:lower()) then
            return v
        end
    end
    return false
end

local function getBestSword()
    local bestSword = ItemMeta.Weapons.wood_sword.Name
    local bestSwordPower = 0
    for i, v in pairs(ItemMeta.Weapons) do
        if v.Damage > bestSwordPower and hasItem(i) then
            bestSwordPower = v.Damage
            bestSword = i
        end
    end
    return getItem(bestSword)
end

local blockIndex = 1
local function GetBlock()
    local blocks = {}
    for _, v in next, Inventory:GetChildren() do
        if v.Name:find("wool") or v.Name:find("block") or v.Name:find("brick") or v.Name:find("Brick") or v.Name:find("plank") or v.Name:find("Plank") or v.Name:find("obsidian") then
            table.insert(blocks, v.Name)
        end
    end
    if #blocks > 0 then
        if blockIndex > #blocks then
            blockIndex = 1
        end
        local block = blocks[blockIndex]
        blockIndex += 1
        return block
    end
end

local Fly
Fly = Movement:CreateModule({
    ["Name"] = "Fly",
    ["Function"] = function(callback)
        if callback then
            if not Fly.Connection then
                Fly.Connection = RunService.RenderStepped:Connect(function()
                    if isAlive(lplr) then
                        local Velocity = lplr.Character.PrimaryPart.Velocity
                        local setY = 0
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            setY = 50
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            setY = -50
                        end
                        lplr.Character.PrimaryPart.Velocity = Vector3.new(Velocity.X, setY, Velocity.Z)
                    end
                end)
            end
        else
            if Fly.Connection then
                Fly.Connection:Disconnect()
                Fly.Connection = nil
            end
        end
    end
})

local Speed
Speed = Movement:CreateModule({
    ["Name"] = "Speed",
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

local connection
local animPlaying = false
local KillauraAnimations = {
    Sus = {
        {CFrame = CFrame.new(0.3, -1, -1) * CFrame.Angles(-math.rad(60), math.rad(55), -math.rad(90)), Time = 0.2},
        {CFrame = CFrame.new(0.3, -1, -0.1) * CFrame.Angles(-math.rad(90), math.rad(110), -math.rad(90)), Time = 0.2},
    },
}
local Aura
Aura = Combat:CreateModule({
    ["Name"] = "Aura",
    ["Function"] = function(callback)
        if callback then
            if not connection then
                connection = RunService.Stepped:Connect(function()
                    local Nearest = getNearestEntity(18)
                    if Nearest and isAlive(lplr) and isAlive(Nearest.plr) then
                        local Sword = getBestSword()
                        if Sword and not animPlaying then
                            animPlaying = true
                            task.spawn(function()
                                while animPlaying do
                                    Nearest = getNearestEntity(18)
                                    if not Nearest or not isAlive(lplr) or not isAlive(Nearest.plr) then
                                        break
                                    end
                                    for _, v in next, KillauraAnimations.Sus do
                                        Nearest = getNearestEntity(18)
                                        if not Nearest or not isAlive(lplr) or not isAlive(Nearest.plr) then
                                            animPlaying = false
                                            break
                                        end
                                        local TweenInfo = TweenInfo.new(v.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                                        local Tween = TweenService:Create(viewmodel.RightHand.RightWrist, TweenInfo, {C0 = C0 * v.CFrame})
                                        Tween:Play()
                                        task.wait(v.Time)
                                    end
                                end
                                viewmodel.RightHand.RightWrist.C0 = C0
                                animPlaying = false
                            end)
                        end
                        bedwars.SwordHit:FireServer({
                            weapon = Sword,
                            chargedAttack = {chargeRatio = 0},
                            lastSwingServerTimeDelta = 0.01,
                            entityInstance = Nearest.plr.Character,
                            validate = {
                                raycast = {
                                    cameraPosition = {value = lplr.Character.PrimaryPart.Position},
                                    rayDirection = {value = ((Nearest.plr.Character.PrimaryPart.Position + (Nearest.plr.Character.PrimaryPart.Velocity * Ping)) - lplr.Character.PrimaryPart.Position).Unit}
                                },
                                targetPosition = {value = Nearest.plr.Character.PrimaryPart.Position + (Nearest.plr.Character.PrimaryPart.Velocity * Ping)},
                                selfPosition = {value = lplr.Character.PrimaryPart.Position + (lplr.Character.PrimaryPart.Velocity * (Ping * 0.5))}
                            }
                        })
                    else
                        if animPlaying then
                            animPlaying = false
                            viewmodel.RightHand.RightWrist.C0 = C0
                        end
                    end
                end)
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
                animPlaying = false
                viewmodel.RightHand.RightWrist.C0 = C0
            end
        end
    end
})

local NoFall
NoFall = Player:CreateModule({
    ["Name"] = "NoFall",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                local lastSpoof = tick()
                local lastY = 0
                repeat
                    if isAlive(lplr) then
                        if lplr.Character.PrimaryPart.Velocity.Y < -79 then
                            lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X, -80, lplr.Character.PrimaryPart.Velocity.Z)
                            lplr.Character.PrimaryPart.CFrame -= Vector3.new(0, (tick() - lastSpoof), 0)
                        else
                            lastSpoof = tick()
                        end
                        if math.abs(lastY - lplr.Character.PrimaryPart.Position.Y) > 5 then
                            lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                        end
                        lastY = lplr.Character.PrimaryPart.Position.Y
                    end
                    task.wait(0.01)
                until not NoFall.Enabled
            end)
        end
    end
})

local Breaker
Breaker = Utility:CreateModule({
    ["Name"] = "Breaker",
    ["Function"] = function(callback)
        if callback then
            repeat
                local bed = FindNearestBed(true, 30)
                if bed then
                    DamageBlock(bed.Position)
                end
                task.wait(0.21)
            until not Breaker.Enabled
        end
    end
})

local Scaffold
Scaffold = Player:CreateModule({
    ["Name"] = "Scaffold",
    ["Function"] = function(callback)
        if callback then
            repeat
                local BuildPosition = (lplr.Character.PrimaryPart.Position + ((lplr.Character.PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0, (lplr.Character.PrimaryPart.Size.Y / 2) + ((lplr.Character.Humanoid.HipHeight + (lplr.Character.Humanoid.HipHeight / 2))), 0)))
                local RealBuildPosition = getRoundedPos(BuildPosition)
                local Block = GetBlock()
                if Block then
                    bedwars.PlaceBlock:InvokeServer({blockType = Block, blockData = 0, position = RealBuildPosition})
                end
                task.wait()
            until not Scaffold.Enabled
        end
    end
})

local WinterSky
WinterSky = Render:CreateModule({
    ["Name"] = "Winter Sky",
    ["Function"] = function(callback)
        if callback then
            repeat
                if LightingService:FindFirstChild("Sky") then
                    LightingService.Sky.Parent = ReplicatedStorage
                end
                local WinterSky = LightingService:FindFirstChild("WinterSky") or Instance.new("Sky")
                WinterSky.Parent = LightingService
                WinterSky.Name = "WinterSky"
                WinterSky.MoonAngularSize = 30
                WinterSky.SunAngularSize = 11
                WinterSky.MoonTextureId = "rbxassetid://8139665943"
                WinterSky.SunTextureId = "rbxassetid://6196665106"
                WinterSky.StarCount = 5000
                WinterSky.SkyboxUp = "rbxassetid://8139676647"
                WinterSky.SkyboxLf = "rbxassetid://8139676988"
                WinterSky.SkyboxFt = "rbxassetid://8139677111"
                WinterSky.SkyboxBk = "rbxassetid://8139677359"
                WinterSky.SkyboxDn = "rbxassetid://8139677253"
                WinterSky.SkyboxRt = "rbxassetid://8139676842"
                if LightingService:FindFirstChildOfClass("SunRaysEffect") then
                    LightingService:FindFirstChildOfClass("SunRaysEffect"):Destroy()
                end
                local SunRaysEffect = Instance.new("SunRaysEffect")
                SunRaysEffect.Parent = LightingService
                SunRaysEffect.Intensity = 0.03
                if LightingService:FindFirstChildOfClass("BloomEffect") then
                    LightingService:FindFirstChildOfClass("BloomEffect"):Destroy()
                end
                local BloomEffect = Instance.new("BloomEffect")
                BloomEffect.Parent = LightingService
                BloomEffect.Threshold = 2
                BloomEffect.Intensity = 1
                BloomEffect.Size = 2
                if LightingService:FindFirstChildOfClass("Atmosphere") then
                    LightingService:FindFirstChildOfClass("Atmosphere"):Destroy()
                end
                local Atmosphere = Instance.new("Atmosphere")
                Atmosphere.Parent = LightingService
                Atmosphere.Density = 0.3
                Atmosphere.Offset = 0.25
                Atmosphere.Color = Color3.new(0.776471, 0.776471, 0.776471)
                Atmosphere.Decay = Color3.new(0.407843, 0.439216, 0.486275)
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
                task.wait()
            until not WinterSky.Enabled
        else
            if LightingService:FindFirstChild("WinterSky") then
                LightingService.WinterSky:Destroy()
            end
        end
    end
})
