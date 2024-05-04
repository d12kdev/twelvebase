if(COMMAND_ARGS[1] == nil or COMMAND_ARGS[1] == "--help") then
    help.printHelp("cd")
else
    tbfs.cd(COMMAND_ARGS[1])
end
