term.clear()
print("Initializing")
term.setCursorPos(1,1)
_G.COSSHELL = shell
_G.COSCOLORS = colors
_G.CCCOMPLET = require "cc.completion"
dofile("lib/core/boot.lua")