--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: system/console.lua
Description: Debuging utilities, including, HUD's, Watchers, Consoles and Graphics
Notes: How to use described in !help
]]

require "system/buffer"

-- Singleton Instance
local cons = {
	inputBuffer = Buffer:new(),
	bufferTable = {}
}

-- Console Class
Console = {}

function Console:ExecuteCommand()

end