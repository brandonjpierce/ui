setfenv(1, SmellyUI.engine)

local f = CreateFrame('Frame')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end

  f:UnregisterEvent('ADDON_LOADED')

  hooksecurefunc(OpenMailFrame, 'Show', function()
    if not IsShiftKeyDown() then return end

    if OpenMailMoneyButton:IsVisible() then
      OpenMailMoneyButton:Click()
    end

    if OpenMailPackageButton:IsVisible() then
      OpenMailPackageButton:Click()
    end
  end)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
