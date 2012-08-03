--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: system/debug.lua
Description: Debuging utilities, including, HUD's, Watchers, Consoles and Graphics
Notes: How to use described in !help
]]

require "system/keyboard"
require "system/utils"
require "system/scene"

----------------------
-- -- PARAMETERS -- --
----------------------
Debug = { 
	-- Activation Flags
	active = false,
	activeSpecs = false,
	activeSceneStack = false,
	activeWatchers = false,
	activeConsole = false,
	visible = true,
	captured = false,
	
	-- Watcher List
	watcherList = {},

	-- Console Buffers
	consoleBuffer = {},
	consoleBufferSize = 1000, -- Max size for Buffer (in lines)
	consoleInputBuffer = "",
	-- Key Accent
	accentActive = false,  -- True if dead key was pressed last keystroke
	accentBase = nil, -- Holds the base key for accent compositon of dead keys
	capslock = false, -- Holds the capslocked state
	-- Navigation on Buffer
	cursorBuffer = 1, -- Relative position of the cursor on the buffer (in lines)
	-- Display Preferences
	colorBack = {0,0,0,200},
	colorFront = {255,255,255,255},
	consoleFont = love.graphics.newFont("font/VeraMono.ttf", 12),
	fontWidth = 7, -- In pixels (12pt font)
	fontHeight = 14, -- In pixels
	consoleWidth = math.floor(love.graphics.getWidth()/7), 
	consoleHeight = math.floor(love.graphics.getHeight()/14)-3,
	-- Cursor Blinking
	cursorChar = "_", -- The cursor Character
	cursorTimer = 0.0, -- Cursor timer
	cursorDelay = 0.75, -- Time between cursor blinks
	cursorDisplay = true, -- Cursor display state
	-- History of commands
	historyList = {},
	historySize = 25, -- In commands
	historyCursor = 0, -- Relative positon on history list
	startEditing = false, -- Flag to sellect the buffer when start to edit it
	tempBuffer = "", -- Holds the command while navigates
}

------------------------------
-- -- ACTIVATION METHODS -- --
------------------------------

function Debug.EnterConsole()
	Debug.activeConsole = true
	love.keyboard.setKeyRepeat(0.5, 0.025)
	Debug.captured = true
end

function Debug.ExitConsole()
	Debug.activeConsole = false
	love.keyboard.setKeyRepeat(0)
	Debug.captured = false
end


function Debug.Activate()
	Debug.active = true
	Debug.activeSpecs = true
	Debug.activeSceneStack = true
	Debug.activeWatchers = true
end

function Debug.Deactivate()
	Debug.active = false
	Debug.activeSpecs = false
	Debug.activeSceneStack = false
	Debug.activeWatchers = false
end

------------------------------
-- -- AUXILIAR FUNCTIONS -- --
------------------------------

-- Append a string to the Console Buffer
function Debug.AppendConsoleBuffer(str)
	if str then
		local list = str:split("\n")
		for i,v in ipairs(list) do
			local in_bufsize = utf8len(v)
			local in_linenum = math.ceil(in_bufsize/Debug.consoleWidth) -- Num of fold lines
			
			for j = 1,in_linenum do
				local lin_string = utf8sub(v,1+Debug.consoleWidth*(j-1),Debug.consoleWidth*j)
				table.insert(Debug.consoleBuffer,lin_string)
				-- Keeps the size of the Console Buffer Constant
				if #Debug.consoleBuffer > Debug.consoleBufferSize then
					table.remove(Debug.consoleBuffer,1)
				end
				-- Puts cursor to the end of output
				Debug.cursorBuffer = math.max(#Debug.consoleBuffer-(Debug.consoleHeight-1),1)
			end
		end
	end
end

-- Add command to history
function Debug.AddHistory(command)
	if command then
		table.insert(Debug.historyList,1,command)
		if #Debug.historyList > Debug.historySize then
			table.remove(Debug.historyList,Debug.historySize+1)
		end
	end
end

-- Navigate on command history
function Debug.History(delta)
	if Debug.startEditing then -- Saves the buffer if user edited an command
		Debug.tempBuffer = Debug.consoleInputBuffer
	end
	-- Moves the cursor by delta and asserts the bounds
	Debug.historyCursor = Debug.historyCursor + (delta or 0)
	Debug.historyCursor = math.max(0,math.min(Debug.historyCursor,#Debug.historyList))
	-- Retrieve History
	if Debug.historyCursor ~= 0 and Debug.historyList[Debug.historyCursor] then
		Debug.consoleInputBuffer = Debug.historyList[Debug.historyCursor]
		Debug.startEditing = false
	-- Gets Backup
	elseif Debug.historyCursor == 0 then
		Debug.consoleInputBuffer = Debug.tempBuffer
	end
end
----------------------------
-- -- WATCHER HANDLING -- --
----------------------------

function Debug.AddWatcher(command)  --- Must implement deep print of tables
	-- Certifies that watcher is unique
	local single = true
	for i,v in ipairs(Debug.watcherList) do
		if v == command then
			single = false
			break
		end
	end
	if single then table.insert(Debug.watcherList,tostring(command)) end
end

function Debug.RemoveWatcher(command)
	-- Looks for entry and then removes if found
	local found = nil
	for i,v in ipairs(Debug.watcherList) do
		if v == command then
			found = i
			break
		end
	end
	if found then table.remove(Debug.watcherList,found) end 
end

--------------------------
-- -- DRAWING METHOD -- --
--------------------------

-- Render the debugger activated utilities
function Debug.Draw()
	if Debug.active then
		-- Update Cursor Blink State
		Debug.cursorTimer = Debug.cursorTimer + love.timer.getDelta()
		if Debug.cursorTimer > Debug.cursorDelay then
			Debug.cursorTimer = Debug.cursorTimer - Debug.cursorDelay
			Debug.cursorDisplay = not Debug.cursorDisplay
		end
		love.graphics.setFont(Debug.consoleFont)
		-- -- Render Watchers -- --
		if Debug.activeWatchers and not Debug.activeConsole and Debug.visible then
			-- Construc Buffer and Get Width
			local print_buffer = ""
			local max_wid = 0
			local hei = #Debug.watcherList
			for i,v in ipairs(Debug.watcherList) do
				local f = loadstring("return "..v)
				local str = ""
				if f then str = show(f()) else str = show(nil) end
				str = " "..v..str
				max_wid = math.max(max_wid,string.len(str))
				print_buffer = str.."\n"..print_buffer
			end
			-- Handles Empty Buffer
			if print_buffer == "" then
				print_buffer = " empty watcher list\n"
				max_wid = print_buffer:len()
				hei = 1
			end
			local pos = love.graphics.getHeight() - Debug.fontHeight*(hei+1)
			love.graphics.setColor(Debug.colorBack)
			love.graphics.rectangle("fill",0,pos,(max_wid+1)*Debug.fontWidth,love.graphics.getHeight())
			love.graphics.setColor(Debug.colorFront)
			love.graphics.line(0,pos,(max_wid+1)*Debug.fontWidth,pos)
			love.graphics.line((max_wid+1)*Debug.fontWidth,pos,(max_wid+1)*Debug.fontWidth,love.graphics.getHeight())
			love.graphics.print(print_buffer,0,pos+Debug.fontHeight/2) 
			
		end
		-- -- Render Scene Stack -- --
		if Debug.activeSceneStack and not Debug.activeConsole and Debug.visible then
			local print_buffer = ""
			local max_wid = 0
			local hei = #SceneManager.sceneStack
			for i,v in ipairs(SceneManager.sceneStack) do
				local temp = " "..tostring(i).." -> "..SceneManager.sceneStack[i].debugName.."\n"
				print_buffer = temp..print_buffer
				max_wid = math.max(max_wid,string.len(temp))
			end
			-- Handles Empty Scene Stack
			if print_buffer == "" then
				print_buffer = " empty scene stack\n"
				max_wid = print_buffer:len()
				hei = 1
			end
			local posy = love.graphics.getHeight() - 14*(hei+1)
			local posx = love.graphics.getWidth() - 7*(max_wid)
			love.graphics.setColor(Debug.colorBack)
			love.graphics.rectangle("fill",posx,posy,love.graphics.getWidth(),love.graphics.getHeight())
			love.graphics.setColor(Debug.colorFront)
			love.graphics.line(posx,posy,posx,love.graphics.getHeight())
			love.graphics.line(posx,posy,love.graphics.getWidth(),posy)
			love.graphics.print(print_buffer,posx,posy+Debug.fontHeight/2) 
		end
		-- -- Render Console -- --
		if Debug.activeConsole then
			local current_line = 0
			local print_buffer = "" -- The buffer that has all input
			-- -- Render Input Bar to Buffer -- --
			local list = Debug.consoleInputBuffer:split("\n") -- Separates input lines
			for i,v in ipairs(list) do
				-- Fold the long lines
				local in_bufsize = utf8len(v)
				local in_linenum = math.ceil(in_bufsize/(Debug.consoleWidth-4)) -- Num of fold lines
				for j = 1,in_linenum do
					-- Gets Substring
					local lin_string = utf8sub(v,1+(Debug.consoleWidth-4)*(j-1),(Debug.consoleWidth-4)*j)
					-- Puts Carret "> " on the first line of folding
					local beginning = "  "
					if j == 1 then beginning = "> " end
					print_buffer = print_buffer..beginning..lin_string
					if j ~= in_linenum then print_buffer = print_buffer.."\n" end
					current_line = current_line + 1
				end
				if in_linenum == 0 then
					print_buffer = print_buffer.."> "
					current_line = current_line + 1
				end
				if i ~= #list then
					print_buffer = print_buffer.."\n"
					current_line = current_line + 1
				end
			end
			-- Add separation blank line and cursor
			if Debug.cursorDisplay then
				print_buffer = print_buffer..Debug.cursorChar
			end
			print_buffer = print_buffer.."\n\n"
			current_line = current_line + 1
			
			local input_size = current_line
			-- -- Render Output Bar to Buffer -- --
			for i = 1,#Debug.consoleBuffer do
				if i >= Debug.cursorBuffer then
					print_buffer = print_buffer..Debug.consoleBuffer[i].."\n"
					current_line = current_line + 1
				end
			end
			
			-- -- Render Box and Buffer to Screen -- --
			love.graphics.setColor(Debug.colorBack)
			love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),14*(current_line)+9)
			love.graphics.setColor(Debug.colorFront)
			love.graphics.line(0,14*(input_size-0.5)+2,love.graphics.getWidth(),14*(input_size-0.5)+2)
			love.graphics.line(0,14*(current_line)+9,love.graphics.getWidth(),14*(current_line)+9)
			love.graphics.print(print_buffer,0,2)
		end
	end
end

-----------------------------
-- -- KEYBOARD HANDLING -- --
-----------------------------

-- Gets keyboard input for console
function Debug.KeyPressed(k,unicode)
	local is_shift = love.keyboard.isDown("lshift","rshift")
	local is_alt = love.keyboard.isDown("ralt")
	-- Update capslock state
	if k == "capslock" then Debug.capslock = true return end
	if Debug.active then
		-- -- Process a key press inside console mode -- --
		if Debug.activeConsole then
			-- Gets key type
			k_type, k_subtype = Key.Type(k)
			-- If numpad is used, retrieve the normal version
			if k_type == "numpad" then
				k = utf8sub(k,3)
				if type(k) == "string" then
					unicode = string.byte(k)
				else
					unicode = string.byte(string.char(k))
				end
				lol = k
				k_type, k_subtype = Key.Type(k)
			end
			-- Process character key
			if k_type == "character" then
				Debug.startEditing = true
				-- -- Treats if dead key was pressed before -- --
				if Debug.accentActive then 
					local new_key = Key.Process(k,is_shift,is_alt,Debug.capslock)
					if Key.compose[Debug.accentBase] and Key.compose[Debug.accentBase][new_key] then
						-- Found key combination, so append composed character
						local compo_key = Key.compose[Debug.accentBase][new_key]
						Debug.consoleInputBuffer = Debug.consoleInputBuffer..compo_key
					else
						-- Key combination not found, so put both characters
						Debug.consoleInputBuffer = Debug.consoleInputBuffer..Debug.accentBase..new_key
					end
					Debug.accentActive = false
				-- -- Normal Character -- --
				else
					-- Holds a dead key
					if unicode == 0 and k ~= "unknown" then
						Debug.accentBase = Key.Process(k,is_shift,is_alt,Debug.capslock)
						Debug.accentActive = true
					-- Puts a processed character
					else
						local key = Key.Process(k,is_shift,is_alt,Debug.capslock)
						Debug.consoleInputBuffer = Debug.consoleInputBuffer..key
					end
				end
			-- Process editing keys
			elseif k_type == "editing" then
				if k == "backspace" then
					local n = utf8len(Debug.consoleInputBuffer)
					Debug.consoleInputBuffer = utf8sub(Debug.consoleInputBuffer,1,n-1)
				elseif k == "tab" then
					Debug.startEditing = true
					-- If Shift + Tab than gets out of Console
					if is_shift then
						Debug.ExitConsole()
					else
						Debug.consoleInputBuffer = Debug.consoleInputBuffer.."    "
					end
				-- -- Treats an Enter press -- --
				elseif k == "return" then
					-- Breaks the input line if shift is hold
					if is_shift then
						Debug.consoleInputBuffer = Debug.consoleInputBuffer.."\n"
					-- Process the input command
					elseif utf8len(Debug.consoleInputBuffer) > 0 then
						Debug.Execute()
					end
				end
			-- Process navigation keys
			elseif k_type == "navigation" then
				-- -- Output Console Navigation -- -- 
				if k == "left" then
					Debug.cursorBuffer = Debug.cursorBuffer - 1
					Debug.cursorBuffer = math.max(1,Debug.cursorBuffer)
				elseif k == "right" then
					Debug.cursorBuffer = Debug.cursorBuffer + 1
					Debug.cursorBuffer = math.min(#Debug.consoleBuffer,Debug.cursorBuffer)
				-- -- Input History Navigation -- --
				elseif k == "up" then
					Debug.History(1)
				elseif k == "down" then
					Debug.History(-1)
				end
			end
		-- -- Process a keypress outside console mode -- --
		else 
			if k == "tab" then
				if love.keyboard.isDown("lshift","rshift") then
					Debug.EnterConsole()
				else
					Debug.visible = not Debug.visible
				end
			end
		end
	end
end

-- Get keyboard releases (interesting only for capslock)
function Debug.KeyReleased(k)
	if k == "capslock" then Debug.capslock = false return end
end

------------------------------
-- -- EXECUTE THE BUFFER -- --
------------------------------
function Debug.Execute()
	local ret_string = ""
	local exec = Debug.consoleInputBuffer
	
	local mess_err = ""
	local cmd = nil
	
	local mode_short = false
	local special = false
	-- Special Commands
	if string.sub(exec, 1, 1) == "!" then
		special = true
		ret_string = string.expandtab(Debug.SpecialCommand(string.sub(exec,2)))
    -- Short Cut Return
    elseif string.sub(exec, 1, 1) == "@" then
		mode_short = true
		ret_string = ret_string..string.sub(exec, 2)
        exec = "return " .. string.sub(exec, 2)
        cmd, mess_err = loadstring(exec)
    -- Compile the string to a function
    else
        cmd, mess_err = loadstring(exec)
    end
	
	-- Error Handling
	local sucess = nil
	local result = ""
	-- Parse error
	if not special then
		if cmd == nil then
			ret_string = ret_string.."[PARSE ERROR] "..mess_err
		else
			-- Calls command on protected mode
			sucess, result = pcall(cmd)
			-- If runs ok, show output
			if sucess == true then
				if result ~= nil then
					ret_string = ret_string..tostring(show(result))
				elseif not mode_short then -- if command dont return, print the command
					ret_string = ret_string..exec
				else
					ret_string = ret_string.." = nil"
				end
			-- Execution error
			else
				ret_string = ret_string.."[EXEC ERROR] "..result
			end
		end
	end
	
	-- Post processing
	Debug.AppendConsoleBuffer(ret_string.."\n") -- Append output
	Debug.AddHistory(Debug.consoleInputBuffer) -- Updates History
	Debug.consoleInputBuffer = "" -- Clear buffer
	Debug.startEditing = false
	Debug.historyCursor = 0
end

----------------------------
-- -- SPECIAL COMMANDS -- --
----------------------------
function Debug.SpecialCommand(cmd)
	if cmd then
		if cmd == "clear" then
			Debug.consoleBuffer = {}
			return ""
		elseif cmd == "quit" then
			love.event.push("quit")
			return ""
		elseif cmd == "help" then
			local help_string =
[[ ____  ____  ____  ____  ____     ___  __   __ _  ____   __   __    ____ 
/ ___)(  _ \(  __)(  __)(    \   / __)/  \ (  ( \/ ___) /  \ (  )  (  __)
\___ \ ) __/ ) _)  ) _)  ) D (  ( (__(  O )/    /\___ \(  O )/ (_/\ ) _) 
(____/(__)  (____)(____)(____/   \___)\__/ \_)__)(____/ \__/ \____/(____)

		_____Welcome to the Awesome Lua/LÖVE2D Console _____________
		You can use @varname to show an value of any variable
		You can type any Lua valid command/function
		You can use !special to call any of theese special commands:
			!help    -> display this message
			!quit    -> quit the game
			!clear   -> clear the console buffer
			!dragon  -> display dragon, duh!
		To go in and out of the console, press SHIFT+TAB
		To switch the debug HUD, press TAB outside the console
		To make an watcher on one variable, use watch("varname")
		To unwatch one variable, use unwatch("varname")
		____________________________________________________________]]
			return help_string
	else
			return "[INVALID SPECIAL COMMAND]"
		end
	else
		return "[INVALID SPECIAL COMMAND]"
	end
end

--------------------------------------
-- -- CONSOLE AUXILIAR FUNCTIONS -- --
--------------------------------------

-- Print to Console output
function printc(...)
	for i = 1, arg.n - 1 do
		io.write(tostring(arg[i]).."    ")
	end
	io.write(tostring(arg[arg.n]).."\n")
end

-- Overrides lua`s io.write to console output
function io.write(...)
	for i,v in ipairs(arg) do
		Debug.AppendConsoleBuffer(v)
	end
end

-- Show function, shows in an human readable way information about an object
function show(t, indent)
	local cart     -- a container
	local autoref  -- for Debug references
	
	local function isemptytable(t) return next(t) == nil end
	
	local function basicSerialize (o)
		local so = tostring(o)
		if type(o) == "function" then
			local info = debug.getinfo(o, "S")
			-- info.name is nil because o is not a calling level
			if info.what == "C" then
				return string.format("%s", so .. ", C function")
			else 
				-- the information is defined through lines
				return string.format("%s", so .. ", defined in (" ..
					info.linedefined .. "-" .. info.lastlinedefined ..
					")" .. info.source)
			end
		elseif type(o) == "number" or type(o) == "boolean" or type(o) == "userdata" then
			return so
		elseif type(o) == "string" then
			return "\""..string.escape(o).."\""
		else
			return string.format("%q", so)
		end
	end
	
	local function addtocart (value, name, indent, saved, field)
		indent = indent or ""
		saved = saved or {}
		field = field or name
		
		cart = cart .. indent .. field
	
		if type(value) ~= "table" then
			cart = cart .. " = " .. basicSerialize(value) .. "\n"
		else
			if saved[value] then
				cart = cart .. " = {} -- " .. saved[value] 
                    .. " (Debug reference)\n"
				autoref = autoref ..  name .. " = " .. saved[value] .. "\n"
			else
				saved[value] = name
				if isemptytable(value) then
					cart = cart .. " = {}\n"
				else
					cart = cart .. " = {\n"
					for k, v in pairs(value) do
						local k2 = basicSerialize(k)
						local fname = string.format("%s[%s]", name, k2)
						if tonumber(k) ~= nil then
							field = string.format("[%s]", k2)
						else
							field = tostring(k)
						end
						-- four spaces between levels
						addtocart(v, fname, indent .. "    ", saved, field)
					end
					cart = cart .. indent .. "}\n"
				end
			end
		end
	end
		
	if t then
		if type(t) ~= "table" then
			return " = "..basicSerialize(t)
		else
			ending = true
		end
		cart, autoref = "", ""
		addtocart(t, "", "")
		local toret = cart..autoref
		if ending then
			toret = utf8sub(toret,1,string.len(toret)-1)
		end
		return toret
	else
		return " = nil"
	end
end

-----------------------------
-- -- CONSOLE SHORTCUTS -- --
-----------------------------

-- Watch an variable
function watch(name)
	Debug.AddWatcher(name)
end

-- Unwatch an variable
function unwatch(name)
	Debug.RemoveWatcher(name)
end

-- Show memory usage
function memory()
	return tostring(((gcinfo())).."KBs")
end


