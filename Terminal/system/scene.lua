--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: system/scene.lua
Description: Scene and Scene manager utilities
Notes: 
]]

-- Scene Class
Scene = {}

function Scene:new(debugname)
	local self = {}
	-- Parameters
	self.timestampCreated = 0.0
	self.timeActive = 0.0
	self.isActive = false
	self.debugName = debugname or "--NamelessScene--"
	-- Overrides all Callback functions from LOVE (except joystick)
	function self:Load() end
	function self:Update() end
	function self:Draw() end
	function self:KeyPressed(k,unicode) end
	function self:KeyReleased(k) end
	function self:MousePressed(x,y,button) end
	function self:MouseReleased(x,y,button) end
	function self:JoystickPressed(joystick,button) end
	function self:JoystickReleased(joystick,button) end
	function self:Quit() end
	return self
end

-- Scene Manager (Singleton global)
SceneManager = {}

-- Scene Stack
SceneManager.sceneStack = {}

function SceneManager:PushScene(scene)
	scene.timestampCreated = love.timer.getTime()
	if #self.sceneStack ~= 0 then
		self.sceneStack[#self.sceneStack].isActive = false
	end
	table.insert(self.sceneStack, scene) -- Insert scene at top of stack
	if scene.Load then scene:Load() end -- Execute loading callback if exists
	self.sceneStack[#self.sceneStack].isActive = true
end

function SceneManager:PopScene()
	local s = table.remove(self.sceneStack, #self.sceneStack) -- Remove scene at ot of stack
	if s then
		if s.Quit then s:Quit() end -- Execute ending callback if exists
	end
	if #self.sceneStack ~= 0 then
			self.sceneStack[#self.sceneStack].isActive = true
	end
	return s
end

function SceneManager:RemoveScene(scene) -- Remove specific scene of the stack
	for i,v in ipairs(self.sceneStack) do
		if v == scene then
			local s = table.remove(self.sceneStack, i) -- Remove scene
			if s.Quit then s:Quit() end -- Execute ending callback if exists
		end
	end
	self.sceneStack[#self._sceneStack].isActive = true
end

function SceneManager:Update()
	local n = #self.sceneStack
	-- Updates only last scene
	if n ~= 0 then
		self.sceneStack[n].timeActive = self.sceneStack[n].timeActive + love.timer.getDelta()
		if self.sceneStack[n].Update then
			self.sceneStack[n]:Update()
		end
	end
end

function SceneManager:Draw()
	for i = 1,#self.sceneStack do
		if self.sceneStack[i].Draw then
			self.sceneStack[i]:Draw()
		end
	end
	if self.debugMode then
		self:DebugHUD()
	end
end

function SceneManager:KeyPressed(k,unicode)
	if #self.sceneStack ~= 0 then
		if self.sceneStack[#self.sceneStack].KeyPressed then
			self.sceneStack[#self.sceneStack]:KeyPressed(k,unicode)
		end
	end
end

function SceneManager:KeyReleased(k)
   if #self.sceneStack ~= 0 then
		if self.sceneStack[#self.sceneStack].KeyReleased then
			self.sceneStack[#self.sceneStack]:KeyReleased(k,unicode)
		end
	end
end

function SceneManager:MousePressed(x,y,button)
	if #self.sceneStack ~= 0 then
		if self.sceneStack[#self.sceneStack].MousePressed then
			self.sceneStack[#self.sceneStack]:MousePressed(x,y,button)
		end
	end
end

function SceneManager:MouseReleased(x,y,button)
	if #self.sceneStack ~= 0 then
		if self.sceneStack[#self.sceneStack].MouseReleased then
			self.sceneStack[#self.sceneStack]:MouseReleased(x,y,button)
		end
	end
end

function SceneManager:JoystickPressed(joystick,button)
	if #self.sceneStack ~= 0 then
		if self._sceneStack[#self.sceneStack].JoystickPressed then
			self._sceneStack[#self.sceneStack]:JoystickPressed(joystick,button)
		end
	end
end

function SceneManager:JoystickReleased(joystick,button)
	if #self.sceneStack ~= 0 then
		if self.sceneStack[#self.sceneStack].JoystickReleased then
			self.sceneStack[#self.sceneStack]:JoystickReleased(joystick,button)
		end
	end
end