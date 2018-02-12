local S, C = SmellyUI:unpack()

local backdrop = S.backdrop
local height = S.height
local point = S.point
local size = S.size

local f = CreateFrame('Frame')
local xp = CreateFrame('Frame')
local blocks = 20
local anim
local progressXp

local function updateXp()
  xp:UnregisterEvent('PLAYER_ENTERING_WORLD')

  local max = UnitXPMax('player')

  if max ~= 0 then
    local currentXp = UnitXP('player')
    local currentRested = GetXPExhaustion()
    local isRested = GetRestState()

    xp.bar:SetMinMaxValues(0, max)

    progressXp:SetChange(currentXp)
    progressXp:Play()

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
  xp.bg:SetBackdropColor(15/255, 15/255, 15/255)

  xp.bar = CreateFrame('StatusBar', nil, xp)
  xp.bar:SetStatusBarTexture(C.textures.blank)
  xp.bar:ClearAllPoints()
  xp.bar:SetAllPoints(xp)
  xp.bar:SetFrameStrata('MEDIUM')
  xp.bar:SetStatusBarColor(213/255, 147/255, 0/255)

  xp.rested = CreateFrame('StatusBar', nil, xp)
  xp.rested:SetStatusBarTexture(C.textures.blank)
  xp.rested:ClearAllPoints()
  xp.rested:SetAllPoints(xp)
  xp.rested:SetFrameStrata('LOW')
  xp.rested:SetStatusBarColor(213/255, 147/255, 0/255)
  xp.rested:SetAlpha(0.3)
  xp.rested:Hide()

  local separatorSpacing = S.scale(xp:GetWidth() / blocks)

  for i = 1, blocks do
    local sep = CreateFrame('Frame', 'XpSep' .. i, xp)
    sep:SetFrameStrata('HIGH')
    S.size(sep, 1, 10)
    backdrop(sep)
    sep.bg:SetAllPoints()

    if i == 1 then
      point(sep, 'LEFT', xp, 'LEFT', separatorSpacing, 0)
    else
      local last = _G['XpSep' .. i - 1]
      point(sep, 'LEFT', last, 'LEFT', separatorSpacing, 0)
    end
  end

  anim = CreateAnimationGroup(xp.bar)
  progressXp = anim:CreateAnimation('progress')
  progressXp:SetDuration(2)
  progressXp:SetSmoothing('inout')

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
