--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: config.lua
Description: Overrides Love2d configuration file
Notes: love.conf(t) MUST be on this file (config.lua) on the folder root
]]

function love.conf(t)
    t.title = [[Real-Time Debugging Terminal]]
    t.author = "Victor Seixas Souza"
    t.identity = nil
    t.version = "0.8.0"
    t.console = false -- Set to true to get Love2D console (output only, can use print())
    t.release = false
    t.screen.width = 800
    t.screen.height = 600
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 4 -- fssa = Fullscreen Anti-Aliasing
	-- When fineshed, we can turn off the modules that we wont use
    t.modules.joystick = true
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = true
end
