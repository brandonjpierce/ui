setfenv(1, SmellyUI.engine)

local f = CreateFrame('Frame')

local unitframe = CreateFrame('Frame', 'SmellyUI_Player', UIParent)

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  PlayerFrame:Hide()
  PlayerFrame:UnregisterAllEvents()
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
