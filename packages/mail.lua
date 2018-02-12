local S, C = SmellyUI:unpack()

local f = CreateFrame('Frame')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  -- TODO: fix this
  HookScript(OpenMailFrame, 'OnShow', function()
    p('wat')
    if not IsShiftKeyDown() then return end

    if OpenMailMoneyButton:IsVisible() then
      OpenMailMoneyButton:Click()
    end

    if OpenMailPackageButton:IsVisible() then
      OpenMailPackageButton:Click()
    end
  end)
end

function f:OnEvent()
  this[event](this, arg1)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', f.OnEvent)
