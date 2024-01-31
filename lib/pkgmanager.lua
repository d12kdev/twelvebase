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

    if modifyLibs == false and modifyPath == false then
        err("INVALID PACKAGE: None of the directories (bin, lib) were modified. At least 1 dir must be modified")
    end

    if modifyLibs then
        fop.file.copyForEach(packageDirectory .. "/lib", "pkglibs")
    end

    if modifyPath then
        fop.file.copyForEach(packageDirectory .. "/bin", "pkgbin")
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