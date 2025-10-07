
local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local starterPlayer = cloneref(game:GetService('StarterPlayer'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local starterGui = cloneref(game:GetService('StarterGui'))

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if runService:IsStudio() then
    if not shared then
        getfenv().shared = getfenv()
    end
end

local ids = {
    [17750024818] = '17750024818.lua',
    [122483927964273] = '122483927964273.lua',
    [71480482338212] = '71480482338212.lua',
    [6872274481] = '6872274481.lua',
    [8444591321] = '6872274481.lua',
    [8560631822] = '6872274481.lua'
}

local function downloadFile(file)
    url = file:gsub('catware/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/catwareroblox/catware'..readfile('catware/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if i == game.PlaceId then
        return loadstring(downloadFile('catware/games/'..v))()
    end
end

return loadstring(downloadFile('catware/games/universal.lua'))()
