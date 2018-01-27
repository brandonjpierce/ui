setfenv(1, SmellyUI.engine)

local backdrop = S.backdrop
local kill = S.kill
local point = S.point
local size = S.size
local strip = S.strip

local f = CreateFrame('Frame')
local scale = GetCVar('UIScale')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end

  f:UnregisterEvent('ADDON_LOADED')

  local hideFrames = {
    BlackoutWorld,
    WorldMapFrameCloseButton,
    WorldMapMagnifyingGlassButton,
    WorldMapTitle,
    WorldMapTitleDropDown,
  }

  for _, frame in pairs(hideFrames) do
    kill(frame)
  end

  hooksecurefunc(WorldMapFrame, 'Show', function(self)
    self:SetScale(scale)
    UpdateMicroButtons()
    PlaySound('igQuestLogOpen')
    CloseDropDownMenus()
    SetMapToCurrentZone()
    WorldMapFrame_PingPlayerPosition()
  end)

  UIPanelWindows['WorldMapFrame'] = {
    area = 'center',
    pushable = 0
  }

  WorldMapFrame:ClearAllPoints()
  WorldMapFrame:EnableKeyboard(false)
  WorldMapFrame:EnableMouse(true)

  strip(WorldMapFrame)
  backdrop(WorldMapButton)
  point(WorldMapFrame, 'CENTER', UIParent, 'CENTER', 0, 0)
  size(WorldMapFrame, WorldMapButton:GetWidth(), WorldMapButton:GetHeight())
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
