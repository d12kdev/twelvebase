_G.fop = {}
-- (File operations)

fop.file = {}
function fop.file.copyForEach(srcDir, destDir)
    local directory = srcDir
    local files = fs.list(directory)
    for _, file in ipairs(files) do
        fs.copy(srcDir .. "/" .. fs.getName(file), destDir .. "/" .. fs.getName(file))
    end
end