local print, format_string, format_value, print_pair, print_table, inspect, setting, max_depth

function print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 0, 0)
end

function format_string(s)
	return '"' .. gsub(gsub(s, '\\', '\\\\'), '"', '\"') .. '"'
end

function format_value(v)
	return type(v) == 'string' and format_string(v) or tostring(v)
end

function print_pair(k, v, depth)
	local padding = strrep(' ', depth * 4)
	print(padding .. '[' .. format_value(k) .. ']' .. ' = ' .. format_value(v))
	if type(v) == 'table' then
		if next(v) then
			print(padding .. '{')
			if depth == max_depth then
				print(padding .. '    ...')
			else
				print_table(v, depth + 1)
			end
			print(padding .. '}')
		end
	end
end

function print_table(t, depth)
	for i = 1, getn(t) do
		print_pair(i, t[i], depth)
	end
	for k, v in pairs(t) do
		if type(k) ~= 'number' or k < 1 or k > getn(t) then
			print_pair(k, v, depth)
		end
	end
end

function inspect(_, ...)
	local n = arg.n
	arg.n = nil
	if n == 0 then
		print('void')
	else
		table.setn(arg, n)
		max_depth = max_depth or 2
		print_table(arg, 0)
		max_depth = nil
	end
	return unpack(arg)
end

local function setting(v)
	if type(v) == 'number' then
		max_depth = v
	elseif type(v) == 'function' then
		print('#' .. v())
	else
		print('#' .. v)
	end
end

p = setmetatable({}, {
	__metatable=false,
	__call=inspect,
	__pow=inspect,
	__index = function(self, key)
		setting(key)
		return self
	end,
	__newindex = function(self, key, value)
		setting(key)
		inspect(nil, value)
		return self
	end,
})







-- taken from Elvui

--Cache global variables
--Lua functions
local _G = _G
local print, tostring, select = print, tostring, select
local strlower = strlower
local format = format
--WoW API / Variables
local GetMouseFocus = GetMouseFocus
local FrameStackTooltip_Toggle = FrameStackTooltip_Toggle
local IsAddOnLoaded = IsAddOnLoaded
local GetAddOnInfo = GetAddOnInfo
local LoadAddOn = LoadAddOn

SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil then FRAME = arg end --Set the global variable FRAME to = whatever we are mousing over to simplify messing with frames that have no name.
	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end

		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())

		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end
