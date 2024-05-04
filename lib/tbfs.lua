_G.tbfs = {}

function tbfs.getCwd()
    return _G.CWD or "/"
end

function tbfs.cd(ipath)
    if _G.CWD == nil then
        error("System is not initialized.")
    end

    if ipath == "__ROOT" then
        _G.CWD = "/"
        return true
    end

    if ipath == "" then
        return true
    end

    local newCwd = _G.CWD
    if ipath == ".." then
        local segments = {}
        for segment in _G.CWD:gmatch("[^/]+") do
            table.insert(segments, segment)
        end
        if #segments > 0 then
            table.remove(segments)
            newCwd = table.concat(segments, "/")
        else
            newCwd = "/"
        end
    elseif string.sub(ipath, 1, 2) == "./" then
        newCwd = fs.combine(newCwd, string.sub(ipath, 2))
    else
        newCwd = ipath
    end

    if newCwd == "" then
        newCwd = "/"
    end

    if fs.isDir(newCwd) then
        _G.CWD = newCwd
        return true
    else
        error("The target path does not exist or is not a directory.")
    end
end



function tbfs.listDir(path)
    local oldCwd = tbfs.getCwd()

    if path ~= "." and path ~= "./" then
        local success, err = pcall(function() tbfs.cd(path) end)
        if not success then
            print("Error changing directory:", err)
            return nil
        end
    end
    local files = fs.list(tbfs.getCwd())
    local dirs = {}

    for _, file in ipairs(files) do
        if fs.isDir(fs.combine(tbfs.getCwd(), file)) then
            table.insert(dirs, file .. "/")
        end
    end

    local cdSuccess, cdErr = pcall(function() tbfs.cd(oldCwd) end)
    if not cdSuccess then
        print("Error returning to old CWD:", cdErr)
    end

    return {
        dirs = dirs,
        files = files
    }
end


function tbfs.listDirGui(path, tablemode)
    
    local listed = tbfs.listDir(path)
    local oldTermColor = term.getTextColor()
    if tablemode == false then
        local fileColor = colors.blue
        local dirColor = colors.green
    
    
        term.setTextColor(dirColor)
        for _, dir in ipairs(listed.dirs) do
           print(dir, " D") 
        end
    
        term.setTextColor(fileColor)
        for _, file in ipairs(listed.files) do
            print(file, " F")
        end
    
    elseif tablemode == true then
        local finalTable = {}
        for _, dir in ipairs(listed.dirs) do
            table.insert(finalTable, {name = dir, type = "directory"})
        end

        for _, file in ipairs(listed.files) do
            table.insert(finalTable, {name = file, type = "file"})
        end

        if(finalTable == {} or finalTable == nil) then
            print("The directory is empty")
            return
        end

        
        print(tutils.table(finalTable))
    end
    term.setTextColor(oldTermColor)
end

