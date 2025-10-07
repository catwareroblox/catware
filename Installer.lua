local cloneref = cloneref or function(obj)
    return obj
end
local httpService = cloneref(game:GetService('HttpService'))

local function wipeFolders()
    for _, v in {'catware', 'catwaregames', 'catwaregui'} do
        if isfolder(v) then
            for x, d in listfiles(v) do
                if string.find(d, 'commit.txt') then continue end
                
                if not isfolder(d) then
                    delfile(d)
                end
            end
        end
    end
end

local function downloadFile(file, read)
    url = file:gsub('catware', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/catwareroblox/catware/'..readfile('catwarecommit.txt')..'/'..url))
    end

    if read ~= nil and read == false then
        return
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for _, v in {'catware', 'catwaregames', 'catwaregui'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local commit = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/catwareroblox/catware/commits'))[1].sha
if not isfile('catwarecommit.txt') then
    writefile('catwarecommit.txt', commit)
elseif readfile('catwarecommit.txt') ~= commit then
    wipeFolders()
    writefile('catwarecommit.txt', commit)
end

repeat task.wait() until isfile('catwarecommit.txt')

downloadFile('catwaregui/catware.lua', false)
loadstring(downloadFile('catwaremain.lua'))()
