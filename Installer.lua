local baseOld = "https://raw.githubusercontent.com/catwareroblox/catware/refs/heads/main/"
local base = "http://github.com/catwareroblox/catware/refs/heads/main/"

local function getDownload(file)
    file = file:gsub('idk/', '')

    local suc, ret = pcall(function()
        return game:HttpGet(base .. file)
    end)

    return suc and ret or 'print("Failed to get ' .. file..'")'
end

local function downloadFile(file)
    file = 'idk/' .. file

    if not isfile(file) then
        writefile(file, getDownload(file))
    end

    repeat task.wait() until isfile(file)

    return readfile(file)
end

local function debugDownloadSuccess(file)
    local File = downloadFile(file)

    if isfile('idk/' .. file) then
        print('[idk]: Successfully downloaded', file)
    else
        print('[idk]: Failed to download', file)
    end

    return File
end

for i,v in {'idk', 'idk/games', 'idk/configs', 'idk/libraries'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

debugDownloadSuccess('Libary.lua')

local Games = {'bedwarZ', 'bedwars', 'washiez'}
for i,v in Games do
    debugDownloadSuccess('Games/'..v..'.lua')
end

return loadstring(debugDownloadSuccess('Main.lua'))()
