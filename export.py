import os
import string
import random
import postbin

if os.path.isdir("./.tbcache") == False:
    print("Creating cache folder.")
    os.mkdir("./.tbcache")

print("Creating cache file...")

lua_filename = ".tbcache/" + ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))

with open(lua_filename, 'w') as lua_file:
    for root, dirs, files in os.walk("."):
        relative_path = os.path.relpath(root, ".").replace('\\', '/')
        if(relative_path == "." or relative_path == ".installer" or ".tbcache" in relative_path or ".git" in relative_path):
            continue
        lua_file.write(f'shell.run("mkdir", "{relative_path}")\n')
        print("MKDIR " + relative_path)

        for file in files:
            if file == "output.lua" or file == "export.py" or file == "installer_main.lua":
                continue
            file_path = os.path.join(root, file).replace('\\', '/')
            relative_file_path = os.path.relpath(file_path, ".").replace('\\', '/')

            with open(file_path, 'r') as f:
                file_content = f.read()

            lua_file.write(f'local file = fs.open("{relative_file_path}", "w")\n')
            lua_file.write(f'file.write({repr(file_content)})\n')
            lua_file.write('file.close()\n')
            print("WRITEFILE " + file)

CACHE_CONTENT = None

INSTALLER_CONTENT = None

with open(lua_filename, "r") as f:
    CACHE_CONTENT = f.read()

with open(".installer/installer_main.lua", "r") as f:
    INSTALLER_CONTENT = f.read()

if INSTALLER_CONTENT != None and CACHE_CONTENT != None:
    INSTALLER_CONTENT = INSTALLER_CONTENT.replace("{{TBEXPORT_CODE}}", CACHE_CONTENT)
    with open("output.lua", "w") as ofile:
        ofile.truncate(0)
        ofile.write(INSTALLER_CONTENT)
    print("Deleting cache file...")
    os.remove(lua_filename)
    print("Creating hastebin... (sorry, pastebin not supported yet)")
    hkey = postbin.postSync(INSTALLER_CONTENT)
    print(f"Hastebin key: {hkey}")
    print("Finished!")
else:
    print("Something did go wrong")
