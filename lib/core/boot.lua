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
os.sleep(0.2) -- pretty cool when u look at what it loaded
term.clear()
TBBOOT.tbHead()
print("Registering paths...")
local pcfg = cfgParser.parse("./settings/paths.cfg")
_G.ENV_PATH = pcfg.envPath
_G.HELP_PATH = pcfg.helpPath
pcfg = nil
_G._OSVER = OSINF.version
_G._CEVER = OSINF.ce_ver
_G.cosshell = _G.COSSHELL
_G.shell = tbshell
_G.colors = _G.COSCOLORS
_G.reboot = function ()
    graphx.animations.rollingText("Rebooting", colors.white, 2, "center")
    graphx.fillScreen(colors.gray, graphx.buffer.layers.layer1)
    graphx.renderFrame()
    os.sleep(1)
    os.reboot()
end
_G.shutdown = function ()
    graphx.animations.rollingText("Bye!", colors.white, 6, "center")
    graphx.fillScreen(colors.gray, graphx.buffer.layers.layer1)
    graphx.renderFrame()
    os.sleep(1)
    os.shutdown()
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

function monTest(monitor)
    local colorList = {
        colors.white,
        colors.orange,
        colors.magenta,
        colors.lightBlue,
        colors.yellow,
        colors.lime,
        colors.pink,
        colors.gray,
        colors.lightGray,
        colors.cyan,
        colors.purple,
        colors.blue,
        colors.brown,
        colors.green,
        colors.red,
        colors.black
    }
    local oldTerminal = term.current()
    term.redirect(monitor)
    for _, color in ipairs(colorList) do
        graphx.fillScreen(color, graphx.buffer.layers.layer1)
        graphx.renderFrame(true)
        os.sleep(0.01)
    end
    graphx.clearAll()
    term.redirect(oldTerminal)
end

for _, monitor in ipairs(MONITORS) do
    monTest(monitor)
    monitor.clear()
    monitor.setCursorPos(1,1)
end
monTest = nil
dofile("lib/core/customentry.lua")
customentry()
if _G.CUSTOMENTRY == true then
    shutdown()
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
