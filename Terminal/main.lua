--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: main.lua
Description: Main execution file, basicaly overrides Love2D calbacks
Notes: 
]]

require "system/scene"
require "system/debug"
require "system/console"

lolscene = Scene:new("BoxScene")

box = {x = 50, y = 200, w = 10, h = 32, r = 255, g = 0, b = 50}

function lolscene:Update()
	box.x = box.x + 1
end

function lolscene:Draw()
	love.graphics.setColor(box.r,box.g,box.b)
	love.graphics.rectangle("fill",box.x,box.y,box.w,box.h)
end

-- Override de love.load, called only on the game is loading
function love.load()
	Debug.Activate()
	-- Create and Push Scenes Here --
	SceneManager:PushScene(lolscene)
end

-- Do not change the code below --

-- Override love.update, called every frame
function love.update()
	if not Debug.captured then
		SceneManager:Update()
	end
end

-- Override love.draw, called every frame
function love.draw()
	SceneManager:Draw()
	Debug.Draw()
end

-- Override love.keypressed, called when a key is pressed
function love.keypressed(k,unicode)
	Debug.KeyPressed(k,unicode)
	if not Debug.captured then
		SceneManager:KeyPressed(k,unicode)
	end
end

-- Override love.keyreleased, called when a key is released
function love.keyreleased(k)
	Debug.KeyReleased(k)
	if not Debug.captured then
		SceneManager:KeyReleased(k)
	end
end

-- Override love.mousepressed, called when mouse button is pressed
function love.mousepressed(x,y,button)
	if not Debug.captured then
		SceneManager:MousePressed(x,y,button)
	end
end

-- Override love.mousereleased, called when mouse button is released
function love.mousereleased(x,y,button)
	if not Debug.captured then
		SceneManager:MouseReleased(x,y,button)
	end
end

-- Override love.joystickpressed, called when joystick button is pressed
function love.joystickpressed(joystick,button)
	if not Debug.captured then
		SceneManager:JoystickPressed(joystick,button)
	end
end

-- Override love.joystickreleased, called when joystick button is released
function love.joystickreleased(joystick,button)
	if not Debug.captured then
		SceneManager:JoystickReleased(joystick,button)
	end
end
