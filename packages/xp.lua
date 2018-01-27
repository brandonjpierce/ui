setfenv(1, SmellyUI.engine)

local backdrop = S.backdrop
local height = S.height
local point = S.point
local size = S.size

local f = CreateFrame('Frame')
local xp = CreateFrame('Frame')
local restedColor = { 75/255, 175/255, 76/255 }
local xpColor = { 0/255, 144/255, 255/255 }

local function updateXp()
  xp:UnregisterEvent('PLAYER_ENTERING_WORLD')

  local max = UnitXPMax('player')

  if max ~= 0 then
    local currentXp = UnitXP('player')
    local currentRested = GetXPExhaustion()
    local isRested = GetRestState()

    xp.bar:SetMinMaxValues(0, max)
    xp.bar:SetValue(currentXp)

    if isRested == 1 and currentRested then
      xp.rested:Show()
      xp.rested:SetMinMaxValues(0, max)
      xp.rested:SetValue(currentXp + currentRested)
    end
  end
end

local function showTooltip()
  GameTooltip:SetOwner(xp, 'ANCHOR_CURSOR')
  GameTooltip:ClearLines()

  local cur = UnitXP('player')
  local max = UnitXPMax('player')
  local rested = GetXPExhaustion()

  GameTooltip:AddLine('Experience')
  GameTooltip:AddLine(' ')
  GameTooltip:AddDoubleLine('XP:', format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
  GameTooltip:AddDoubleLine('Remaining:', format(' %d (%d%% - %d '..'Bars'..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)

  if rested then
    GameTooltip:AddDoubleLine('Rested:', format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)
  end

  GameTooltip:Show()
end

local function hideTooltip()
  GameTooltip:Hide()
end

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end

  f:UnregisterEvent('ADDON_LOADED')

  xp:SetFrameStrata('BACKGROUND')
  xp:EnableMouse()
  point(xp, 'BOTTOMLEFT', -1, -2)
  point(xp, 'BOTTOMRIGHT', 1, -2)
  height(xp, 10)
  backdrop(xp)

  xp.bar = CreateFrame('StatusBar', nil, xp)
  xp.bar:SetStatusBarTexture(C.textures.blank)
  xp.bar:ClearAllPoints()
  xp.bar:SetAllPoints(xp)
  xp.bar:SetFrameStrata('HIGH')
  xp.bar:SetStatusBarColor(unpack(xpColor))

  xp.rested = CreateFrame('StatusBar', nil, xp)
  xp.rested:SetStatusBarTexture(C.textures.blank)
  xp.rested:ClearAllPoints()
  xp.rested:SetAllPoints(xp)
  xp.rested:SetFrameStrata('MEDIUM')
  xp.rested:SetStatusBarColor(unpack(restedColor))
  xp.rested:SetAlpha(0.5)
  xp.rested:Hide()

  xp:RegisterEvent('PLAYER_XP_UPDATE')
  xp:RegisterEvent('PLAYER_LEVEL_UP')
  xp:RegisterEvent('UPDATE_EXHAUSTION')
  xp:RegisterEvent('PLAYER_ENTERING_WORLD')
  xp:RegisterEvent('PLAYER_UPDATE_RESTING')

  xp:SetScript('OnEvent', updateXp)
  xp:SetScript('OnEnter', showTooltip)
  xp:SetScript('OnLeave', hideTooltip)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
