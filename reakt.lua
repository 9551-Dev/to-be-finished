local arg = ...
if arg ~= "noreq" then
    b = require("button").monitor
    s = require("strings")
end
local m = peripheral.find("monitor")
local r = peripheral.find("BigReactors-Reactor")
local c = peripheral.find("minecraft:chest")
local ins = {peripheral.find("bigreactors:tileentityreactoraccessport")}
local rin = ins[1]
local rout = ins[2]
local tArgs = {...}
local updatespeed = 1 --*higher speeds look better but buttons are less responsive #default = 1 max = ~,min = 0.08
local bootime = 1
local theme = {
    ["dblack"] = colors.black,
    ["dwhite"] = colors.white,
    ["dcyan"] = colors.cyan,
    ["dgray"] = colors.gray,
    ["dred"] = colors.red,
    ["dgreen"] = colors.green,
    ["dblue"] = colors.blue,
    ["dyellow"] = colors.yellow,
    ["dorange"] = colors.orange,
    ["fred"] = "red",
    ["fcyan"] = "cyan",
    ["fblack"] = "black",
    ["fgray"] = "gray",
    ["fwhite"] = "white",
    ["fgreen"] = "green",
    ["fblue"] = "blue",
    ["fyellow"] = "yellow",
    ["forange"] = "orange",
    ["borange"] = "1",
    ["bgray"] = "7",
    ["bwhite"] = "0",
    ["bred"] = "e",
    ["bblack"] = "f"
}

local bcols = {
    "white",
    "orange",
    "magenta",
    "light_blue",
    "yellow",
    "lime",
    "pink",
    "gray"
}
if arg == "pers" then
    textutils.pagedTabulate(peripheral.getNames())
end
local function reakt_lua()
    if tArgs[2] then
        m = peripheral.wrap(tArgs[1])
        r = peripheral.wrap(tArgs[2])
        c = peripheral.wrap(tArgs[3])
        rin = peripheral.wrap(tArgs[4])
        rout = peripheral.wrap(tArgs[5])
    else
        if arg ~= nil and not tArgs[2] then
            print("entered configuration mode press enter to exit")
            print("to skip peripheral just write s\n")
            print("peripherals list:")
            textutils.pagedTabulate(peripheral.getNames())
            print("")
            print("enter your monitor")
            local ins = read()
            if ins ~= "s" then
                m = peripheral.wrap(ins)
            end
            local function cancel()
                if ins == "" then
                    error("canceled", 0)
                end
            end
            cancel()
            print("enter your reactor")
            local ins = read()
            if ins ~= "s" then
                r = peripheral.wrap(ins)
            end
            print("enter your chest")
            local ins = read()
            if ins ~= "s" then
                c = peripheral.wrap(ins)
            end
            print("enter your input reactor port")
            local ins = read()
            if ins ~= "s" then
                rin = peripheral.wrap(ins)
            end
            print("enter your output reactor port")
            local ins = read()
            if ins ~= "s" then
                rout = peripheral.wrap(ins)
            end
        end
    end
    ----*peripheral check(--------
    if not m then
        local otc = term.getBackgroundColor()
        term.setBackgroundColor(theme["dblack"])
        error("you dont have a monitor attached !", 0)
        term.setBackgroundColor(otc)
    end
    m.setBackgroundColor(theme["dcyan"])
    if not r then
        m.setCursorPos(2, 5)
        m.setTextColor(theme["dwhite"])
        m.setBackgroundColor(theme["dblack"])
        m.clear()
        m.setTextScale(2)
        m.write("you dont have a reactor attached !")
        error("no detected reactor !", 0)
    end
    if not c then
        m.setCursorPos(2, 5)
        m.setTextColor(theme["dwhite"])
        m.setBackgroundColor(theme["dblack"])
        m.clear()
        m.setTextScale(1)
        m.write("you dont have a chest attached !")
        error("no chest detected !", 0)
    end
    if not rin then
        m.setCursorPos(2, 5)
        m.setTextColor(theme["dwhite"])
        m.setBackgroundColor(theme["dblack"])
        m.clear()
        m.setTextScale(1)
        m.write("no input/output port detected !")
        error("no ports detected !", 0)
    end
    if (not rout) and rin then
        m.setCursorPos(2, 5)
        m.setTextColor(theme["dwhite"])
        m.setBackgroundColor(theme["dblack"])
        m.clear()
        m.setTextScale(1)
        m.write("no or 1 input/output port detected !")
        error("no or 1 port detected !", 0)
    end
    ----*peripheral check)--------
    local mname = peripheral.getName(m)
    m.setTextScale(0.5)
    m.clear()
    m.setBackgroundColor(theme["dcyan"])
    m.setTextColor(theme["dcyan"])
    b.frame(mname, 3, 19, 97, 18, theme["fwhite"], theme["fcyan"], false)
    b.frame(mname, 30, 20, 40, 5, theme["fwhite"], theme["fred"], true)
    m.setCursorPos(42, 20)
    m.blit("reakt by 9551", string.rep(theme["borange"], 13), string.rep(theme["bgray"], 13))
    m.setCursorPos(37, 21)
    m.setBackgroundColor(theme["dred"])
    m.setTextColor(theme["dblack"])
    m.blit("reactor control program", string.rep(theme["borange"], 23), string.rep(theme["bgray"], 23))
    m.setCursorPos(38, 28)
    m.write("default peripherals used \25")
    m.setCursorPos(36, 29)
    m.write("reactor: " .. peripheral.getName(r))
    m.setCursorPos(36, 30)
    m.write("monitor: " .. peripheral.getName(m))
    m.setCursorPos(36, 31)
    m.write("chest: " .. peripheral.getName(c))
    m.setCursorPos(36, 32)
    m.write("r. in: " .. peripheral.getName(rin))
    m.setCursorPos(36, 33)
    m.write("r. out: " .. peripheral.getName(rout))
    local function topline()
        b.frame(mname, 5, 6, 70, 1, theme["fblack"], theme["fblack"])
        m.setTextColor(theme["dblack"])
        m.setCursorPos(6, 6)
        m.write("main")
        m.setCursorPos(11, 6)
        m.write("fuels")
        m.setCursorPos(17, 6)
        m.write("chest")
        m.setCursorPos(23, 6)
        m.write("rod control")
        m.setCursorPos(35, 6)
        m.write("energy control")
        m.setCursorPos(50, 6)
        m.write("energy info")
        m.setCursorPos(62, 6)
        m.write("settings")
    end
    local function setcol(x, text)
        local oldcol = m.getBackgroundColor()
        m.setBackgroundColor(theme["dgray"])
        m.setCursorPos(x + 1, 6)
        m.write(text)
        m.setBackgroundColor(oldcol)
    end
    local function maincard(x, text)
        topline()
        local oldcol = m.getBackgroundColor()
        m.setBackgroundColor(theme["dcyan"])
        b.frame(mname, 5, 22, 70, 14, theme["fblack"], theme["fgray"], true)
        m.setBackgroundColor(theme["dgray"])
        m.setCursorPos(x + 1, 8)
        m.blit(string.rep(" ", #text), string.rep(theme["bgray"], #text), string.rep(theme["bgray"], #text))
        m.setCursorPos(x + 1, 7)
        m.blit(string.rep(" ", #text), string.rep(theme["bgray"], #text), string.rep(theme["bgray"], #text))
        m.setTextColor(theme["dblack"])
        m.setBackgroundColor(theme["dcyan"])
        m.setCursorPos(x + #text + 1, 7)
        m.write("\149")
        m.setCursorPos(x + #text + 1, 8)
        m.setBackgroundColor(theme["dblack"])
        m.write(" ")
        m.setTextColor(theme["dcyan"])
        m.setBackgroundColor(theme["dblack"])
        m.setCursorPos(x, 7)
        m.write("\149")
        m.setCursorPos(x, 8)
        m.write(" ")
        m.setTextColor(theme["dblack"])
        m.setBackgroundColor(theme["dcyan"])
        setcol(x, text)
        m.setBackgroundColor(oldcol)
    end
    local function basemenu()
        m.setBackgroundColor(theme["dcyan"])
        b.frame(mname, 3, 20, 97, 18, theme["fblack"], theme["fcyan"], true)
        b.frame(mname, 80, 20, 15, 15, theme["fblack"], theme["fcyan"], true)
        b.frame(mname, 80, 20, 16, 15, theme["fblack"], theme["fcyan"], true)
        b.frame(mname, 81, 18, 14, 5, theme["fred"], theme["fblack"], false)
        m.setCursorPos(81, 13)
        m.blit("system", string.rep(theme["bwhite"], 6), string.rep(theme["bred"], 6))

        b.frame(mname, 81, 29, 14, 5, theme["fred"], theme["fblack"], false)
        m.setCursorPos(81, 24)
        m.blit("settings", string.rep(theme["bwhite"], 8), string.rep(theme["bred"], 8))
    end
    local function menuButtons(click)
        local oci = m.getBackgroundColor()
        local ocii = m.getTextColor()
        m.setBackgroundColor(theme["dblack"])
        m.setTextColor(theme["dwhite"])
        m.setCursorPos(81, 6)
        m.write("TABS \25")
        m.setBackgroundColor(oci)
        m.setTextColor(ocii)
        b.menu(mname, click, 1, 81, 7, theme["fblack"], theme["fred"], "main", "main", true, 5)
        b.menu(mname, click, 2, 81, 8, theme["fblack"], theme["fred"], "fuels", "fuels", true, 10)
        b.menu(mname, click, 3, 81, 9, theme["fblack"], theme["fred"], "chest", "chest", true, 16)
        b.menu(mname, click, 4, 81, 10, theme["fblack"], theme["fred"], "rod control", "rod control", true, 22)
        b.menu(mname, click, 5, 81, 11, theme["fblack"], theme["fred"], "energy control", "energy control", true, 34)
        b.menu(mname, click, 6, 81, 12, theme["fblack"], theme["fred"], "energy info", "energy info", true, 49)

        --------------*settings menu--------------
        m.setBackgroundColor(theme["dblack"])
        b.menu(mname, click, 7, 81, 25, theme["fwhite"], theme["fgreen"], "peripherals", "peripherals", true, 61)
        b.menu(mname, click, 8, 81, 26, theme["fwhite"], theme["fgreen"], "reactor set.", "reactor set.", true, 61)
        --*---------------------------------------
        m.setTextColor(theme["dwhite"])
        if b.button(mname, click, 81, 14, ">shutdown<") then
            m.setBackgroundColor(theme["dblack"])
            m.setTextColor(theme["dwhite"])
            m.clear()
            m.setCursorPos(70, 14)
            m.write("shutting down.")
            sleep(bootime / 3)
            m.setCursorPos(70, 14)
            m.write("shutting down..")
            sleep(bootime / 3)
            m.setCursorPos(70, 14)
            m.write("shutting down...")
            sleep(bootime / 3)
            m.clear()
            os.shutdown()
        end
        if b.button(mname, click, 81, 15, ">reboot<") then
            m.setBackgroundColor(theme["dblack"])
            m.setTextColor(theme["dwhite"])
            m.clear()
            m.setCursorPos(70, 14)
            m.write("rebooting.")
            sleep(bootime / 3)
            m.setCursorPos(70, 14)
            m.write("rebooting..")
            sleep(bootime / 3)
            m.setCursorPos(70, 14)
            m.write("rebooting...")
            sleep(bootime / 3)
            m.clear()
            os.reboot()
        end
        if b.button(mname, click, 81, 16, ">upd. reakt<") then
            shell.run("rename reactor.lua oldreakt")
            shell.run("pastebin get 9kNdJ0DH reactor.lua")
            shell.run("rm oldreakt")
            os.reboot()
        end
        if b.button(mname, click, 81, 17, ">multi reakt<") then
            _G.b = {}
            _G.s = {}
            for k, v in pairs(b) do
                _G.b[k] = v
            end
            for k, v in pairs(s) do
                _G.s[k] = v
            end
            multishell.launch({}, "./reactor.lua", "noreq")
            m.clear()
            m.setBackgroundColor(theme["dred"])
            m.setTextColor(theme["dwhite"])
            m.setCursorPos(65, 18)
            m.write("continue the setup in the computer")
            sleep(3)
            basemenu()
            topline()
            menuButtons({"monitor_touch", mname, 1000, 1000})
        end
        m.setBackgroundColor(theme["dcyan"])
        local out = b.menudata()
        if (type(out[2]) == "number") and (out[1]) then
            maincard(out[2], out[1])
        end
    end
    sleep(bootime)
    basemenu()
    topline()
    --*-----------------main programs----------------
    local function mmain(click)
        m.setBackgroundColor(theme["dgray"])
        b.frame(mname, 9, 13, 42, 3, theme["fblack"], theme["fblue"], false)
        m.setCursorPos(9, 10)
        m.blit("power (control rods)", string.rep(theme["bwhite"], 20), string.rep(theme["bblack"], 20))
        b.sliderHor(mname, click, 1, 11, 13, 37, theme["fblue"], theme["fwhite"])
        if (b.sliderHor("db", 1) * 2.75) - 30 >= 0 then
            local rods = (math.ceil(b.sliderHor("db", 1) * 2.75) - 30)
            r.setAllControlRodLevels(100 - rods)
            if rods < 20 then
                m.setBackgroundColor(theme["dred"])
            elseif rods < 40 then
                m.setBackgroundColor(theme["dorange"])
            elseif rods < 60 then
                m.setBackgroundColor(theme["dyellow"])
            elseif rods < 80 then
                m.setBackgroundColor(theme["dcyan"])
            else
                m.setBackgroundColor(theme["dgreen"])
            end
            m.setCursorPos(b.sliderHor("db", 1), 12)
            m.write(tostring(rods))
        else
            b.sliderHor("setdb", 1, 11)
        end
        local temp = math.floor(r.getFuelTemperature())
        local energy = math.floor(r.getEnergyProducedLastTick() * 10)
        if maxtemp then
            maxtemp = math.max(maxtemp, temp)
        else
            maxtemp = 0
            maxtemp = math.max(maxtemp, temp)
        end
        if maxenergy then
            maxenergy = math.max(maxenergy, energy)
        else
            maxenergy = 1
            maxenergy = math.max(maxenergy, energy)
        end
        m.setBackgroundColor(theme["dgray"])
        b.frame(mname, 58, 14, 15, 2, theme["fblack"], theme["fred"], false)
        m.setTextColor(theme["dwhite"])
        m.setBackgroundColor(theme["dred"])
        if b.button(mname, click, 62, 13, "heat/C") then
            maxtemp = math.floor(r.getFuelTemperature())
        end
        if b.button(mname, click, 62, 14, "energy") then
            maxenergy = math.floor(r.getEnergyProducedLastTick() * 10)
        end
        if b.button(mname, click, 62, 15, "power") then
            b.sliderHor("setdb", 1, 10)
        end
        m.setBackgroundColor(theme["dgray"])
        m.setCursorPos(58, 12)
        m.blit("resets", string.rep(theme["bwhite"], 6), string.rep(theme["bblack"], 6))
        m.setTextColor(theme["dwhite"])
        m.setCursorPos(61, 10)
        m.write("reactor:")
        b.frame(mname, 70, 10, 4, 1, theme["fblack"], theme["fblue"])
        b.switchn(mname, 1, click, 70, 10, theme["fred"], theme["fgreen"], theme["fwhite"], "off", "on")
        r.setActive(b.switchn("db", 1))
        b.bar(
            mname,
            9,
            25,
            12,
            8,
            temp,
            maxtemp,
            theme["fgray"],
            theme["fred"],
            theme["fblack"],
            true,
            true,
            "",
            false,
            true,
            false
        )
        b.bar(
            mname,
            23,
            25,
            14,
            8,
            energy,
            maxenergy,
            theme["fgray"],
            theme["fyellow"],
            theme["fblack"],
            true,
            true,
            "",
            false,
            true,
            false
        )
        b.bar(
            mname,
            39,
            25,
            12,
            8,
            math.floor((r.getFuelAmount() / 1000)),
            math.floor(r.getFuelAmountMax() / 1000),
            theme["fgray"],
            theme["fgreen"],
            theme["fblack"],
            true,
            true,
            "B",
            false,
            true,
            false
        )
        m.setCursorPos(9, 17)
        m.blit("heat", string.rep(theme["bwhite"], 4), string.rep(theme["bblack"], 4))
        m.setCursorPos(23, 17)
        m.blit("RF/S", string.rep(theme["bwhite"], 4), string.rep(theme["bblack"], 4))
        m.setCursorPos(39, 17)
        m.blit("fuel", string.rep(theme["bwhite"], 4), string.rep(theme["bblack"], 4))

        b.frame(mname, 52, 22, 22, 5, theme["fblack"], theme["fred"], false)
        m.setCursorPos(52, 17)
        m.blit("main info", string.rep(theme["bwhite"], 9), string.rep(theme["bblack"], 9))
        m.setBackgroundColor(theme["dred"])
        m.setTextColor(theme["dwhite"])
        m.setCursorPos(52, 18)
        m.write("reactivity: " .. math.floor(r.getFuelReactivity()) .. "%")
        m.setCursorPos(52, 19)
        m.write("energy out: " .. math.floor(r.getEnergyProducedLastTick()) .. "rf/t")
        m.setCursorPos(52, 20)
        m.write("fuel: " .. math.floor(r.getFuelAmount()) .. "mb")
        m.setCursorPos(52, 21)
        m.write("fuel temp: " .. math.floor(r.getFuelTemperature()) .. "C")
        m.setCursorPos(52, 22)
        m.write("casing temp: " .. math.floor(r.getCasingTemperature()) .. "C")
        m.setCursorPos(52, 23)
        m.write("temp diff: " .. math.floor(r.getFuelTemperature() - r.getCasingTemperature()) .. "C")
        m.setCursorPos(52, 24)
        m.write("waste out: " .. s.ensure_width(tostring(r.getFuelConsumedLastTick()), 6) .. "mb/t")
        m.setCursorPos(52, 25)
        m.write("waste: " .. math.floor(r.getWasteAmount()) .. "mb")
        m.setBackgroundColor(theme["dgray"])
        b.bar(
            mname,
            52,
            31,
            22,
            3,
            r.getEnergyStored(),
            r.getEnergyCapacity(),
            "gray",
            "red",
            "black",
            true,
            true,
            "",
            false,
            true,
            false
        )
        m.setCursorPos(52, 28)
        m.blit("energy storage", string.rep(theme["bwhite"], 14), string.rep(theme["bblack"], 14))
    end
    local function mpers(click)
        local function selection(ins)
            while true do
                local click = b.timetouch(updatespeed, mname)
                m.setBackgroundColor(theme["dgray"])
                b.frame(mname, 8, 22, 63, 12, theme["fblack"], theme["fblue"], false)
                m.setBackgroundColor(theme["dred"])
                m.setCursorPos(22, 10)
                m.write("what kind of peripheral is this ?")
                m.setCursorPos(20, 11)
                m.write(ins)
                if b.button(mname, click, 35, 21, "|BACK|") then
                    break
                end
                m.setBackgroundColor(theme["dgreen"])
                if b.button(mname, click, 28, 15, "monitor") then
                    m.setBackgroundColor(theme["dblack"])
                    m.clear()
                    m.setBackgroundColor(theme["dcyan"])
                    m = peripheral.wrap(ins)
                    m.setTextScale(0.5)
                    mname = ins
                    menuButtons(click)
                    basemenu()
                    topline()
                    break
                end
                if b.button(mname, click, 36, 15, "reactor") then
                    r = peripheral.wrap(ins)
                    break
                end
                if b.button(mname, click, 40, 17, "r. input <") then
                    rin = peripheral.wrap(ins)
                    break
                end
                if b.button(mname, click, 28, 17, "r. output >") then
                    rout = peripheral.wrap(rout)
                    break
                end
                if b.button(mname, click, 44, 15, "chest") then
                    c = peripheral.wrap(ins)
                    break
                end
            end
        end
        m.setBackgroundColor(theme["dgray"])
        b.frame(mname, 8, 22, 30, 12, theme["fblack"], theme["fgreen"], false)
        b.frame(mname, 41, 22, 30, 12, theme["fblack"], theme["fred"], false)
        m.setBackgroundColor(theme["dgreen"])
        b.frame(mname, 10, 14, 26, 2, theme["fblack"], theme["fblue"], false)
        m.setCursorPos(10, 12)
        m.blit("monitor :", string.rep(theme["bwhite"], 9), string.rep(theme["bblack"], 9))
        b.frame(mname, 10, 19, 26, 2, theme["fblack"], theme["fblue"], false)
        m.setCursorPos(10, 17)
        m.blit("reactor :", string.rep(theme["bwhite"], 9), string.rep(theme["bblack"], 9))
        b.frame(mname, 10, 24, 26, 2, theme["fblack"], theme["fblue"], false)
        m.setCursorPos(10, 22)
        m.blit("chest :", string.rep(theme["bwhite"], 7), string.rep(theme["bblack"], 7))
        b.frame(mname, 10, 30, 26, 3, theme["fblack"], theme["fblue"], false)
        m.setCursorPos(10, 27)
        m.blit("input/output :", string.rep(theme["bwhite"], 14), string.rep(theme["bblack"], 14))

        m.setCursorPos(8, 10)
        m.blit("active :", string.rep(theme["bwhite"], 8), string.rep(theme["bblack"], 8))
        m.setCursorPos(41, 10)
        m.blit("all found :", string.rep(theme["bwhite"], 11), string.rep(theme["bblack"], 11))
        m.setBackgroundColor(theme["dblue"])
        m.setCursorPos(11, 14)
        m.write(peripheral.getName(m))
        m.setCursorPos(11, 19)
        m.write(peripheral.getName(r))
        m.setCursorPos(11, 24)
        m.write(peripheral.getName(c))
        m.setCursorPos(11, 29)
        m.write("I: " .. string.sub(peripheral.getName(rin), 23))
        m.setCursorPos(11, 31)
        m.write("O: " .. string.sub(peripheral.getName(rout), 23))
        local pers = peripheral.getNames()
        local sc = 11
        m.setTextColor(theme["dblack"])
        m.setBackgroundColor(theme["dred"])
        for i = 1, #pers do
            if peripheral.getType(pers[i]) == "bigreactors:tileentityreactoraccessport" then
                pers[i] = string.sub(pers[i], 23)
            end
            if b.button(mname, click, 42, sc + i, pers[i]) then
                if s.ensure_width(pers[i], 18) == "reactoraccessport_" then
                    pers[i] = "bigreactors:tileentityreactoraccessport_" .. string.sub(pers[i], 19)
                end
                selection(pers[i])
            end
        end
    end
    local function mfuel(click)
        b.frame(mname, 30, 20, 10, 5, theme["fblack"], theme["fgray"], true)
    end
    local function mchest(click)
    end
    local function mrod(click)
        b.frame(mname, 30, 20, 10, 5, theme["fblack"], theme["fgray"], true)
    end
    local function menergyc(click)
        b.frame(mname, 30, 20, 10, 5, theme["fblack"], theme["fgray"], true)
    end
    local function menergyi(click)
        b.frame(mname, 30, 20, 10, 5, theme["fblack"], theme["fgray"], true)
    end
    local function mreactor(click)
        b.frame(mname, 30, 20, 10, 5, theme["fblack"], theme["fgray"], true)
    end
    --*----------------------------------------------
    local function peripheralsmenu()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mpers(click)
        until ins ~= "peripherals"
        m.setBackgroundColor(oc)
    end
    local function main()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mmain(click)
        until ins ~= "main"
        m.setBackgroundColor(oc)
    end
    local function fuels()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mfuel(click)
        until ins ~= "fuels"
        m.setBackgroundColor(oc)
    end
    local function chest()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mchest(click)
        until ins ~= "chest"
        m.setBackgroundColor(oc)
    end
    local function rodcontrol()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mrod(click)
        until ins ~= "rod control"
        m.setBackgroundColor(oc)
    end
    local function energyc()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            menergyc(click)
        until ins ~= "energy control"
        m.setBackgroundColor(oc)
    end
    local function energyinf()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            menergyi(click)
        until ins ~= "energy info"
        m.setBackgroundColor(oc)
    end
    local function reactorsettings()
        local oc = m.getBackgroundColor()
        repeat
            local ins = b.menudata()
            local click = b.timetouch(updatespeed, mname)
            menuButtons(click)
            mreactor(click)
        until ins ~= "reactor set."
        m.setBackgroundColor(oc)
    end

    menuButtons({"monitor_touch", mname, 83, 7})
    while true do
        local menuout = b.menudata()
        if menuout[1] == "peripherals" then
            peripheralsmenu()
        end
        if menuout[1] == "main" then
            main()
        end
        if menuout[1] == "fuels" then
            fuels()
        end
        if menuout[1] == "chest" then
            chest()
        end
        if menuout[1] == "rod control" then
            rodcontrol()
        end
        if menuout[1] == "energy control" then
            energyc()
        end
        if menuout[1] == "energy info" then
            energyinf()
        end
        if menuout[1] == "reactor set." then
            reactorsettings()
        end
    end
end
if arg ~= "pers" then
    local ok, err = pcall(reakt_lua)
    if not ok then
        print("reakt has crashed. reason:\n" .. err)
    end
end
