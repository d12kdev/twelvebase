if(COMMAND_ARGS[1] == nil) then
    
    tbfs.listDirGui(tbfs.getCwd(), tutils.toBool(COMMAND_ARGS[2]) or false)
elseif(COMMAND_ARGS[1] == "--help") then
    help.printHelp("dir")
else
    tbfs.listDirGui(COMMAND_ARGS[1], tutils.toBool(COMMAND_ARGS[2]) or false)
end
