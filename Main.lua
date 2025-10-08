local Library = loadfile("idk/Library.lua")()

local games = {
    ["bedwars"] = {6872274481, 8444591321, 8560631822},
    ["bedwarZ"] = {71480482338212},
    ["washiez"] = {6764533218},
}

for gamename, v in games do
    for _, id in v do
        if game.PlaceId == id then
            loadfile("idk/games/"..gamename..".lua")()
        end
    end
end
