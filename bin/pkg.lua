if(COMMAND_ARGS[1] == "install" or COMMAND_ARGS[1] == "i" and COMMAND_ARGS[2] ~= nil) then
    pkgManager.install(COMMAND_ARGS[2])
end