_G.tbshell = {}

function tbshell.execute(name, args)
    local CMDFOUND = false
    local CMDPATH = nil


    for _, binPath in ipairs(ENV_PATH) do
        local directory = binPath
        local files = fs.list(directory)
        for _, file in ipairs(files) do
            if file:match("%.lua$") then
                if fs.getName(file) == name .. ".lua" then
                    CMDPATH = directory.. "/".. file
                    CMDFOUND = true
                    break
                end
            end
        end
    end

    if(CMDFOUND) then
        _G.COMMAND_ARGS = args
        local success = pcall(dofile, CMDPATH)
        if not success then
            print("ERROR EXECUTING COMMAND")
            return false
        end
        return true
    else
        return false
    end

end

function tbshell.getCompletions()
    local result = {}
    for _, binPath in ipairs(ENV_PATH) do
        local directory = binPath
        local files = fs.list(directory)
        for _, file in ipairs(files) do
            if file:match("%.lua$") then
                local fileNameWithoutExtension = file:sub(1, -5) -- Remove the last 4 characters (".lua")
                table.insert(result, fileNameWithoutExtension)
            end
        end
    end

    return result
end

function tbshell.start()
    term.clear()
    term.setCursorPos(1, 1)
    print(_OSVER)
    tbshell.start = nil
    _G.CWD = "/home"
    local _, screenHeight = term.getSize()
    local history = {}
    local completion = CCCOMPLET
    while true do
        term.write("> ")
        local command = read(nil, history, function (text) return completion.choice(text, tbshell.getCompletions()) end)
        local canRun = true
        if command == "" then
            canRun = false
        end
        if canRun then
            local cargs = {}
            for token in string.gmatch(command, "[^" .. " " .. "]+") do
                table.insert(cargs, token)
            end
            local commandName = cargs[1]
            table.remove(cargs, 1)
            local cmdStatus = tbshell.execute(commandName, cargs)
            if cmdStatus == false then
                print("Command not found")
            else
                table.insert(history, command)
            end
        end
    end
    print("ERR")
end