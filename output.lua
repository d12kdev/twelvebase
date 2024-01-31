-- work only with craftos libs. This is installer. No TwelveBase libraries are included there.

term.clear()
term.setCursorPos(1,1)

print("TwelveBase Installation Program\n")
print("Are you sure you want to install the OS (this will delete your startup folder or the startup file)? [y/n] ")
local confirm = read()

if confirm ~= "y" then
    error("Installation cancelled.")
end

if fs.exists("./startup") then
    fs.delete("./startup")
elseif fs.exists("./startup.lua") then
    fs.delete("./startup.lua")
end

-- this will be replaced with the installation code by export.py
shell.run("mkdir", "bin")
local file = fs.open("bin/hw.lua", "w")
file.write('print("Hello, World!")')
file.close()
local file = fs.open("bin/luash.lua", "w")
file.write('cosshell.run("lua")')
file.close()
local file = fs.open("bin/pathedit.lua", "w")
file.write('if(COMMAND_ARGS[1] == "add") then\n    print("add!")\nend')
file.close()
local file = fs.open("bin/pkg.lua", "w")
file.write('if(COMMAND_ARGS[1] == "install" or COMMAND_ARGS[1] == "i" and COMMAND_ARGS[2] ~= nil) then\n    pkgManager.install(COMMAND_ARGS[2])\nend')
file.close()
local file = fs.open("bin/reboot.lua", "w")
file.write('reboot()')
file.close()
local file = fs.open("bin/shutdown.lua", "w")
file.write('os.shutdown()')
file.close()
shell.run("mkdir", "home")
shell.run("mkdir", "lib")
local file = fs.open("lib/cfgparser.lua", "w")
file.write('_G.cfgParser = {}\n\nfunction cfgParser.parse(filename)\n    local config = {}\n    local file = io.open(filename, "r")\n\n    if file then\n        for line in file:lines() do\n            local key, value = line:match("(%w+)%s*=%s*(.*)")\n            if key and value then\n                -- Check if the value is an array\n                local arrayValues = value:match("{(.-)}")\n                if arrayValues then\n                    -- Split the array values and store them in a Lua table\n                    local arrayTable = {}\n                    for v in arrayValues:gmatch("[^,%s]+") do\n                        table.insert(arrayTable, tonumber(v) or v)\n                    end\n                    config[key] = arrayTable\n                else\n                    config[key] = tonumber(value) or value\n                end\n            end\n        end\n        file:close()\n    else\n        print("Error: Unable to open the .cfg file")\n    end\n\n    return config\nend\n\nfunction cfgParser.parseString(inputString)\n    local config = {}\n\n    for line in inputString:gmatch("[^\\r\\n]+") do\n        local key, value = line:match("(%w+)%s*=%s*(.*)")\n        if key and value then\n            -- Check if the value is an array\n            local arrayValues = value:match("{(.-)}")\n            if arrayValues then\n                -- Split the array values and store them in a Lua table\n                local arrayTable = {}\n                for v in arrayValues:gmatch("[^,%s]+") do\n                    table.insert(arrayTable, tonumber(v) or v)\n                end\n                config[key] = arrayTable\n            else\n                config[key] = tonumber(value) or value\n            end\n        end\n    end\n\n    return config\nend\n')
file.close()
local file = fs.open("lib/fop.lua", "w")
file.write('_G.fop = {}\n-- (File operations)\n\nfop.file = {}\nfunction fop.file.copyForEach(srcDir, destDir)\n    local directory = srcDir\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        fs.copy(srcDir .. "/" .. fs.getName(file), destDir .. "/" .. fs.getName(file))\n    end\nend')
file.close()
local file = fs.open("lib/graphics.lua", "w")
file.write('_G.graphx = {}\n\n_G.graphx.buffer = {}\n_G.graphx.buffer.layers = {\n    ["layer1"] = {},\n    ["layer2"] = {},\n    ["layer3"] = {},\n    ["layer4"] = {},\n}\n\n_G.graphx.buffer.system_layer = {}\n\n\nfunction graphx.packXY(x, y)\n    return {x,y}\nend\n\nfunction graphx.drawPx(xy, color, layer)\n    local x = xy[1]\n    local y = xy[2]\n    local clr = nil\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    if type(color) == "string" then\n        clr = colors.fromBlit(color)\n    elseif type(color) == "number" then\n        clr = color\n    else\n        clr = colors.white\n    end\n\n    table.insert(layer, {x, y, "px", clr})\nend\n\nfunction graphx.clearScreen()\n    term.clear()\n    term.setCursorPos(1,1)\nend\n\n\nfunction graphx.clearAll()\n\nend\n\nfunction graphx.drawText(startXY, text, color, layer)\n    local x,y = startXY[1], startXY[2]\n    local clr = nil\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    if type(color) == "string" then\n        clr = colors.fromBlit(color)\n    elseif type(color) == "number" then\n        clr = color\n    else\n        clr = colors.white\n    end\n\n    table.insert(layer, {x,y,"text", {text, color}})\nend\n\nfunction graphx.drawLine(startXY, endXY, color, layer)\n    local x1, y1 = startXY[1], startXY[2]\n    local x2, y2 = endXY[1], endXY[2]\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    local dx = math.abs(x2 - x1)\n    local dy = math.abs(y2 - y1)\n    local sx, sy\n\n    if x1 < x2 then\n        sx = 1\n    else\n        sx = -1\n    end\n\n    if y1 < y2 then\n        sy = 1\n    else\n        sy = -1\n    end\n\n    local err = dx - dy\n\n    while true do\n        graphx.drawPx(graphx.packXY(x1, y1), color, layer)\n\n        if x1 == x2 and y1 == y2 then\n            break\n        end\n\n        local e2 = 2 * err\n\n        if e2 > -dy then\n            err = err - dy\n            x1 = x1 + sx\n        end\n\n        if e2 < dx then\n            err = err + dx\n            y1 = y1 + sy\n        end\n    end\nend\n\n\n\nfunction graphx.renderFrame()\n    graphx.clearScreen()\n    for _, layer in pairs(graphx.buffer.layers) do\n        for _, renderObject in ipairs(layer) do\n            local x = renderObject[1]\n            local y = renderObject[2]\n            local objType = renderObject[3]\n            local color = renderObject[4]\n\n            if objType == "px" then\n                term.setCursorPos(x,y)\n                local oldColor = term.getBackgroundColor()\n                term.setBackgroundColor(color)\n                term.write(" ")\n                term.setBackgroundColor(oldColor)\n            elseif objType == "text" then\n                local props = color\n                local text = props[1]\n                local color = props[2]\n                local oldPos = term.getCursorPos()\n                local oldTextColor = term.getTextColor()\n                local oldBkgColor = term.getBackgroundColor()\n                term.setCursorPos(x,y)\n                for i = 1, #text do\n                    local letter = text:sub(i,i)\n                    term.setBackgroundColor(term.getBackgroundColor())\n                    term.setTextColor(color)\n                    term.write(letter)\n                end\n                term.setCursorPos(oldPos)\n                term.setTextColor(oldTextColor)\n                term.setBackgroundColor(oldBkgColor)\n            end\n        end\n    end\n    term.setCursorPos(1,1)\nend')
file.close()
local file = fs.open("lib/pkgmanager.lua", "w")
file.write('_G.pkgManager = {}\n\nfunction pkgManager.install(packageDirectory)\n    local isDir = fs.isDir(packageDirectory)\n    if isDir == false then\n        err("Package must be a directory (or a disk)")\n    end\n\n    local packageFile = nil\n\n    if fs.exists(packageDirectory .. "/.tbpkg") then\n        local tempPkgFile = fs.open(packageDirectory .. "/.tbpkg", "r")\n\n        if tempPkgFile then\n            packageFile = tempPkgFile.readAll()\n            tempPkgFile.close()\n        else\n            err("Cannot read the package file")\n        end\n    end\n\n    if packageFile == nil then\n        err("Package file is (somehow) nil")\n    end\n\n    local packageSettings = cfgParser.parseString(packageFile)\n\n    if packageSettings.name == nil or packageSettings.version == nil then\n        err("INVALID PACKAGE: Some of the important settings of the package are not defined.")\n    end\n\n    local modifyPath = fs.isDir(packageDirectory .. "/bin")\n    local modifyLibs = fs.isDir(packageDirectory .. "/lib")\n\n    if modifyLibs == false and modifyPath == false then\n        err("INVALID PACKAGE: None of the directories (bin, lib) were modified. At least 1 dir must be modified")\n    end\n\n    if modifyLibs then\n        fop.file.copyForEach(packageDirectory .. "/lib", "pkglibs")\n    end\n\n    if modifyPath then\n        fop.file.copyForEach(packageDirectory .. "/bin", "pkgbin")\n    end\n\n    print("Installation done.")\n\n    if modifyLibs == true then\n        print("\\nThe package you installed includes its own libraries, to register the libraries the system needs to reboot.")\n        term.write("Reboot? [y/n] ")\n        local rebootConfirm = read()\n        if rebootConfirm == "y" then\n            reboot()\n        else\n            print("This can lead to errors. Please consider rebooting (later).")\n        end\n    end\n\nend')
file.close()
local file = fs.open("lib/shell.lua", "w")
file.write('_G.tbshell = {}\n\nfunction tbshell.execute(name, args)\n    local CMDFOUND = false\n    local CMDPATH = nil\n\n\n    for _, binPath in ipairs(ENV_PATH) do\n        local directory = binPath\n        local files = fs.list(directory)\n        for _, file in ipairs(files) do\n            if file:match("%.lua$") then\n                if fs.getName(file) == name .. ".lua" then\n                    CMDPATH = directory.. "/".. file\n                    CMDFOUND = true\n                    break\n                end\n            end\n        end\n    end\n\n    if(CMDFOUND) then\n        _G.COMMAND_ARGS = args\n        local success = pcall(dofile, CMDPATH)\n        if not success then\n            print("ERROR EXECUTING COMMAND")\n            return false\n        end\n        return true\n    else\n        return false\n    end\n\nend\n\nfunction tbshell.getCompletions()\n    local result = {}\n    for _, binPath in ipairs(ENV_PATH) do\n        local directory = binPath\n        local files = fs.list(directory)\n        for _, file in ipairs(files) do\n            if file:match("%.lua$") then\n                local fileNameWithoutExtension = file:sub(1, -5) -- Remove the last 4 characters (".lua")\n                table.insert(result, fileNameWithoutExtension)\n            end\n        end\n    end\nend\n\nfunction tbshell.start()\n    term.clear()\n    term.setCursorPos(1, 1)\n    term.write(_OSVER)\n    tbshell.start = nil\n    _G.CWD = "/home"\n    local _, screenHeight = term.getSize()\n    local history = {}\n    while true do\n        term.write("> ")\n        local command = read(nil, history)\n        local canRun = true\n        if command == "" then\n            canRun = false\n        end\n        if canRun then\n            local cargs = {}\n            for token in string.gmatch(command, "[^" .. " " .. "]+") do\n                table.insert(cargs, token)\n            end\n            local commandName = cargs[1]\n            table.remove(cargs, 1)\n            local cmdStatus = tbshell.execute(commandName, cargs)\n            if cmdStatus == false then\n                print("Command not found")\n            else\n                table.insert(history, command)\n            end\n        end\n    end\n    print("ERR")\nend')
file.close()
local file = fs.open("lib/tbfs.lua", "w")
file.write('_G.tbfs = {}\n\nfunction tbfs.makeDir(dirPath)\n\nend')
file.close()
shell.run("mkdir", "lib/core")
local file = fs.open("lib/core/boot.lua", "w")
file.write('-- This is called from the startup script\nterm.clear()\n\nTBBOOT = {}\n\nfunction TBBOOT.tbHead()\n    term.setCursorPos(1,1)\n    print("Powered by TwelveBase") -- DO NOT REMOVE THIS!\n    print("Creating OS is easy\\n")\nend\n\ndofile("./lib/core/disableterminate.lua")\ndofile("./sysset/osinf.lua")\n\nfunction TBBOOT.loadLibs()\n    local directory = "./lib"\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        if file:match("%.lua$") then\n            print("LOAD >>> " .. file)\n            dofile(directory .. "/" .. file)\n        end\n    end\nend\n\nfunction TBBOOT.loadPkgLibs()\n    local directory = "./pkglibs"\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        if file:match("%.lua$") then\n            print("LOAD >>> " .. file)\n            dofile(directory .. "/" .. file)\n        end\n    end\nend\n\nfunction TBBOOT.registerMonitors()\n    -- Get a table of all peripheral names\n    local peripheralNames = peripheral.getNames()\n\n    -- Table to store monitor peripherals\n    local monitors = {}\n\n    -- Iterate through peripheral names and check if they are monitors\n    for _, peripheralName in ipairs(peripheralNames) do\n        if peripheral.getType(peripheralName) == "monitor" then\n            table.insert(monitors, peripheral.wrap(peripheralName))\n        end\n    end\n\n    -- Now \'monitors\' contains all connected monitors\n    -- You can iterate through \'monitors\' to perform operations on each monitor\n    for index, monitor in ipairs(monitors) do\n        -- Do something with each monitor\n        monitor.setTextScale(1)\n        monitor.clear()\n        monitor.setCursorPos(1, 1)\n        monitor.write("TwelveBase INIT")\n        monitor.setCursorPos(1,2)\n        monitor.write("MONITOR N-" .. index)\n        monitor.setCursorPos(1,1)\n    end\n\n    return monitors\n\nend\nLOADLIB = {}\n\nfunction LOADLIB.info(msg)\n    print("LOAD INFO: " .. msg)\nend\n\n\nTBBOOT.tbHead()\nos.sleep(2)\nterm.clear()\nTBBOOT.tbHead()\nprint("Creating important functions...")\nfunction _G.err(errorMsg)\n    if errorMsg == nil then\n        errorMsg = "Unknown Error"\n    end\n    local oldColor = term.getTextColor()\n    term.setTextColor(COSCOLORS.red)\n    print(errorMsg)\n    term.setTextColor(oldColor)\n    error()\nend\nterm.clear()\nTBBOOT.tbHead()\nprint("Loading libraries...")\nTBBOOT.loadLibs()\nterm.clear()\nTBBOOT.tbHead()\nprint("Registering paths...")\n_G.ENV_PATH = cfgParser.parse("./settings/paths.cfg").envPath\n_G.PROTECTED_PATH = cfgParser.parse("./settings/paths.cfg").protected\n_G._OSVER = OSINF.version\n_G.cosshell = _G.COSSHELL\n_G.shell = tbshell\n_G.colors = _G.COSCOLORS\n_G.reboot = function ()\n    os.reboot()\nend\nterm.clear()\nTBBOOT.tbHead()\nprint("Registering monitors...")\n_G.MONITORS = TBBOOT.registerMonitors()\nTBBOOT.tbHead()\nprint("Loading package libraries...")\nTBBOOT.loadPkgLibs()\nprint("Cleaning up...")\nTBBOOT = nil\nLOADLIB = nil\nOSINF = nil\nCOSSHELL = nil\nterm.clear()\nprint("Have a good day!")\nos.sleep(1)\nfor _, monitor in ipairs(MONITORS) do\n    monitor.clear()\n    monitor.setCursorPos(1,1)\nend\nshell.start()')
file.close()
local file = fs.open("lib/core/disableterminate.lua", "w")
file.write('os.pullEvent = os.pullEventRaw')
file.close()
shell.run("mkdir", "pkgbin")
shell.run("mkdir", "pkglibs")
shell.run("mkdir", "settings")
local file = fs.open("settings/packages.cfg", "w")
file.write('')
file.close()
local file = fs.open("settings/paths.cfg", "w")
file.write('envPath = {./bin, ./pkgbin}\nprotected = {./settings, ./sysset, ./lib}')
file.close()
shell.run("mkdir", "startup")
local file = fs.open("startup/inittb.lua", "w")
file.write('_G.COSSHELL = shell\n_G.COSCOLORS = colors\ndofile("lib/core/boot.lua")')
file.close()
shell.run("mkdir", "sysset")
local file = fs.open("sysset/osinf.lua", "w")
file.write('OSINF = {}\n\nOSINF.version = "TwelveBase OS 1.0"')
file.close()


local isec = 0
repeat
    term.clear()
    term.setCursorPos(1,1)
    print("Rebooting in ".. (3 - isec) .." second(s)")
    isec = isec + 1
    os.sleep(1)
until isec >= 3
os.reboot()