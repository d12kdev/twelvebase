-- This is called from the startup script
term.clear()

TBBOOT = {}

function TBBOOT.tbHead()
    term.setCursorPos(1,1)
    print("Powered by TwelveBase") -- DO NOT REMOVE THIS!
    print("Creating OS is easy\n")
end

dofile("./lib/core/disableterminate.lua")
dofile("./sysset/osinf.lua")

function TBBOOT.loadLibs()
    local directory = "./lib"
    local files = fs.list(directory)
    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            print("LOAD >>> " .. file)
            dofile(directory .. "/" .. file)
            os.sleep(0.1)
        end
    end
end

function TBBOOT.loadPkgLibs()
    local directory = "./pkglibs"
    local files = fs.list(directory)
    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            print("LOAD >>> " .. file)
            dofile(directory .. "/" .. file)
            os.sleep(0.1)
        end
    end
end

function TBBOOT.registerMonitors()
    -- Get a table of all peripheral names
    local peripheralNames = peripheral.getNames()

    -- Table to store monitor peripherals
    local monitors = {}

    -- Iterate through peripheral names and check if they are monitors
    for _, peripheralName in ipairs(peripheralNames) do
        if peripheral.getType(peripheralName) == "monitor" then
            table.insert(monitors, peripheral.wrap(peripheralName))
        end
    end

    -- Now 'monitors' contains all connected monitors
    -- You can iterate through 'monitors' to perform operations on each monitor
    for index, monitor in ipairs(monitors) do
        -- Do something with each monitor
        monitor.setTextScale(1)
        monitor.clear()
        monitor.setCursorPos(1, 1)
        monitor.write("TwelveBase INIT")
        monitor.setCursorPos(1,2)
        monitor.write("MONITOR N-" .. index)
        monitor.setCursorPos(1,1)
    end

    return monitors

end
LOADLIB = {}

function LOADLIB.info(msg)
    print("LOAD INFO: " .. msg)
end


TBBOOT.tbHead()
os.sleep(2)
term.clear()
TBBOOT.tbHead()
print("Creating important functions...")
function _G.err(errorMsg)
    if errorMsg == nil then
        errorMsg = "Unknown Error"
    end
    local oldColor = term.getTextColor()
    term.setTextColor(COSCOLORS.red)
    print(errorMsg)
    term.setTextColor(oldColor)
    error()
end
term.clear()
TBBOOT.tbHead()
print("Loading libraries...")
TBBOOT.loadLibs()
os.sleep(1) -- pretty cool when u look at what it loaded
term.clear()
TBBOOT.tbHead()
print("Registering paths...")
_G.ENV_PATH = cfgParser.parse("./settings/paths.cfg").envPath
_G._OSVER = OSINF.version
_G.cosshell = _G.COSSHELL
_G.shell = tbshell
_G.colors = _G.COSCOLORS
_G.reboot = function ()
    os.reboot()
end
term.clear()
TBBOOT.tbHead()
print("Registering monitors...")
_G.MONITORS = TBBOOT.registerMonitors()
TBBOOT.tbHead()
print("Loading package libraries...")
TBBOOT.loadPkgLibs()
os.sleep(1)
print("Cleaning up...")
TBBOOT = nil
LOADLIB = nil
OSINF = nil
COSSHELL = nil
term.clear()
print("Have a good day!")
os.sleep(1)
for _, monitor in ipairs(MONITORS) do
    monitor.clear()
    monitor.setCursorPos(1,1)
end
term.clear()
term.setCursorPos(1,1)
print("Running on-start files...")
for _, file in ipairs(fs.list("onstart")) do
    if string.find(file, "%.lua$") then
        local filePath = fs.combine("onstart", file)
        pcall(dofile, filePath)
    end
end
shell.start()
