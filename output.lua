-- work only with craftos libs. This is installer. No TwelveBase libraries are included there.

term.clear()
term.setCursorPos(1,1)



function startUpAnimation()
    term.clear()
    term.setCursorPos(1,1)
    print("TwelveBase\n")
    print("Are you sure ")
    print(" Y ")
    os.sleep(1)
    term.clear()
    term.setCursorPos(1,1)
    print("TwelveBase Installation \n")
    print("Are you sure you want to install the OS")
    print(" YES ")
    os.sleep(1)
end

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

startUpAnimation()
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
shell.run("mkdir", "bin")
local file = fs.open("bin/cd.lua", "w")
file.write('if(COMMAND_ARGS[1] == nil) then\n    err("No args provided")\nelse\n    tbfs.cd(COMMAND_ARGS[1])\nend\n')
file.close()
local file = fs.open("bin/clear.lua", "w")
file.write('term.clear()\nterm.setCursorPos(1,1)')
file.close()
local file = fs.open("bin/dir.lua", "w")
file.write('if(COMMAND_ARGS[1] == nil) then\n    \n    tbfs.listDirGui(tbfs.getCwd(), tutils.toBool(COMMAND_ARGS[2]) or false)\nelseif(COMMAND_ARGS[1] == "--help") then\n    help.printHelp("dir")\nelse\n    tbfs.listDirGui(COMMAND_ARGS[1], tutils.toBool(COMMAND_ARGS[2]) or false)\nend\n')
file.close()
local file = fs.open("bin/getcwd.lua", "w")
file.write('print(tbfs.getCwd())\n')
file.close()
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
file.write('if(COMMAND_ARGS[1] == "install" or COMMAND_ARGS[1] == "i" and COMMAND_ARGS[2] ~= nil) then\n    pkgManager.install(COMMAND_ARGS[2])\nelseif(COMMAND_ARGS[1] == "--help") then\n    help.printHelp("pkg")\nelse\n    help.printHelp("pkg")\nend')
file.close()
local file = fs.open("bin/reboot.lua", "w")
file.write('reboot()')
file.close()
local file = fs.open("bin/shutdown.lua", "w")
file.write('os.shutdown()')
file.close()
shell.run("mkdir", "help")
local file = fs.open("help/dir.txt", "w")
file.write('Usage:\ndir\ndir <path>')
file.close()
local file = fs.open("help/help", "w")
file.write('')
file.close()
local file = fs.open("help/pkg.txt", "w")
file.write('Usage:\npkg i/install <packagepath>')
file.close()
shell.run("mkdir", "home")
local file = fs.open("home/userhome", "w")
file.write('\n')
file.close()
shell.run("mkdir", "lib")
local file = fs.open("lib/cfgparser.lua", "w")
file.write('_G.cfgParser = {}\n\nfunction cfgParser.parse(filename)\n    local config = {}\n    local file = io.open(filename, "r")\n\n    if file then\n        for line in file:lines() do\n            local key, value = line:match("(%w+)%s*=%s*(.*)")\n            if key and value then\n                -- Check if the value is an array\n                local arrayValues = value:match("{(.-)}")\n                if arrayValues then\n                    -- Split the array values and store them in a Lua table\n                    local arrayTable = {}\n                    for v in arrayValues:gmatch("[^,%s]+") do\n                        table.insert(arrayTable, tonumber(v) or v)\n                    end\n                    config[key] = arrayTable\n                else\n                    config[key] = tonumber(value) or value\n                end\n            end\n        end\n        file:close()\n    else\n        print("Error: Unable to open the .cfg file")\n    end\n\n    return config\nend\n\nfunction cfgParser.parseString(inputString)\n    local config = {}\n\n    for line in inputString:gmatch("[^\\r\\n]+") do\n        local key, value = line:match("(%w+)%s*=%s*(.*)")\n        if key and value then\n            -- Check if the value is an array\n            local arrayValues = value:match("{(.-)}")\n            if arrayValues then\n                -- Split the array values and store them in a Lua table\n                local arrayTable = {}\n                for v in arrayValues:gmatch("[^,%s]+") do\n                    table.insert(arrayTable, tonumber(v) or v)\n                end\n                config[key] = arrayTable\n            else\n                config[key] = tonumber(value) or value\n            end\n        end\n    end\n\n    return config\nend\n\nfunction cfgParser.__convertArray(arrayObj)\n    if type(arrayObj) ~= "table" then\n        err("Passed argument isn\'t a table. cfgParser (__ method)")\n    end\n    local result = "{ "\n    local isFirst = true\n    for _, obj in ipairs(arrayObj) do\n        if isFirst then\n            result = result .. obj\n            isFirst = false\n        else\n            result = result .. ", " .. obj\n        end\n    end\n\n    return result\nend\n\nfunction cfgParser.convert(configObj)\n    if type(configObj) ~= "table" then\n        err("Passed argument isn\'t a table. cfgParser")\n    end\n\n    local result = ""\n    for objName, obj in pairs(configObj) do\n        if type(obj) == "table" then\n            result = result .. objName .. " = " .. cfgParser.__convertArray(obj) .. "}\\n"\n        else\n            result = result .. objName .. " = " .. obj .. "\\n"\n        end\n    end\n    return result\nend')
file.close()
local file = fs.open("lib/fop.lua", "w")
file.write('_G.fop = {}\n-- (File operations)\n\nfop.file = {}\nfunction fop.file.copyForEach(srcDir, destDir)\n    local directory = srcDir\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        fs.copy(srcDir .. "/" .. fs.getName(file), destDir .. "/" .. fs.getName(file))\n    end\nend')
file.close()
local file = fs.open("lib/graphics.lua", "w")
file.write('\n_G.graphx = {}\n\n_G.graphx.buffer = {}\n_G.graphx.buffer.layers = {\n    ["layer1"] = {},\n    ["layer2"] = {},\n    ["layer3"] = {},\n    ["layer4"] = {},\n}\n\n_G.graphx.buffer.system_layer = {}\n\n\nfunction graphx.packXY(x, y)\n    return {x,y}\nend\n\nfunction graphx.drawPx(xy, color, layer)\n    local x = xy[1]\n    local y = xy[2]\n    local clr = nil\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    if type(color) == "string" then\n        clr = colors.fromBlit(color)\n    elseif type(color) == "number" then\n        clr = color\n    else\n        clr = colors.white\n    end\n\n    table.insert(layer, {x, y, "px", clr})\nend\n\nfunction graphx.clearScreen()\n    term.clear()\n    term.setCursorPos(1,1)\nend\n\nfunction graphx.clsc()\n    graphx.clearScreen()\nend\n\nfunction graphx.clearAll()\n    graphx.cleanBuffer()\n    graphx.clearScreen()\nend\n\nfunction graphx.drawText(startXY, text, color, layer)\n    local x,y = startXY[1], startXY[2]\n    local clr = nil\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    if type(color) == "string" then\n        clr = colors.fromBlit(color)\n    elseif type(color) == "number" then\n        clr = color\n    else\n        clr = colors.white\n    end\n\n    table.insert(layer, {x,y,"text", {text, clr}})\nend\n\nfunction graphx.drawLine(startXY, endXY, color, layer)\n    local x1, y1 = startXY[1], startXY[2]\n    local x2, y2 = endXY[1], endXY[2]\n\n    if layer == nil then\n        layer = graphx.buffer.layers["layer1"]\n    end\n\n    local dx = math.abs(x2 - x1)\n    local dy = math.abs(y2 - y1)\n    local sx, sy\n\n    if x1 < x2 then\n        sx = 1\n    else\n        sx = -1\n    end\n\n    if y1 < y2 then\n        sy = 1\n    else\n        sy = -1\n    end\n\n    local err = dx - dy\n\n    while true do\n        graphx.drawPx(graphx.packXY(x1, y1), color, layer)\n\n        if x1 == x2 and y1 == y2 then\n            break\n        end\n\n        local e2 = 2 * err\n\n        if e2 > -dy then\n            err = err - dy\n            x1 = x1 + sx\n        end\n\n        if e2 < dx then\n            err = err + dx\n            y1 = y1 + sy\n        end\n    end\nend\n\nfunction graphx.fillScreen(color, layer)\n    local screenWidth, screenHeight = term.getSize()\n    graphx.drawFilledSquare({1, 1}, math.max(screenWidth, screenHeight), color, layer)\nend\n\n\nfunction graphx.drawSquare(startXY, size, color, layer)\n    local x, y = startXY[1], startXY[2]\n    local endX, endY = x + size - 1, y + size - 1\n    local g = graphx\n\n    -- Draw top side\n    g.drawLine({x, y}, {endX, y}, color, layer)\n    -- Draw right side\n    g.drawLine({endX, y}, {endX, endY}, color, layer)\n    -- Draw bottom side\n    g.drawLine({x, endY}, {endX, endY}, color, layer)\n    -- Draw left side\n    g.drawLine({x, y}, {x, endY}, color, layer)\nend\n\nfunction graphx.drawFilledSquare(startXY, size, color, layer)\n    local x, y = startXY[1], startXY[2]\n    local endX, endY = x + size - 1, y + size - 1\n\n    for i = y, endY do\n        graphx.drawLine({x, i}, {endX, i}, color, layer)\n    end\nend\n\nfunction graphx.cleanBuffer()\n    _G.graphx.buffer.layers = {\n        ["layer1"] = {},\n        ["layer2"] = {},\n        ["layer3"] = {},\n        ["layer4"] = {},\n    }\nend\n\n\nfunction graphx.renderFrame(cleanBuffer)\n    graphx.clearScreen()\n\n    local layerNames = {"layer4", "layer3", "layer2", "layer1"}\n\n    for _, layerName in ipairs(layerNames) do\n        local layer = graphx.buffer.layers[layerName]\n        for _, renderObject in ipairs(layer) do\n            local x = renderObject[1]\n            local y = renderObject[2]\n            local objType = renderObject[3]\n            local color = renderObject[4]\n\n            if objType == "px" then\n                term.setCursorPos(x,y)\n                local oldColor = term.getBackgroundColor()\n                term.setBackgroundColor(color)\n                term.write(" ")\n                term.setBackgroundColor(oldColor)\n            elseif objType == "text" then\n                local props = color\n                local text = props[1]\n                local color = props[2]\n                local oldPosX, oldPosY = term.getCursorPos()\n                local oldTextColor = term.getTextColor()\n                local oldBkgColor = term.getBackgroundColor()\n                term.setCursorPos(x,y)\n                local upLayers = {}\n                local downLayers = {}\n                local blayers = graphx.buffer.layers\n                if layer == blayers["layer1"] then\n                    upLayers = {}\n                elseif layer == blayers["layer2"] then\n                    upLayers = {blayers["layer1"]}\n                elseif layer == blayers["layer3"] then\n                    upLayers = {blayers["layer1"], blayers["layer2"]}\n                elseif layer == blayers["layer4"] then\n                    upLayers = {blayers["layer1"], blayers["layer2"], blayers["layer3"]}\n                end\n\n                if layer == blayers["layer4"] then\n                    downLayers = {}\n                elseif layer == blayers["layer3"] then\n                    downLayers = {blayers["layer4"]}\n                elseif layer == blayers["layer2"] then\n                    downLayers = {blayers["layer3"], blayers["layer4"]}\n                elseif layer == blayers["layer1"] then\n                    downLayers = {blayers["layer2"], blayers["layer3"], blayers["layer4"]}\n                end\n                for i = 1, #text do\n                    local letter = text:sub(i,i)\n                    local cPosX, cPosY = term.getCursorPos()\n                    local downLayerPxFound = false\n                    local downLayerPxObj = nil\n                    for _, downLayer in ipairs(downLayers) do\n                        for _, downObj in ipairs(downLayer) do\n                            if downObj[1] == cPosX and downObj[2] == cPosY then\n                                downLayerPxFound = true\n                                downLayerPxObj = downObj\n                                break\n                            end\n                        end\n                        if downLayerPxFound then\n                            break\n                        end\n                    end\n                    local cBkgColor = term.getBackgroundColor()\n                    if downLayerPxFound and downLayerPxObj ~= nil then\n                        cBkgColor = downLayerPxObj[4]\n                    end\n                    term.setBackgroundColor(cBkgColor)\n                    term.setTextColor(color)\n                    term.write(letter)\n                end\n                term.setCursorPos(oldPosX, oldPosY)\n                term.setTextColor(oldTextColor)\n                term.setBackgroundColor(oldBkgColor)\n            end\n        end\n    end\n    term.setCursorPos(1,1)\n    if cleanBuffer == nil or cleanBuffer == true then\n        graphx.cleanBuffer()\n    end\nend\n')
file.close()
local file = fs.open("lib/help.lua", "w")
file.write('_G.help = {}\n\nfunction help.getHelp(id)\n    local HELPFOUND = false\n    local HELPPATH = nil\n    for _, helpPath in ipairs(HELP_PATH) do\n        local directory = helpPath\n        local files = fs.list(directory)\n        for _, file in ipairs(files) do\n            if file:match("%.txt$") then\n                if fs.getName(file) == id .. ".txt" then\n                    HELPPATH = directory.. "/".. file\n                    HELPFOUND = true\n                    break\n                end\n            end\n        end\n    end\n\n    if HELPFOUND then\n        local file = fs.open(HELPPATH, "r")\n        local contents = file.readAll()\n        file.close()\n        return contents\n    else\n        return nil\n    end\nend\n\nfunction help.printHelp(id)\n    print(help.getHelp(id))\nend')
file.close()
local file = fs.open("lib/logit.lua", "w")
file.write('_G.logit = {}\n\nfunction logit.log(prefix, message)\n    local time = os.epoch("local") / 1000\n    local time_table = os.date("*t", time)\n    local strtime = time_table.hour .. ":" .. time_table.min .. ":" .. time_table.sec\n    print("INFO [" .. strtime .. "] [" .. prefix .. "] " .. message)\nend')
file.close()
local file = fs.open("lib/mat.lua", "w")
file.write('_G.mat = {}\n\nfunction mat.isEven(number)\n    return number % 2 == 0\nend\n\nfunction mat.isOdd(number)\n    return number % 2 ~= 0\nend')
file.close()
local file = fs.open("lib/pkgmanager.lua", "w")
file.write('_G.pkgManager = {}\n\nfunction pkgManager.install(packageDirectory)\n    local isDir = fs.isDir(packageDirectory)\n    if isDir == false then\n        err("Package must be a directory (or a disk)")\n    end\n\n    local packageFile = nil\n\n    if fs.exists(packageDirectory .. "/.tbpkg") then\n        local tempPkgFile = fs.open(packageDirectory .. "/.tbpkg", "r")\n\n        if tempPkgFile then\n            packageFile = tempPkgFile.readAll()\n            tempPkgFile.close()\n        else\n            err("Cannot read the package file")\n        end\n    end\n\n    if packageFile == nil then\n        err("Package file is (somehow) nil")\n    end\n\n    local packageSettings = cfgParser.parseString(packageFile)\n\n    if packageSettings.name == nil or packageSettings.version == nil then\n        err("INVALID PACKAGE: Some of the important settings of the package are not defined.")\n    end\n\n    local modifyPath = fs.isDir(packageDirectory .. "/bin")\n    local modifyLibs = fs.isDir(packageDirectory .. "/lib")\n    local modifyHelp = fs.isDir(packageDirectory .. "/help")\n    local modifySettings = fs.isDir(packageDirectory .. "/settings")\n\n    if modifyLibs == false and modifyPath == false then\n        err("INVALID PACKAGE: None of the directories (bin, lib) were modified. At least 1 dir must be modified")\n    end\n\n    if modifyLibs then\n        fop.file.copyForEach(packageDirectory .. "/lib", "pkglibs")\n    end\n\n    if modifyPath then\n        fop.file.copyForEach(packageDirectory .. "/bin", "pkgbin")\n    end\n\n    if modifySettings then\n        fop.file.copyForEach(packageDirectory .. "/settings", "settings")\n    end\n\n    if modifyHelp then\n        fop.file.copyForEach(packageDirectory .. "/help", "pkghelp")\n    end\n\n    if packageSettings.depend ~= nil then\n        for index, dependObj in ipairs(packageSettings.depend) do\n            if mat.isOdd(index) then\n                print(" -- Dependency --")\n                print("Name: " .. dependObj)\n            else\n                local decodedDesc = dependObj:gsub("#", " ")\n                print("Info: " .. decodedDesc)\n                print("----\\n")\n            end\n        end\n        local o = term.getTextColor()\n        term.setTextColor(colors.red)\n        print("\\nIMPORTANT!! Please install these dependencies to make the package work.\\n")\n        term.setTextColor(o)\n        o = nil\n    end\n\n    print("Installation done.")\n\n    if modifyLibs == true then\n        print("\\nThe package you installed includes its own libraries, to register the libraries the system needs to reboot.")\n        term.write("Reboot? [y/n] ")\n        local rebootConfirm = read()\n        if rebootConfirm == "y" then\n            reboot()\n        else\n            print("This can lead to errors. Please consider rebooting (later).")\n        end\n    end\n\nend\n\nfunction pkgManager.checkInstalled(packageName)\n    \nend')
file.close()
local file = fs.open("lib/shell.lua", "w")
file.write('_G.tbshell = {}\n\n-- if you are user. do not edit this if you want to use this os as normal user\n\nfunction tbshell.execute(name, args)\n    local CMDFOUND = false\n    local CMDPATH = nil\n\n\n    for _, binPath in ipairs(ENV_PATH) do\n        local directory = binPath\n        local files = fs.list(directory)\n        for _, file in ipairs(files) do\n            if file:match("%.lua$") then\n                if fs.getName(file) == name .. ".lua" then\n                    CMDPATH = directory.. "/".. file\n                    CMDFOUND = true\n                    break\n                end\n            end\n        end\n    end\n\n    if(CMDFOUND) then\n        _G.COMMAND_ARGS = args\n        local success = pcall(dofile, CMDPATH)\n        if not success then\n            return "ERR"\n        end\n        return true\n    else\n        return false\n    end\n\nend\n\nfunction tbshell.getCompletions()\n    local result = {}\n    for _, binPath in ipairs(ENV_PATH) do\n        local directory = binPath\n        local files = fs.list(directory)\n        for _, file in ipairs(files) do\n            if file:match("%.lua$") then\n                local fileNameWithoutExtension = file:sub(1, -5) -- Remove the last 4 characters (".lua")\n                table.insert(result, fileNameWithoutExtension)\n            end\n        end\n    end\n\n    return result\nend\n\n\nfunction tbshell.start()\n    term.clear()\n    term.setCursorPos(1, 1)\n    print(_OSVER)\n    tbshell.start = nil\n    _G.CWD = "/home"\n    local _, screenHeight = term.getSize()\n    local history = {}\n    local completion = CCCOMPLET\n    while true do\n        term.write(_G.CWD.."> ")\n        local command = read(nil, history, function (text) return completion.choice(text, tbshell.getCompletions()) end)\n        local canRun = true\n        if command == "" then\n            canRun = false\n        end\n        if canRun then\n            local cargs = {}\n            for token in string.gmatch(command, "[^" .. " " .. "]+") do\n                table.insert(cargs, token)\n            end\n            local commandName = cargs[1]\n            table.remove(cargs, 1)\n            local cmdStatus = tbshell.execute(commandName, cargs)\n            if cmdStatus == false then\n                print("Command not found")\n            elseif cmdStatus == "ERR" then\n                print("There was an error while executing the command")\n            else\n                table.insert(history, command)\n            end\n        end\n    end\n    print("ERR")\nend\n')
file.close()
local file = fs.open("lib/tbfs.lua", "w")
file.write('_G.tbfs = {}\n\nfunction tbfs.getCwd()\n    return _G.CWD or "/"\nend\n\nfunction tbfs.cd(ipath)\n    if _G.CWD == nil then\n        error("System is not initialized.")\n    end\n\n    if ipath == "__ROOT" then\n        _G.CWD = "/"\n        return true\n    end\n\n    if ipath == "" then\n        return true\n    end\n\n    local newCwd = _G.CWD\n    if ipath == ".." then\n        local segments = {}\n        for segment in _G.CWD:gmatch("[^/]+") do\n            table.insert(segments, segment)\n        end\n        if #segments > 0 then\n            table.remove(segments)\n            newCwd = table.concat(segments, "/")\n        else\n            newCwd = "/"\n        end\n    elseif string.sub(ipath, 1, 2) == "./" then\n        newCwd = fs.combine(newCwd, string.sub(ipath, 2))\n    else\n        newCwd = ipath\n    end\n\n    if newCwd == "" then\n        newCwd = "/"\n    end\n\n    if fs.isDir(newCwd) then\n        _G.CWD = newCwd\n        return true\n    else\n        error("The target path does not exist or is not a directory.")\n    end\nend\n\n\n\nfunction tbfs.listDir(path)\n    local oldCwd = tbfs.getCwd()\n\n    if path ~= "." and path ~= "./" then\n        local success, err = pcall(function() tbfs.cd(path) end)\n        if not success then\n            print("Error changing directory:", err)\n            return nil\n        end\n    end\n    local files = fs.list(tbfs.getCwd())\n    local dirs = {}\n\n    for _, file in ipairs(files) do\n        if fs.isDir(fs.combine(tbfs.getCwd(), file)) then\n            table.insert(dirs, file .. "/")\n        end\n    end\n\n    local cdSuccess, cdErr = pcall(function() tbfs.cd(oldCwd) end)\n    if not cdSuccess then\n        print("Error returning to old CWD:", cdErr)\n    end\n\n    return {\n        dirs = dirs,\n        files = files\n    }\nend\n\n\nfunction tbfs.listDirGui(path, tablemode)\n    \n    local listed = tbfs.listDir(path)\n    local oldTermColor = term.getTextColor()\n    if tablemode == false then\n        local fileColor = colors.blue\n        local dirColor = colors.green\n    \n    \n        term.setTextColor(dirColor)\n        for _, dir in ipairs(listed.dirs) do\n           print(dir, " D") \n        end\n    \n        term.setTextColor(fileColor)\n        for _, file in ipairs(listed.files) do\n            print(file, " F")\n        end\n    \n    elseif tablemode == true then\n        local finalTable = {}\n        for _, dir in ipairs(listed.dirs) do\n            table.insert(finalTable, {name = dir, type = "directory"})\n        end\n\n        for _, file in ipairs(listed.files) do\n            table.insert(finalTable, {name = file, type = "file"})\n        end\n\n        if(finalTable == {} or finalTable == nil) then\n            print("The directory is empty")\n            return\n        end\n\n        \n        print(tutils.table(finalTable))\n    end\n    term.setTextColor(oldTermColor)\nend\n\n')
file.close()
local file = fs.open("lib/tutils.lua", "w")
file.write('_G.tutils = {}\n\nfunction tutils.input(question)\n    if question == nil then\n        err("No arguments given")\n    end\n\n    print(question)\n    local answer = read()\n    return answer\nend\n\nfunction tutils.inputYN(question)\n    if question == nil then\n        err("No arguments given")\n    end\n\n    print(question)\n\n    local preAnswer = read()\n    local answer = false\n    if preAnswer == "y" or preAnswer == "Y" then\n        answer = true\n    end\n\n    return answer\nend\n\nfunction tutils.inputNum(question)\n    if question == nil then\n        err("No arguments given")\n    end\n\n    local loopOver = false\n    local finalAnswer = nil\n\n    repeat\n        print(question)\n        local answer = read()\n        local isGood = tonumber(answer, 10)\n        if isGood == nil then\n            print("Must be a number.")\n        else\n            loopOver = true\n            finalAnswer = tonumber(answer, 10)\n        end\n    until loopOver == true\n\n    return finalAnswer\nend\n\nfunction tutils.table(input_table)\n    if type(input_table) ~= "table" then\n        err("The input isn\'t a table")\n    end\n    if #input_table == 0 then\n        err("The table is empty")\n    end\n\n    local columnWidths = {}\n    local headers = {}\n\n    for key in pairs(input_table[1]) do\n        table.insert(headers, key)\n        columnWidths[key] = #tostring(key)\n    end\n\n    for _, record in ipairs(input_table) do\n        for key, value in pairs(record) do\n            local length = #tostring(value)\n            if length > columnWidths[key] then\n                columnWidths[key] = length\n            end\n        end\n    end\n\n    local function padText(text, width)\n        return text .. string.rep(" ", width - #text)\n    end\n\n    local headerRow = ""\n    for _, header in ipairs(headers) do\n        headerRow = headerRow .. padText(header, columnWidths[header]) .. " | "\n    end\n    headerRow = headerRow:sub(1, -3)\n\n    local dataRows = {}\n    for _, record in ipairs(input_table) do\n        local dataRow = ""\n        for _, header in ipairs(headers) do\n            local value = record[header] or ""\n            dataRow = dataRow .. padText(tostring(value), columnWidths[header]) .. " | "\n        end\n        dataRow = dataRow:sub(1, -3)\n        table.insert(dataRows, dataRow)\n    end\n\n    local formattedTable = headerRow .. "\\n" .. table.concat(dataRows, "\\n")\n    return formattedTable\nend\n\nfunction tutils.toBool(str)\n    if str == null or str == "" then\n        return nil\n    end\n    if type(str) ~= "string" then\n        err("The input isn\'t a string")\n    end\n\n    tbl = {\n        ["false"] = false,\n        ["true"] = true\n    }\n\n    return tbl[str]\nend')
file.close()
shell.run("mkdir", "lib/core")
local file = fs.open("lib/core/boot.lua", "w")
file.write('-- This is called from the startup script\nterm.clear()\n\nTBBOOT = {}\n\nfunction TBBOOT.tbHead()\n    term.setCursorPos(1,1)\n    print("Powered by TwelveBase") -- DO NOT REMOVE THIS!\n    print("Creating OS is easy\\n")\nend\n\ndofile("./lib/core/disableterminate.lua")\ndofile("./sysset/osinf.lua")\n\nfunction TBBOOT.loadLibs()\n    local directory = "./lib"\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        if file:match("%.lua$") then\n            print("LOAD >>> " .. file)\n            dofile(directory .. "/" .. file)\n            os.sleep(0.1)\n        end\n    end\nend\n\nfunction TBBOOT.loadPkgLibs()\n    local directory = "./pkglibs"\n    local files = fs.list(directory)\n    for _, file in ipairs(files) do\n        if file:match("%.lua$") then\n            print("LOAD >>> " .. file)\n            dofile(directory .. "/" .. file)\n            os.sleep(0.1)\n        end\n    end\nend\n\nfunction TBBOOT.registerMonitors()\n    -- Get a table of all peripheral names\n    local peripheralNames = peripheral.getNames()\n\n    -- Table to store monitor peripherals\n    local monitors = {}\n\n    -- Iterate through peripheral names and check if they are monitors\n    for _, peripheralName in ipairs(peripheralNames) do\n        if peripheral.getType(peripheralName) == "monitor" then\n            table.insert(monitors, peripheral.wrap(peripheralName))\n        end\n    end\n\n    -- Now \'monitors\' contains all connected monitors\n    -- You can iterate through \'monitors\' to perform operations on each monitor\n    for index, monitor in ipairs(monitors) do\n        -- Do something with each monitor\n        monitor.setTextScale(1)\n        monitor.clear()\n        monitor.setCursorPos(1, 1)\n        monitor.write("TwelveBase INIT")\n        monitor.setCursorPos(1,2)\n        monitor.write("MONITOR N-" .. index)\n        monitor.setCursorPos(1,1)\n    end\n\n    return monitors\n\nend\nLOADLIB = {}\n\nfunction LOADLIB.info(msg)\n    print("LOAD INFO: " .. msg)\nend\n\n\nTBBOOT.tbHead()\nos.sleep(2)\nterm.clear()\nTBBOOT.tbHead()\nprint("Creating important functions...")\nfunction _G.err(errorMsg)\n    if errorMsg == nil then\n        errorMsg = "Unknown Error"\n    end\n    local oldColor = term.getTextColor()\n    term.setTextColor(COSCOLORS.red)\n    print(errorMsg)\n    term.setTextColor(oldColor)\n    error()\nend\nterm.clear()\nTBBOOT.tbHead()\nprint("Loading libraries...")\nTBBOOT.loadLibs()\nos.sleep(0.2) -- pretty cool when u look at what it loaded\nterm.clear()\nTBBOOT.tbHead()\nprint("Registering paths...")\nlocal pcfg = cfgParser.parse("./settings/paths.cfg")\n_G.ENV_PATH = pcfg.envPath\n_G.HELP_PATH = pcfg.helpPath\npcfg = nil\n_G._OSVER = OSINF.version\n_G.cosshell = _G.COSSHELL\n_G.shell = tbshell\n_G.colors = _G.COSCOLORS\n_G.reboot = function ()\n    os.reboot()\nend\nterm.clear()\nTBBOOT.tbHead()\nprint("Registering monitors...")\n_G.MONITORS = TBBOOT.registerMonitors()\nTBBOOT.tbHead()\nprint("Loading package libraries...")\nTBBOOT.loadPkgLibs()\nos.sleep(1)\nprint("Cleaning up...")\nTBBOOT = nil\nLOADLIB = nil\nOSINF = nil\nCOSSHELL = nil\nterm.clear()\nprint("Have a good day!")\nos.sleep(1)\n\nfunction monTest(monitor)\n    local colorList = {\n        colors.white,\n        colors.orange,\n        colors.magenta,\n        colors.lightBlue,\n        colors.yellow,\n        colors.lime,\n        colors.pink,\n        colors.gray,\n        colors.lightGray,\n        colors.cyan,\n        colors.purple,\n        colors.blue,\n        colors.brown,\n        colors.green,\n        colors.red,\n        colors.black\n    }\n    local oldTerminal = term.current()\n    term.redirect(monitor)\n    for _, color in ipairs(colorList) do\n        graphx.fillScreen(color, graphx.buffer.layers.layer1)\n        graphx.renderFrame(true)\n        os.sleep(0.01)\n    end\n    graphx.clearAll()\n    term.redirect(oldTerminal)\nend\n\nfor _, monitor in ipairs(MONITORS) do\n    monTest(monitor)\n    monitor.clear()\n    monitor.setCursorPos(1,1)\nend\nmonTest = nil\nterm.clear()\nterm.setCursorPos(1,1)\nprint("Running on-start files...")\nfor _, file in ipairs(fs.list("onstart")) do\n    if string.find(file, "%.lua$") then\n        local filePath = fs.combine("onstart", file)\n        pcall(dofile, filePath)\n    end\nend\nshell.start()\n')
file.close()
local file = fs.open("lib/core/disableterminate.lua", "w")
file.write('os.pullEvent = os.pullEventRaw')
file.close()
shell.run("mkdir", "onstart")
local file = fs.open("onstart/runonsystemstart", "w")
file.write('\n')
file.close()
shell.run("mkdir", "pkgbin")
local file = fs.open("pkgbin/binforpackages", "w")
file.write('')
file.close()
shell.run("mkdir", "pkghelp")
shell.run("mkdir", "pkglibs")
local file = fs.open("pkglibs/libforpackages", "w")
file.write('')
file.close()
shell.run("mkdir", "settings")
local file = fs.open("settings/packages.cfg", "w")
file.write('packages = ')
file.close()
local file = fs.open("settings/paths.cfg", "w")
file.write('envPath = {./bin, ./pkgbin}\nhelpPath = {./help, ./pkghelp}')
file.close()
shell.run("mkdir", "startup")
local file = fs.open("startup/inittb.lua", "w")
file.write('term.clear()\nprint("Initializing")\nterm.setCursorPos(1,1)\n_G.COSSHELL = shell\n_G.COSCOLORS = colors\n_G.CCCOMPLET = require "cc.completion"\ndofile("lib/core/boot.lua")')
file.close()
shell.run("mkdir", "sysset")
local file = fs.open("sysset/osinf.lua", "w")
file.write('OSINF = {}\n\nOSINF.version = "TwelveBase OS 1.0"')
file.close()


term.clear()
term.setCursorPos(1,1)
print("That was fast!")
os.sleep(2)

local isec = 0
repeat
    term.clear()
    term.setCursorPos(1,1)
    print("Rebooting in ".. (3 - isec) .." second(s)")
    isec = isec + 1
    os.sleep(1)
until isec >= 3
os.reboot()
