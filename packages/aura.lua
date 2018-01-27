setfenv(1, SmellyUI.engine)

-- TODO
-- 1. Skin and position weapon frame / buffs

local backdrop = S.backdrop
local inside = S.inside
local kill = S.kill
local noop = S.noop
local point = S.point
local size = S.size

local f = CreateFrame('Frame')
local buffs = CreateFrame('Frame')

local function skin(name)
  local button = _G[name]
  local border = _G[name .. 'Border']
  local icon = _G[name .. 'Icon']
  local text = _G[name .. 'Duration']

  size(button, 40)
  backdrop(button)

  if border then
    button.bg:SetBackdropBorderColor(border:GetVertexColor())
    kill(border)
  end

  icon:SetTexCoord(.08, .92, .08, .92)
  icon:ClearAllPoints()
  inside(icon, button)

  text:ClearAllPoints()
  point(text, 'TOP', button, 'BOTTOM', 0, -5)
end

local function position(elapsed)
  BuffFrame:ClearAllPoints()
  point(BuffFrame, 'TOPRIGHT', UIParent, 'TOPRIGHT', -10, -10)
end

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end

  f:UnregisterEvent('ADDON_LOADED')

  skin('TempEnchant1')
  skin('TempEnchant2')

  for i = 0, 23 do
    skin('BuffButton' .. i)
  end

  hooksecurefunc('BuffFrame_Enchant_OnUpdate', position)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
