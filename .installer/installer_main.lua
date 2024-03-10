-- work only with craftos libs. This is installer. No TwelveBase libraries are included there.

term.clear()
term.setCursorPos(1,1)

function yN()
    local done = false
    local opt = false
    while done == false do
        term.clear()
        term.setCursorPos(1,1)
        if opt == false then
            print("TwelveBase Installation Program\n")
            print("Are you sure you want to install the OS (this will delete your startup folder or the startup file)?")
            print(" YES >NO< ")
        else
            print("TwelveBase Installation Program\n")
            print("Are you sure you want to install the OS (this will delete your startup folder or the startup file)?")
            print(" >YES< NO ")
        end
        local event, key, held = os.pullEvent("key")
        if keys.getName(key) == "right" and held == false then
            opt = false
        elseif keys.getName(key) == "left" and held == false then
            opt = true
        elseif keys.getName(key) == "enter" then
            done = true
        end
    end
    return opt
end

print("TwelveBase Installation Program\n")
print("Are you sure you want to install the OS (this will delete your startup folder or the startup file)?")
local confirm = yN()

if confirm ~= true then
    error("Installation cancelled.")
end

if fs.exists("./startup") then
    fs.delete("./startup")
elseif fs.exists("./startup.lua") then
    fs.delete("./startup.lua")
end

-- this will be replaced with the installation code by export.py
{{TBEXPORT_CODE}}

local isec = 0
repeat
    term.clear()
    term.setCursorPos(1,1)
    print("Rebooting in ".. (3 - isec) .." second(s)")
    isec = isec + 1
    os.sleep(1)
until isec >= 3
os.reboot()
