local base = "https://raw.githubusercontent.com/catwareroblox/catware/refs/heads/main/"

local function getDownload(file)
    file = file:gsub('CatWare/', '')

    local suc, ret = pcall(function()
        return game:HttpGet(base .. file)
    end)

    return suc and ret or 'print("Failed to get ' .. file..'")'
end

local function downloadFile(file)
    file = 'CatWare/' .. file

    if not isfile(file) then
        writefile(file, getDownload(file))
    end

    repeat task.wait() until isfile(file)

    return readfile(file)
end

local function debugDownloadSuccess(file)
    local File = downloadFile(file)

    if isfile('CatWare/' .. file) then
        print('[CatWare]: Successfully downloaded', file)
    else
        print('[CatWare]: Failed to download', file)
    end

    return File
end

for i,v in {'CatWare', 'CatWare/Games', 'CatWare/Configs'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

debugDownloadSuccess('CatWareLibary.lua')

local Games = {'BedwarZ'}
for i,v in Games do
    debugDownloadSuccess('Games/'..v..'.lua')
end

return loadstring(debugDownloadSuccess('Main.lua'))()
