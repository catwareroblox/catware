local Library = loadfile("idk/Library.lua")()

local Main = Library.library.CreateTab("Main")
local Movement = Library.library.CreateTab("Movement")
local Utility = Library.library.CreateTab("Utility")

Fling = Main:CreateModule({
    ["Name"] = "Fling",
    ["Function"] = function(callback)
        if callback then
            print("hi im enabled")
        else
            print("disabled")
        end
    end
})

asd = Main:CreateModule({
    ["Name"] = "asd",
    ["Function"] = function(callback)
        if callback then
            print("hi im enabled")
        else
            print("disabled")
        end
    end
})