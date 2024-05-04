_G.help = {}

function help.getHelp(id)
    local HELPFOUND = false
    local HELPPATH = nil
    for _, helpPath in ipairs(HELP_PATH) do
        local directory = helpPath
        local files = fs.list(directory)
        for _, file in ipairs(files) do
            if file:match("%.txt$") then
                if fs.getName(file) == id .. ".txt" then
                    HELPPATH = directory.. "/".. file
                    HELPFOUND = true
                    break
                end
            end
        end
    end

    if HELPFOUND then
        local file = fs.open(HELPPATH, "r")
        local contents = file.readAll()
        file.close()
        return contents
    else
        return nil
    end
end

function help.printHelp(id)
    print(help.getHelp(id))
end