--[[
Real-time Debugger and Profiller

Copyright (C) 2012 Victor Seixas Souza
Read license.txt for the full license terms

File: system/keyboard.lua
Description: Handles Love2D keyboard constants and helps text input
Notes:
]]

require "personalconfig"

Key = {}

-- Key Constants
Key.char_alphabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n",
"o","p","q","r","s","t","u","v","w","x","y","z","unknown"} 

Key.char_number = {"0","1","2","3","4","5","6","7","8","9"}

Key.char_minsc = {" ","!",[["]],"#","$","&",[[']],"(",")","*","+",",","-",
".","/",":",";","<","=",">","?","@","[",[[\]],"]","^","_",[[`]],} 

Key.numpad_number = {"kp0","kp1","kp2","kp3","kp4","kp5","kp6","kp7","kp8","kp9"}

Key.numpad_minsc = {"kp.","kp/","kp*","kp-","kp+","kp=","kpenter"} 

Key.navigation = {"up","down","right","left","home","end","pageup","pagedown"}

Key.editing = {"insert","backspace","tab","clear","return","delete"}

Key.func = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15"}

Key.modifier = { "numlock","capslock","scrollock","rshift","lshift","rctrl","lctrl",
"ralt","lalt","rmeta","lmeta","lsuper","rsuper","mode","compose"}

Key.minsc = { "pause","escape","help","print","sysreq","break","menu","power","euro","undo"}

-- Key Composition ( Multiple keypresses for one character )
Key.compose = {}

-- Case-Switched versions of non-alphabetic characters
Key.cased = {}
Key.alt = {} --// Casing for Alt Gr / Rigth alt

-- Direct translation between layout and US-International layout
Key.translate = {}

if KeyboardDebugLayout == nil then KeyboardDebugLayout = "US-INTERNATIONAL" end
if KeyboardDebugLayout == "US-INTERNATIONAL" then
	Key.compose["'"] = {}
	Key.compose["'"][" "]=[[']]
	Key.compose["'"]["a"]="á"
	Key.compose["'"]["A"]="Á"
	Key.compose["'"]["e"]="é"
	Key.compose["'"]["E"]="É"
	Key.compose["'"]["i"]="í"
	Key.compose["'"]["I"]="Í"
	Key.compose["'"]["o"]="ó"
	Key.compose["'"]["O"]="Ó"
	Key.compose["'"]["u"]="ú"
	Key.compose["'"]["U"]="Ú"
	Key.compose["'"]["c"]="ç"
	Key.compose["'"]["C"]="Ç"
	Key.compose["^"] = {}
	Key.compose["^"][" "]="^"
	Key.compose["^"]["a"]="â"
	Key.compose["^"]["A"]="Â"
	Key.compose["^"]["e"]="ê"
	Key.compose["^"]["E"]="Ê"
	Key.compose["^"]["i"]="î"
	Key.compose["^"]["I"]="Î"
	Key.compose["^"]["o"]="ô"
	Key.compose["^"]["O"]="Ô"
	Key.compose["^"]["u"]="û"
	Key.compose["^"]["U"]="Û"
	Key.compose["`"] = {}
	Key.compose["`"][" "]="`"
	Key.compose["`"]["a"]="à"
	Key.compose["`"]["A"]="À"
	Key.compose["`"]["e"]="è"
	Key.compose["`"]["E"]="È"
	Key.compose["`"]["i"]="ì"
	Key.compose["`"]["I"]="Ì"
	Key.compose["`"]["o"]="ò"
	Key.compose["`"]["O"]="Ò"
	Key.compose["`"]["u"]="ù"
	Key.compose["`"]["U"]="Ù"
	Key.compose["~"] = {}
	Key.compose["~"][" "]="~"
	Key.compose["~"]["a"]="ã"
	Key.compose["~"]["A"]="Ã"
	Key.compose["~"]["o"]="õ"
	Key.compose["~"]["O"]="Õ"
	Key.compose["\""] = {}
	Key.compose["\""][" "]=[["]]
	Key.compose["\""]["a"]="ä"
	Key.compose["\""]["A"]="Ä"
	Key.compose["\""]["e"]="ë"
	Key.compose["\""]["E"]="Ë"
	Key.compose["\""]["i"]="ï"
	Key.compose["\""]["I"]="Ï"
	Key.compose["\""]["o"]="ö"
	Key.compose["\""]["O"]="Ö"
	Key.compose["\""]["u"]="ü"
	Key.compose["\""]["U"]="Ü"
	
	Key.cased["`"] = "~"
	Key.cased["1"] = "!"
	Key.cased["2"] = "@"
	Key.cased["3"] = "#"
	Key.cased["4"] = "$"
	Key.cased["5"] = "%"
	Key.cased["6"] = "^"
	Key.cased["7"] = "&"
	Key.cased["8"] = "*"
	Key.cased["9"] = "("
	Key.cased["0"] = ")"
	Key.cased["-"] = "_"
	Key.cased["="] = "+"
	Key.cased["["] = "{"
	Key.cased["]"] = "}"
	Key.cased["\\"] = "|"
	Key.cased[";"] = ":"
	Key.cased["'"] = "\""
	Key.cased[","] = "<"
	Key.cased["."] = ">"
	Key.cased["/"] = "?"
	
elseif KeyboardDebugLayout == "ABNT" then
	Key.compose["´"] = {}
	Key.compose["´"][" "]="´"
	Key.compose["´"]["a"]="á"
	Key.compose["´"]["A"]="Á"
	Key.compose["´"]["e"]="é"
	Key.compose["´"]["E"]="É"
	Key.compose["´"]["i"]="í"
	Key.compose["´"]["I"]="Í"
	Key.compose["´"]["o"]="ó"
	Key.compose["´"]["O"]="Ó"
	Key.compose["´"]["u"]="ú"
	Key.compose["´"]["U"]="Ú"
	Key.compose["^"] = {}
	Key.compose["^"][" "]="^"
	Key.compose["^"]["a"]="â"
	Key.compose["^"]["A"]="Â"
	Key.compose["^"]["e"]="ê"
	Key.compose["^"]["E"]="Ê"
	Key.compose["^"]["i"]="î"
	Key.compose["^"]["I"]="Î"
	Key.compose["^"]["o"]="ô"
	Key.compose["^"]["O"]="Ô"
	Key.compose["^"]["u"]="û"
	Key.compose["^"]["U"]="Û"
	Key.compose["`"] = {}
	Key.compose["`"][" "]="`"
	Key.compose["`"]["a"]="à"
	Key.compose["`"]["A"]="À"
	Key.compose["`"]["e"]="è"
	Key.compose["`"]["E"]="È"
	Key.compose["`"]["i"]="ì"
	Key.compose["`"]["I"]="Ì"
	Key.compose["`"]["o"]="ò"
	Key.compose["`"]["O"]="Ò"
	Key.compose["`"]["u"]="ù"
	Key.compose["`"]["U"]="Ù"
	Key.compose["~"] = {}
	Key.compose["~"][" "]="`"
	Key.compose["~"]["a"]="ã"
	Key.compose["~"]["A"]="Ã"
	Key.compose["~"]["o"]="õ"
	Key.compose["~"]["O"]="Õ"
	Key.compose["¨"] = {}
	Key.compose["¨"][" "]=[["]]
	Key.compose["¨"]["a"]="ä"
	Key.compose["¨"]["A"]="Ä"
	Key.compose["¨"]["e"]="ë"
	Key.compose["¨"]["E"]="Ë"
	Key.compose["¨"]["i"]="ï"
	Key.compose["¨"]["I"]="Ï"
	Key.compose["¨"]["o"]="ö"
	Key.compose["¨"]["O"]="Ö"
	Key.compose["¨"]["u"]="ü"
	Key.compose["¨"]["U"]="Ü"
	
	Key.cased["'"] = "\""
	Key.cased["1"] = "!"
	Key.cased["2"] = "@"
	Key.cased["3"] = "#"
	Key.cased["4"] = "$"
	Key.cased["5"] = "%"
	Key.cased["6"] = "¨"
	Key.cased["7"] = "&"
	Key.cased["8"] = "*"
	Key.cased["9"] = "("
	Key.cased["0"] = ")"
	Key.cased["-"] = "_"
	Key.cased["="] = "+"
	Key.cased["´"] = "`"
	Key.cased["["] = "{"
	Key.cased["~"] = "|"
	Key.cased["]"] = "}"
	Key.cased["\\"] = "|"
	Key.cased[","] = "<"
	Key.cased["."] = ">"
	Key.cased[";"] = ":"
	Key.cased["/"] = "?"
	
	Key.alt["q"] = "/"
	Key.alt["w"] = "?"
	
	Key.translate["`"]="'"
	Key.translate["["]="´"
	Key.translate["]"]="["
	Key.translate[";"]="ç"
	Key.translate["'"]="~"
	Key.translate["\\"]="]"
	Key.translate["<"]="\\"
	Key.translate["/"]=";"
	Key.translate["/"]=";"
	Key.translate["unknown"]="/"
	
end


-- Returns type of the key
function Key.Type(k)
	local found = false
	
	-- Character Alphabet
	for i,v in ipairs(Key.char_alphabet) do
		if k == v then found = true break end
	end
	if found then return "character","alphabet" end
	
	-- Character Numbers
	for i,v in ipairs(Key.char_number) do
		if k == v then found = true break end
	end
	if found then return "character","number" end
	
	-- Character Minsc
	for i,v in ipairs(Key.char_minsc) do
		if k == v then found = true break end
	end
	if found then return "character","minsc" end
	
	-- Numpad Number
	for i,v in ipairs(Key.numpad_number) do
		if k == v then found = true break end
	end
	if found then return "numpad","number" end
	
	-- Numpad Minsc
	for i,v in ipairs(Key.numpad_minsc) do
		if k == v then found = true break end
	end
	if found then return "numpad","minsc" end
	
	-- Navigation
	for i,v in ipairs(Key.navigation) do
		if k == v then found = true break end
	end
	if found then return "navigation" end
	
	-- Editing
	for i,v in ipairs(Key.editing) do
		if k == v then found = true break end
	end
	if found then return "editing" end
	
	-- Function
	for i,v in ipairs(Key.func) do
		if k == v then found = true break end
	end
	if found then return "function" end
	
	-- Modifiers
	for i,v in ipairs(Key.modifier) do
		if k == v then found = true break end
	end
	if found then return "modifier" end
	
	-- Minsc
	for i,v in ipairs(Key.minsc) do
		if k == v then found = true break end
	end
	if found then return "minsc" end
	
	return "invalid"
end

function Key.Process(key,shift,alt,capslock)
	if Key.translate[key] then key = Key.translate[key] end
	local changecase = (shift and not capslock) or (capslock and not shift)
	if changecase then
		local found = false
		if type(key) == "string" then
			-- Tries to find key on the alphabet lowered
			for i,v in ipairs(Key.char_alphabet) do
				if key == v then found = true break end
			end
			if found then return string.upper(key) end
			-- Tries to find key on the alphabet uppercased
			for i,v in ipairs(Key.char_alphabet) do
				if key == string.upper(v) then found = true break end
			end
			if found then return string.lower(key) end
		end
	end
	-- If not found, tries to find on special case table
	if shift then
		if Key.cased[key] then return Key.cased[key] end
	elseif alt then
		if Key.alt[key] then return Key.alt[key] end
	end
	-- If not found or changed, return the raw key
	return key
end
