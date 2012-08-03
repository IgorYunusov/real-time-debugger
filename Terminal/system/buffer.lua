--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: system/buffer.lua
Description: Buffer and Multibuffer classes for console string management
Notes:
]]

require "system/utils"

-- Single Line Buffer
Buffer = {}
function Buffer:new(str)
	local obj = {}
	
	-- Constructor
	local bufferMaxSize = 1000
	local buff = ""
	if str and type(str) == "string" and utf8len(str) <= bufferMaxSize then buff = str end
	
	-- Get the size of the Buffer
	function obj:size()
		s = utf8len(buff)
		assert(s >= 0 and s <= bufferMaxSize,"Buffer Size Error")
		return s
	end
	
	-- Get the Buffer string
	function obj:str()
		return buff
	end
	
	-- Append a string to the Buffer
	function obj:append(str)
		if type(str) ~= "string" then str = tostring(str) end
		s1 , s2 = self:size() , utf8len(str)
		if s1 + s2 <= bufferMaxSize then
			buff = buff..str
			assert(self:size()<=bufferMaxSize,"Buffer Size Error")
		else
			buff = buff..utf8sub(str,buffMaxSize - s1)
			assert(self:size()==bufferMaxSize,"Buffer Size Error")
		end
	end
	
	return obj
end

-- Multiline Buffer
MultiBuffer = {} 
function MultiBuffer:new(max_lines,line_width)
	local obj = {}
	
	-- Constructor
	local bufferMaxSize = max_lines or 1000
	local bufferMaxWidth = line_width
	local buffers = {}
	
	-- Get the number of lines
	function obj:line_num()
		local n = #buffers
		assert(n >= 0 and n <= bufferMaxSize, "Buffer Line Number Error")
		return n
	end
	
	-- Get a single string with all lines of the Buffer
	function obj:str()
		local str = ""
		for i,v in ipairs(buffers) do
			str = str .. v:str() .. "\n"
		end
		return str
	end
	
	-- Append a string on a new line of the buffer
	function obj:append(str) -- Others modes here
		if str then
			local list = str:split("\n") -- Split input in the breaklin
			for i,v in ipairs(list) do
				local in_bufsize = utf8len(v)
				local in_linenum = math.ceil(in_bufsize/Debug.consoleWidth)
				assert(in_linenum > 0, "Buffer Line Folding Error")
				
				for j = 1,in_linenum do
					local lin_string = utf8sub(v,1+bufferMaxWidth*(j-1),bufferMaWidth*j)
					
				end
			end
		end
	end
	
end

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