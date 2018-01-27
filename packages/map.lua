setfenv(1, SmellyUI.engine)

-- TODO
-- 1. Zone coords
-- 2. Current time
-- 3. Latency & Ping

local backdrop = S.backdrop
local inside = S.inside
local kill = S.kill
local point = S.point
local size = S.size

local f = CreateFrame('Frame')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  -- HIDE BLIZZARD --

  local hideFrames = {
    MinimapBorder,
    MinimapBorderTop,
    MinimapZoomIn,
    MinimapZoomOut,
    MinimapToggleButton,
    MinimapZoneTextButton,
    MiniMapMailBorder,
    GameTimeFrame,
  }

  for _, frame in pairs(hideFrames) do
    kill(frame)
  end

  -- STYLE --

  Minimap:SetParent(UIParent)
  Minimap:SetMaskTexture('Interface\\AddOns\\SmellyUI\\textures\\blank')
  Minimap:ClearAllPoints()
  size(Minimap, 160)
  backdrop(Minimap)
  point(Minimap, 'BOTTOM', 0, 20)

  -- mail icon
  MiniMapMailFrame:ClearAllPoints()
  point(MiniMapMailFrame, 'TOPRIGHT', Minimap, 'TOPRIGHT', 0, 3)
  size(MiniMapMailFrame, 30)

  MiniMapMailIcon:SetTexture(C.textures.mail)
  inside(MiniMapMailIcon)

  -- INTERACTIONS --

  Minimap:EnableMouseWheel(true)
  Minimap:SetScript('OnMouseWheel', function()
    if arg1 > 0 then
      Minimap_ZoomIn()
    else
      Minimap_ZoomOut()
    end
  end)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
