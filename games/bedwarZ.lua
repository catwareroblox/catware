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

BedwarZ = {
    SwordHit = ReplicatedStorage.Remotes.ItemsRemotes.SwordHit,
    PlaceBlock = ReplicatedStorage.Remotes.ItemsRemotes.PlaceBlock,
    EquipTool = ReplicatedStorage.Remotes.ItemsRemotes.EquipTool,
    MineBlock = ReplicatedStorage.Remotes.ItemsRemotes.MineBlock,
    DropItem = ReplicatedStorage.Remotes.ItemsRemotes.DropItem,
    ShootProjectile = ReplicatedStorage.Remotes.ItemsRemotes.ShootProjectile,
    VeloUtils = ReplicatedStorage.Modules.VelocityUtils,

    getMap = function()
        return ReplicatedStorage.GameInfo.Map.Value
    end,
}

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


-- \\ Old src/spring's src
--[[
local Library = loadfile("idk/Library.lua")()

local GuiLibrary = loadfile("idk/Library.lua")()

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local SoundService = game:GetService('SoundService')
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

local Combat = Library.library.GetWindow('Combat')
local Player = Library.library.GetWindow('Player')
local Movement = Library.library.GetWindow('Movement')
local Visuals = Library.library.GetWindow('Visuals')
local World = Library.library.GetWindow('World')
local Exploit = Library.library.GetWindow('Exploit')

BedwarZ = {
    SwordHit = ReplicatedStorage.Remotes.ItemsRemotes.SwordHit,
    PlaceBlock = ReplicatedStorage.Remotes.ItemsRemotes.PlaceBlock,
    EquipTool = ReplicatedStorage.Remotes.ItemsRemotes.EquipTool,
    MineBlock = ReplicatedStorage.Remotes.ItemsRemotes.MineBlock,
    DropItem = ReplicatedStorage.Remotes.ItemsRemotes.DropItem,
    ShootProjectile = ReplicatedStorage.Remotes.ItemsRemotes.ShootProjectile,
    VeloUtils = ReplicatedStorage.Modules.VelocityUtils,

    getMap = function()
        return ReplicatedStorage.GameInfo.Map.Value
    end,
}

if require then
    BedwarZ.MathUtils = require(ReplicatedStorage.Modules.MathUtils)
end

local function isAlive(plr)
    local suc, ret = pcall(function()
        return plr.Character.Humanoid.Health > 0
    end)

    return suc and ret or false
end

local function getNearEntity(Range: number)
    for i,v in Players:GetPlayers() do
        local canHit = true

        if lplr:GetAttribute('PVP') then
            canHit = true
        end

        if v.Team == lplr.Team then
            canHit = false
        end

        if lplr.Team == game.Teams.Spectators and lplr:GetAttribute('PVP') then
            canHit = true
        end

        if canHit and v ~= lplr and isAlive(v) and isAlive(lplr) then
            if v.Character and v.Character.PrimaryPart and lplr.Character then
                local Dist = lplr:DistanceFromCharacter(v.Character.PrimaryPart.Position)

                if Dist <= Range then
                    return {
                        plr = v,
                        char = v.Character,
                        root = v.Character.PrimaryPart,
                    }
                end
            end
        end
    end
end

local Inventory = {
    getItem = function(item: string)
        for i,v in lplr.Backpack:GetChildren() do
            if v.Name:lower():find(item:lower()) then
                return v
            end
        end
        for _, v in lplr.Character:GetChildren() do
            if v.Name:lower():find(item:lower()) then
                return v
            end
        end
    end,
}

local AuraBoxInst = Instance.new('Part')
AuraBoxInst.Parent = workspace
AuraBoxInst.Size = Vector3.zero
AuraBoxInst.Transparency = 0.5
AuraBoxInst.Color = Color3.fromRGB(200, 0, 0)
AuraBoxInst.Material = Enum.Material.Neon
AuraBoxInst.CanCollide = false
AuraBoxInst.CanQuery = false
AuraBoxInst.CanTouch = false
AuraBoxInst.Anchored = true

local SwingAnim = Instance.new('Animation')
SwingAnim.AnimationId = 'rbxassetid://123800159244236'
local loadAnim = lplr.Character.Humanoid:LoadAnimation(SwingAnim)
local NewSound = ReplicatedStorage.ToolHandlers.Sword.Sounds.Swing1:Clone()
NewSound.Parent = workspace

lplr.CharacterAdded:Connect(function(character)
    repeat
        task.wait(1)
    until character ~= nil

    loadAnim = lplr.Character.Humanoid:LoadAnimation(SwingAnim)
end)

local lastJumped, lastAttacked = tick(), tick()
Aura = Combat:CreateModule({
    ['Name'] = 'Aura',
    ['Function'] = function(callback)
        if callback then
            local lastHp = lplr.Character.Humanoid.Health
            Aura:Start(function()
                if isAlive(lplr) then
                    local Entity, Sword = getNearEntity(17), Inventory.getItem('Sword')

                    if Entity then
                        if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and (tick() - lastJumped) > 0.4 and AuraJump.Enabled then
                            lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X, 30, lplr.Character.PrimaryPart.Velocity.Z)
                            lastJumped = tick()
                        end

                        AuraBoxInst.CFrame = Entity.root.CFrame
                        TweenService:Create(AuraBoxInst, TweenInfo.new(0.25), {Size = Vector3.new(4, 5, 4)}):Play()

                        if Sword and (tick() - lastAttacked) > 0.2 then
                            if SwingSword.Enabled then
                                loadAnim:Stop()
                                loadAnim:Play()
                            end

                            if PlaySound.Enabled then
                               NewSound:Play() 
                            end

                            BedwarZ.EquipTool:FireServer(Sword.Name)
                            BedwarZ.SwordHit:FireServer(Sword.Name, Entity.char)

                            lastAttacked = tick()
                        end

                        lastHp = Entity.char.Humanoid.Health
                    else
                        TweenService:Create(AuraBoxInst, TweenInfo.new(0.25), {
                            Size = Vector3.zero
                        }):Play()
                    end
                end
            end)
        end
    end
})
TimedHits = Aura.CreateToggle({
    ['Name'] = 'Timed Hits',
})
AuraBox = Aura.CreateToggle({
    ['Name'] = 'Enemy Box',
})
SwingSword = Aura.CreateToggle({
    ['Name'] = 'Swing',
})
PlaySound = Aura.CreateToggle({
    ['Name'] = 'Play Sound',
})
AuraJump = Aura.CreateToggle({
    ['Name'] = 'Auto Jump',
})

Flight = Movement:CreateModule({
    ['Name'] = 'Flight',
    ['Function'] = function(callback)
        if callback then
            Flight:Start(function(deltaTime: number)
                if isAlive(lplr) then
                    local Velo = lplr.Character.PrimaryPart.Velocity
                    local setY = 0.8 + deltaTime

                    if Vertical.Enabled then
                        if UserInputService:IsKeyDown('Space') then
                            setY += 50
                        elseif UserInputService:IsKeyDown('LeftShift') then
                            setY -= 50
                        end
                    end

                    lplr.Character.PrimaryPart.Velocity = Vector3.new(Velo.X, setY, Velo.Z)
                end
            end)
        end
    end
})
Vertical = Flight.CreateToggle({
    ['Name'] = 'Vertical Fly',
})

Speed = Movement:CreateModule({
    ['Name'] = 'Speed',
    ['Function'] = function(callback)
        if callback then
            Speed:Start(function(deltaTime: number)
                pcall(function()
                    local MoveDir = lplr.Character.Humanoid.MoveDirection
                    local Velo = lplr.Character.PrimaryPart.AssemblyLinearVelocity
                    local SpeedVal = (AnticheatBypass.Enabled and 60 or 23) -- lplr.Character.Humanoid.WalkSpeed

                    if SpeedMode.Value == 'CFrame' then
                        SpeedVal -= lplr.Character.Humanoid.WalkSpeed

                        lplr.Character.PrimaryPart.CFrame += (MoveDir * SpeedVal * deltaTime)
                    elseif SpeedMode.Value == 'Velocity' then
                        lplr.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(MoveDir.X * SpeedVal, Velo.Y, MoveDir.Z * SpeedVal)
                    end
                end)
            end)
        end
    end
})
SpeedMode = Speed.CreatePicker({
    ['Name'] = 'Method',
    ['Options'] = {'CFrame', 'Velocity'}
})

Strafe = Player:CreateModule({
    ['Name'] = 'Strafe',
    ['Function'] = function(callback)
        if callback then
            Strafe:Start(function()
                pcall(function()
                    if Speed.Enabled and SpeedMode.Value == 'Velocity' or Longjump.Enabled then
                        return
                    end

                    local MoveDir = lplr.Character.Humanoid.MoveDirection
                    local WalkSpeed = lplr.Character.Humanoid.WalkSpeed
                    local Velo = lplr.Character.PrimaryPart.Velocity

                    lplr.Character.PrimaryPart.Velocity = Vector3.new(MoveDir.X * WalkSpeed, Velo.Y, MoveDir.Z * WalkSpeed)
                end)
            end)
        end
    end
})

local function roundPos(Position: Vector3)
    local X = math.floor(Position.X / 3) * 3
    local Y = math.floor(Position.Y / 3) * 3
    local Z = math.floor(Position.Z / 3) * 3

    return Vector3.new(X, Y, Z)
end

Scaffold = World:CreateModule({
    ['Name'] = 'Scaffold',
    ['Function'] = function(callback)
        if callback then
            Scaffold:Start(function()
                local Wool = Inventory.getItem('Wool')

                if Wool then
                    local Pos = roundPos(lplr.Character.PrimaryPart.Position - Vector3.new(0, 3.5, 0) + lplr.Character.Humanoid.MoveDirection * 1)

                    BedwarZ.PlaceBlock:FireServer(Wool.Name, 1, Pos)

                    local Clone = ReplicatedStorage.Blocks[Wool.Name]:Clone()
                    Clone.Parent = workspace
                    Clone.Position = Pos

                    task.delay(0.5, function()
                        Clone:Destroy()
                        Clone = nil
                    end)
                end
            end)
        end
    end
})

local HUDItems = {
    SessionInfo = nil,
}
local HUD = Visuals:CreateModule({
    ['Name'] = 'HUD',
    ['Function'] = function(callback)
        for i,v in HUDItems do
            v.Visible = callback
        end
    end
})

local InfoItems = {}
HUD.CreateToggle({
    ['Name'] = 'Session Info',
    ['Function'] = function(callback)
        if callback then
            if HUDItems.SessionInfo then
                return end;
            
            local Item = Instance.new('Frame')
            Item.Parent = GuiLibrary.ScreenGui
            Item.Position = UDim2.fromScale(0.035, 0.5325)
            Item.AnchorPoint = Vector2.new(0, 0.5)
            Item.Size = UDim2.fromScale(0.15, 0.125)
            Item.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Item.BackgroundTransparency = 0.2
            Item.BorderSizePixel = 0
            Item.Name = 'Session Info'
            local Sort = Instance.new('UIListLayout')
            Sort.Parent = Item
            Sort.SortOrder = Enum.SortOrder.LayoutOrder
            local TopFrame = Instance.new('Frame')
            TopFrame.Parent = Item
            TopFrame.Position = UDim2.fromOffset(0, -5)
            TopFrame.Size = UDim2.new(1, 0, 0, 5)
            TopFrame.BorderSizePixel = 0
            TopFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            local TopMiddle = Instance.new('TextLabel')
            TopMiddle.Parent = Item
            TopMiddle.Size = UDim2.fromScale(1, 0.2)
            TopMiddle.Position = UDim2.fromScale(0.5, 0)
            TopMiddle.AnchorPoint = Vector2.new(0.5, 0)
            TopMiddle.BackgroundTransparency = 1
            TopMiddle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TopMiddle.TextSize = 10
            TopMiddle.Text = 'Session Info'
            local KillsText = Instance.new('TextLabel')
            KillsText.Parent = Item
            KillsText.Size = UDim2.fromScale(1, 0.2)
            KillsText.BackgroundTransparency = 1
            KillsText.TextXAlignment = Enum.TextXAlignment.Left
            KillsText.TextColor3 = Color3.fromRGB(255, 255, 255)
            KillsText.TextSize = 9
            KillsText.Text = '  Kills: 0'
            local WinsText = Instance.new('TextLabel')
            WinsText.Parent = Item
            WinsText.Size = UDim2.fromScale(1, 0.2)
            WinsText.BackgroundTransparency = 1
            WinsText.TextXAlignment = Enum.TextXAlignment.Left
            WinsText.TextColor3 = Color3.fromRGB(255, 255, 255)
            WinsText.TextSize = 9
            WinsText.Text = '  Wins: 0'
            local BedsText = Instance.new('TextLabel')
            BedsText.Parent = Item
            BedsText.Size = UDim2.fromScale(1, 0.2)
            BedsText.BackgroundTransparency = 1
            BedsText.TextXAlignment = Enum.TextXAlignment.Left
            BedsText.TextColor3 = Color3.fromRGB(255, 255, 255)
            BedsText.TextSize = 9
            BedsText.Text = '  Beds broken: 0'

            HUDItems.SessionInfo = Item
            
            local totalKills, bedsBroken, Wins = 0, 0, 0
            table.insert(InfoItems, lplr.leaderstats.Kills:GetPropertyChangedSignal('Value'):Connect(function()
                if lplr.leaderstats.Kills.Value ~= 0 then
                    totalKills += 1
                    KillsText.Text = '  Kills: ' .. totalKills
                end
            end))

            table.insert(InfoItems, lplr.Stats['Total Beds Broken']:GetPropertyChangedSignal('Value'):Connect(function()
                bedsBroken += 1
                BedsText.Text = '  Beds broken: ' .. bedsBroken
            end))

            table.insert(InfoItems, lplr.Stats.Wins:GetPropertyChangedSignal('Value'):Connect(function()
                Wins += 1
                WinsText.Text = '  Wins: ' .. Wins
            end))
        else
            for i,v in InfoItems do
                if typeof(v) == 'RBXScriptConnection' then
                    v:Disconnect()
                else
                    v:Destroy()
                end
                table.remove(InfoItems, i)
            end

            HUDItems.SessionInfo:Destroy()
            HUDItems.SessionInfo = nil
        end
    end
})

local badMessages = {
    'hack',
    'exp',
    'wiz',
    'cheat'
}

local Strings = {
    Kill = {
        'no autumn? just use the skidded autumn (catware)',
        'autumn is discontinued, use catware',
    },
    Bed = {
        'nice bed',
    },
    badMessageResponses = {
        'cope me some more',
        'its not cheating if you dont get caught',
        'oh my aids rlly im haxing??!?!',
    },
}

local function sendMessage(msg: string)
    TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
end

local ATItems = {}
AutoToxic = Player:CreateModule({
    ['Name'] = 'AutoToxic',
    ['Function'] = function(callback)
        if callback then
            table.insert(ATItems, lplr.leaderstats.Kills:GetPropertyChangedSignal('Value'):Connect(function()
                if lplr.leaderstats.Kills.Value ~= 0 then
                    sendMessage(Strings.Kill[math.random(1, #Strings.Kill)])
                end
            end))
            table.insert(ATItems, lplr.Stats['Total Beds Broken']:GetPropertyChangedSignal('Value'):Connect(function()
                sendMessage(Strings.Bed[math.random(1, #Strings.Bed)])
            end))
            table.insert(ATItems, lplr.Stats.Wins:GetPropertyChangedSignal('Value'):Connect(function()
                sendMessage('gg ez')
            end))
        else
            for i, v in ATItems do
                v:Disconnect();
            end
        end
    end
})

local SpamMessages = {
    '"today we go fast flying in roblox bedwarz" says autumn client',
    'me when the 100 speed with autumn client',
    'get autumn client today',
    'autumn on top',
}

Spammer = Player:CreateModule({
    ['Name'] = 'Spammer',
    ['Function'] = function(callback)
        if callback then
            repeat
                if not Spammer.Enabled then
                    break end
                
                TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(SpamMessages[math.random(1, #SpamMessages)])
                task.wait(9)
            until not Spammer.Enabled
        end
    end
})

local function createClone()
    repeat task.wait() until lplr.Character ~= nil
    if lplr.Character.Humanoid.Health <= 0 then
        return
    end
    lplr.Character.Archivable = true
    local oldChar = lplr.Character
    local clone = lplr.Character:Clone()
    clone.Parent = workspace
    clone:SetAttribute("isClone", true)
    clone.Humanoid.DisplayName = " "
    
    for i,v in next, clone:GetDescendants() do
        for i2, v2 in next, lplr.Character:GetDescendants() do
            if v2:IsA('Decal') then
                v2.Transparency = 1
            end
            if (v:IsA("Part") or v:IsA("BasePart")) and (v2:IsA("Part") or v2:IsA("BasePart")) then
                local constraint = Instance.new("NoCollisionConstraint", v)
                constraint.Part0 = v
                constraint.Part1 = v2
                v2.Transparency = 1
            end
        end
    end

    oldChar.PrimaryPart.Transparency = 0.5
    pcall(function()
        oldChar.Head.face.Transparency = 1
    end)
    return clone, oldChar
end

local clone, oldChar
local events = {}
local function modifyCharacter(character)
    task.wait()
    clone, oldChar = createClone()
    local cam = workspace.CurrentCamera

    if clone then
        oldChar = lplr.Character
        cam.CameraSubject = clone
        lplr.Character = clone

        clone.Animate.Enabled = false
        clone.Animate.Enabled = true

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character, clone}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    
        local lastTP = tick()
        table.insert(events, RunService.Heartbeat:Connect(function(delta)
            if not clone or clone:FindFirstChild('PrimaryPart') then
                return end
            
            if not character or character:FindFirstChild('PrimaryPart') then
                return end
            
            pcall(function()
                if not isnetworkowner(character.PrimaryPart) then
                    clone.PrimaryPart.CFrame = character.PrimaryPart.CFrame
                else
                    if (tick() - lastTP) > 0.4 then
                        TweenService:Create(character.PrimaryPart, TweenInfo.new(0.55), {CFrame = clone.PrimaryPart.CFrame}):Play()
                        lastTP = tick()
                    end

                    character.PrimaryPart.CFrame = CFrame.new(character.PrimaryPart.CFrame.X, clone.PrimaryPart.CFrame.Y, character.PrimaryPart.CFrame.Z)
                    character.PrimaryPart.Velocity = Vector3.new(0, clone.PrimaryPart.Velocity.Y, 0)
                end
            end)
        end))
    end
end

local charAdded
AnticheatBypass = Exploit:CreateModule({
    ['Name'] = 'AnticheatBypass',
    ['Function'] = function(callback)
        if callback then
            charAdded = lplr.CharacterAdded:Connect(function(character)
                repeat task.wait(1) until character
                if character:GetAttribute("isClone") then return end
                
                modifyCharacter(character)
            end)

            if lplr.Character then
                modifyCharacter(lplr.Character)
            end
        else
            charAdded:Disconnect()

            for i,v in events do
                v:Disconnect()
            end
            for i,v in oldChar:GetChildren() do
                pcall(function()
                    v.Transparency = 0
                end)
            end
            lplr.Character = oldChar

            lplr.Character.PrimaryPart.Transparency = 1
            lplr.Character.Hitbox.Transparency = 1

            workspace.CurrentCamera.CameraSubject = lplr.Character
            clone:Remove()
        end
    end
})

local oldWs
local speedWasEnabled = false
Longjump = Movement:CreateModule({
    ['Name'] = 'Longjump',
    ['Function'] = function(callback)
        if callback then
            oldWs = lplr.Character.Humanoid.WalkSpeed
            lplr.Character.Humanoid.WalkSpeed = 0

            if Speed.Enabled then
                speedWasEnabled = true
                Speed:Toggle()
            end

            local startTick = tick()
            local startY = 30
            Longjump:Start(function(deltaTime)
                local MoveDir = lplr.Character.Humanoid.MoveDirection
                local expSpeed = (AnticheatBypass.Enabled and 60 or 23)

                if (tick() - startTick) < 0.35 then
                    lplr.Character.PrimaryPart.Velocity = Vector3.zero
                else
                    lplr.Character.PrimaryPart.Velocity = Vector3.new(MoveDir.X * expSpeed, startY, MoveDir.Z * expSpeed)
                    startY -= (45 * deltaTime)
                end
            end)
        else
            lplr.Character.Humanoid.WalkSpeed = oldWs

            if speedWasEnabled then
                speedWasEnabled = false
                Speed:Toggle()
            end
        end
    end
})

TargetStrafe = Combat:CreateModule({
    ['Name'] = 'TargetStrafe',
    ['Function'] = function(callback)
        if callback then
            local Angle = 0
            TargetStrafe:Start(function(deltaTime)
                local Nearest = getNearEntity(11)

                if Nearest then
                    Angle += math.rad(AnticheatBypass.Enabled and 1000 or 180) * deltaTime

                    local X = math.cos(Angle) * 7
                    local Z = math.sin(Angle) * 7

                    local expPos = Nearest.root.Position + Vector3.new(X, 0, Z)

                    if TSSmart.Enabled then
                        local ray = workspace:Raycast(expPos, Vector3.new(0, -10, 0))

                        if ray then
                            lplr.Character.PrimaryPart.CFrame = CFrame.new(expPos)
                        else
                            lplr.Character.PrimaryPart.CFrame = Nearest.root.CFrame
                        end
                    else
                        lplr.Character.PrimaryPart.CFrame = expPos
                    end

                    if TSRotation.Enabled then
                        lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(Nearest.root.Position.X, lplr.Character.PrimaryPart.CFrame.Y, Nearest.root.Position.Z))
                    end
                end
            end)
        end
    end
})
TSSmart = TargetStrafe.CreateToggle({
    ['Name'] = 'Smart'
})
TSRotation = TargetStrafe.CreateToggle({
    ['Name'] = 'Rotate Towards Target'
})

local function getNearestBed(Range: number)
    if workspace:FindFirstChild("BedsContainer") then
        for i, v in workspace.BedsContainer:GetChildren() do
            local Hitbox = v:FindFirstChild("BedHitbox")

            if Hitbox then
                local Dist = lplr:DistanceFromCharacter(Hitbox.Position)
                if Dist <= Range then
                    return Hitbox, Dist
                end
            end
        end
    end
end

if not BedwarZ.MathUtils then
    return end

local function snapToGrid(ray)
    if not ray then return Vector3.zero end
    return BedwarZ.MathUtils.Snap(ray.Position - ray.Normal * 1.5, 3)
end

local rayParamsBreaker = RaycastParams.new()
rayParamsBreaker.FilterDescendantsInstances = {workspace.BedsContainer}
rayParamsBreaker.FilterType = Enum.RaycastFilterType.Include
Breaker = World:CreateModule({
    ["Name"] = "Breaker",
    ["Function"] = function(callback)
        if callback then
            Breaker:Start(function()
                local Bed, Dist = getNearestBed(30)
                local Item = Inventory.getItem('Pickaxe')

                if Bed and Item and lplr.Character and lplr.Character.PrimaryPart then
                    local screenPos = workspace.CurrentCamera:WorldToViewportPoint(Bed.Position)
                    local vpoint = workspace.CurrentCamera:ViewportPointToRay(screenPos.X, screenPos.Y)
                    local ray = workspace:Raycast(vpoint.Origin, vpoint.Direction * 18, rayParamsBreaker)
                    local blockPos = snapToGrid(ray)

                    local fakeOrigin = blockPos + Vector3.new(0, 3, 0)
                    local fakeDirection = (blockPos - fakeOrigin).Unit

                    BedwarZ.MineBlock:FireServer(
                        Item.Name,
                        Bed.Parent,
                        blockPos,
                        fakeOrigin,
                        fakeDirection
                    )
                end
            end)
        end
    end
})

local old = SoundService.AmbientReverb
SoundReverb = World:CreateModule({
    ['Name'] = 'Sound Reverb',
    ['Function'] = function(callback)
        if callback then
            SoundService.AmbientReverb = Enum.ReverbType.SewerPipe
        else
            SoundService.AmbientReverb = old
        end
    end
})

FastPickup = World:CreateModule({
    ['Name'] = 'FastPickup',
    ['Function'] = function(callback)
        if callback then
            FastPickup:Start(function()
                for i,v in workspace.DroppedItemsContainer:GetChildren() do
                    local Dist = lplr:DistanceFromCharacter(v.Hitbox.Position)

                    if Dist <= 6 then
                        v:WaitForChild('Hitbox').CFrame = lplr.Character.PrimaryPart.CFrame - Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
})

Velocity = Combat:CreateModule({
    ['Name'] = 'Velocity',
    ['Function'] = function(callback)
        if callback then
            for i,v in BedwarZ.VeloUtils:GetChildren() do
                v:Destroy()
            end

            BedwarZ.VeloUtils.ChildAdded:Connect(function(c)
                c:Destroy()
            end)
        end
    end
})
    
]]