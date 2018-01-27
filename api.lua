setfenv(1, SmellyUI.engine)

local floor = math.floor

local noop = function() end
local blank = C.textures.blank;
local mult = C.graphics.mult

local backdropConfig = {
  tile = false,
  tileSize = 0,
	bgFile = blank,
  edgeFile = blank,
  edgeSize = mult,
	insets = { top = 0, left = 0, bottom = 0, right = 0 },
}

local bgColor = unpack({ r = 0, g = 0, b = 0 })

local function scale(value)
  return mult * value
end

local function width(frame, width)
  frame:SetWidth(scale(width))
end

local function height(frame, height)
  frame:SetHeight(scale(height))
end

local function size(frame, w, h)
  width(frame, w)
  height(frame, h or w)
end

local function point(frame, arg1, arg2, arg3, arg4, arg5)
  -- TODO: figure out why the below fudges up stuff
  -- if type(arg1) == 'number' then arg1 = scale(arg1) end
	-- if type(arg2) == 'number' then arg2 = scale(arg2) end
	-- if type(arg3) == 'number' then arg3 = scale(arg3) end
	-- if type(arg4) == 'number' then arg4 = scale(arg4) end
	-- if type(arg5) == 'number' then arg5 = scale(arg5) end

	frame:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function kill(object)
  if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end

	object.Show = noop
	object:Hide()
end

local function strip(object)
	for i, frame in ipairs({ object:GetRegions() }) do
		if frame:GetObjectType() == "Texture" then
			frame:SetTexture(nil)
		end

    if frame:GetObjectType() == "Text" then
			frame:SetTexture(nil)
		end
	end
end

local function inside(frame, anchor, xOffset, yOffset)
  xOffset = xOffset or 1
  yOffset = yOffset or 1
  anchor = anchor or frame:GetParent()

  if frame:GetPoint() then frame:ClearAllPoints() end

  point(frame, 'TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
  point(frame, 'BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
end

local function outside(frame, anchor, xOffset, yOffset)
	xOffset = xOffset or 1
	yOffset = yOffset or 1
	anchor = anchor or frame:GetParent()

	if frame:GetPoint() then frame:ClearAllPoints() end

	point(frame, 'TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	point(frame, 'BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end


local function backdrop(frame)
  if frame.bg then return end

  local bg = CreateFrame('Frame', nil, frame)

  bg:SetBackdrop(backdropConfig)
  bg:SetBackdropColor(bgColor)
  bg:SetBackdropBorderColor(bgColor)
  outside(bg, frame)

  local level = frame:GetFrameLevel()

  if level - 1 >= 0 then
		bg:SetFrameLevel(level - 1)
	else
		bg:SetFrameLevel(0)
	end

	frame.bg = bg
end

S.backdrop = backdrop
S.height = height
S.inside = inside
S.kill = kill
S.outside = outside
S.point = point
S.scale = scale
S.size = size
S.strip = strip
S.width = width
