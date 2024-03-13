_G.tbfs = {}

function tbfs.getCwd()
    return _G.CWD
end

function tbfs.cd(ipath)
    if _G.CWD == nil then
        err("Tried to change cwd but it seems like the system is not initialized yet.")
    end

    if ipath == "__ROOT" then
        _G.CWD = ""
        return true
    end

    if ipath == "" then
        return true
    end

    local pathToCd = nil

    if ipath == ".." or ipath == "../.." then
        local cwdSegments = {}
        for segment in _G.CWD:gmatch("[^/]+") do
            table.insert(cwdSegments, segment)
        end
        local levelsUp = ipath == "../.." and 2 or 1
        for i = 1, levelsUp do
            table.remove(cwdSegments)
        end
        pathToCd = table.concat(cwdSegments, "/")
    elseif string.sub(ipath, 1, 2) == "./" then
        if string.sub(_G.CWD, -1) == "/" then
            _G.CWD = string.sub(_G.CWD, 1, -2)
        end
        pathToCd = _G.CWD .. string.sub(ipath, 2)
    elseif string.sub(ipath, 1, 3) == "../" then
        local cwdSegments = {}
        for segment in _G.CWD:gmatch("[^/]+") do
            table.insert(cwdSegments, segment)
        end
        local levelsUp = 1
        for i = 4, #ipath, 3 do
            if string.sub(ipath, i, i + 2) == "../" then
                levelsUp = levelsUp + 1
            else
                break
            end
        end
        for i = 1, levelsUp do
            table.remove(cwdSegments)
        end
        pathToCd = table.concat(cwdSegments, "/") .. string.sub(ipath, levelsUp * 3 + 1)
    else
        pathToCd = ipath
    end

    if fs.isDir(pathToCd) then
        _G.CWD = pathToCd
        return true
    else
        err("Tried to cd but the target was not a directory or it was not found")
        return false
    end
end

function tbfs.listDirGui(path)
    local oldCwd = tbfs.getCwd()
    if path ~= "." and path ~= "./" then
        tbfs.cd(path)
    end
    local files = fs.list(_G.CWD)
    local dirs = {}

    for _, file in ipairs(files) do
        if fs.isDir(fs.combine(_G.CWD, file)) then
            table.insert(dirs, file .. "/")
        else
            local oldclr = term.getTextColor()
            term.setTextColor(colors.blue)
            print(file)
            term.setTextColor(oldclr)
        end
    end

    for _, dir in ipairs(dirs) do
        local oldclr = term.getTextColor()
        term.setTextColor(colors.green)
        print(dir)
        term.setTextColor(oldclr)
    end
    tbfs.cd(oldCwd)
end

