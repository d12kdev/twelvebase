_G.pkgManager = {}

function pkgManager.install(packageDirectory)
    local isDir = fs.isDir(packageDirectory)
    if isDir == false then
        err("Package must be a directory (or a disk)")
    end

    local packageFile = nil

    if fs.exists(packageDirectory .. "/.tbpkg") then
        local tempPkgFile = fs.open(packageDirectory .. "/.tbpkg", "r")

        if tempPkgFile then
            packageFile = tempPkgFile.readAll()
            tempPkgFile.close()
        else
            err("Cannot read the package file")
        end
    end

    if packageFile == nil then
        err("Package file is (somehow) nil")
    end

    local packageSettings = cfgParser.parseString(packageFile)

    if packageSettings.name == nil or packageSettings.version == nil then
        err("INVALID PACKAGE: Some of the important settings of the package are not defined.")
    end

    local modifyPath = fs.isDir(packageDirectory .. "/bin")
    local modifyLibs = fs.isDir(packageDirectory .. "/lib")
    local modifyHelp = fs.isDir(packageDirectory .. "/help")
    local modifySettings = fs.isDir(packageDirectory .. "/settings")

    if modifyLibs == false and modifyPath == false then
        err("INVALID PACKAGE: None of the directories (bin, lib) were modified. At least 1 dir must be modified")
    end

    if modifyLibs then
        fop.file.copyForEach(packageDirectory .. "/lib", "pkglibs")
    end

    if modifyPath then
        fop.file.copyForEach(packageDirectory .. "/bin", "pkgbin")
    end

    if modifySettings then
        fop.file.copyForEach(packageDirectory .. "/settings", "settings")
    end

    if modifyHelp then
        fop.file.copyForEach(packageDirectory .. "/help", "pkghelp")
    end

    if packageSettings.depend ~= nil then
        for index, dependObj in ipairs(packageSettings.depend) do
            if mat.isOdd(index) then
                print(" -- Dependency --")
                print("Name: " .. dependObj)
            else
                local decodedDesc = dependObj:gsub("#", " ")
                print("Info: " .. decodedDesc)
                print("----\n")
            end
        end
        local o = term.getTextColor()
        term.setTextColor(colors.red)
        print("\nIMPORTANT!! Please install these dependencies to make the package work.\n")
        term.setTextColor(o)
        o = nil
    end

    print("Installation done.")

    if modifyLibs == true then
        print("\nThe package you installed includes its own libraries, to register the libraries the system needs to reboot.")
        term.write("Reboot? [y/n] ")
        local rebootConfirm = read()
        if rebootConfirm == "y" then
            reboot()
        else
            print("This can lead to errors. Please consider rebooting (later).")
        end
    end

end

function pkgManager.checkInstalled(packageName)
    
end