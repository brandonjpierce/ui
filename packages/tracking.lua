setfenv(1, SmellyUI.engine)

local kill = S.kill

local f = CreateFrame('Frame')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  -- TODO
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
