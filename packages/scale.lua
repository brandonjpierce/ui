setfenv(1, SmellyUI.engine)

local f = CreateFrame('Frame')

function f:PLAYER_ENTERING_WORLD(addon)
  f:UnregisterEvent('PLAYER_ENTERING_WORLD')

  -- TODO
end

f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
