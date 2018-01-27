setfenv(1, SmellyUI.engine)

-- TODO
-- 1. Optimize local vars
-- 2. Setup hover bind feature from Elv
-- 4. Test the shit out things

local buttonSize = 40
local spacing = 2

local f = CreateFrame('Frame')

local actionbars = CreateFrame('Frame', 'SmellyUI_Actionbars', UIParent)
actionbars.bar1 = CreateFrame('Frame', 'SmellyUI_Actionbar1', UIParent)
actionbars.bar2 = CreateFrame('Frame', 'SmellyUI_Actionbar2', UIParent)
actionbars.bar3 = CreateFrame('Frame', 'SmellyUI_Actionbar3', UIParent)
actionbars.bar4 = CreateFrame('Frame', 'SmellyUI_Actionbar4', UIParent)
actionbars.bar5 = CreateFrame('Frame', 'SmellyUI_Actionbar5', UIParent)
actionbars.bonus = CreateFrame('Frame', 'SmellyUI_Actionbar6', UIParent)
actionbars.shapeshift = CreateFrame('Frame', 'SmellyUI_Actionbar7', UIParent)
actionbars.pet = CreateFrame('Frame', 'SmellyUI_Actionbar8', UIParent)

local function skin(button, normalTextureName)
  if not button then button = this end
  if button.skinned then return end

  normalTextureName = normalTextureName or 'NormalTexture'

  local name = button:GetName()
  local icon = _G[name..'Icon']
  local count = _G[name..'Count']
  local hotkey = _G[name..'HotKey']
  local border  = _G[name..'Border']
  local normal  = _G[name..normalTextureName]
  local cooldown = _G[name..'Cooldown']
  local flash = _G[name..'Flash']
  local autocast = _G[name .. 'AutoCast']
  local castable = _G[name .. 'AutoCastable']
  local shine = _G[name .. 'Shine']

  S.size(button, buttonSize)
  S.backdrop(button)
  button.bg:SetAllPoints()

  if normal then
    button:SetNormalTexture('')
    button.SetNormalTexture = S.noop
    normal:SetTexture(nil)
    normal:SetAlpha(0)
    normal:Hide()
  end

  if flash then
    S.kill(flash)
  end

  if border then
    S.kill(border)
  end

  if hotkey then
    S.kill(hotkey)
  end

  if autocast then
    autocast:SetScale(buttonSize / 30)
    autocast:SetAlpha(0.25)
    autocast:SetAllPoints(button)
  end

  if castable then
    S.kill(castable)
  end

  if count then
    count:ClearAllPoints()
    S.point(count, 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', -3, 3)
  end

  if cooldown then
    cooldown:SetScale(buttonSize / 36)
    cooldown:ClearAllPoints()
    cooldown:SetAllPoints(button)
  end

  if icon then
    icon:SetParent(button)
    icon:ClearAllPoints()
    icon:SetTexCoord(.08, .92, .08, .92)
    icon:SetDrawLayer('BACKGROUND', 7)
    S.inside(icon, button)
  end

  if shine then
    shine:ClearAllPoints()
    S.size(shine, buttonSize)
    S.inside(shine, button)
  end

  if button.SetHighlightTexture and not button.hover then
    local hover = button:CreateTexture()
    hover:SetTexture(1, 1, 1, 0.3)
    S.inside(hover, button)
    button.hover = hover
    button:SetHighlightTexture(hover)
  end

  if button.SetPushedTexture and not button.pushed then
    local pushed = button:CreateTexture()
    pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
    S.inside(pushed, button)
    button.pushed = pushed
    button:SetPushedTexture(pushed)
  end

  if button.SetCheckedTexture and not button.checked then
    local checked = button:CreateTexture()
    checked:SetTexture(0,1,0,.3)
    S.inside(checked, button)
    button.checked = checked
    button:SetCheckedTexture(checked)
  end

  button.skinned = true
end

local function setupBar(frame, buttonRef, buttonCount)
  buttonCount = buttonCount or NUM_ACTIONBAR_BUTTONS

  frame:SetFrameStrata('LOW')
  frame:SetFrameLevel(3)
  S.size(frame, (buttonSize  * buttonCount + (spacing * buttonCount - 1)), buttonSize)

  for i = 1, buttonCount do
    local button = _G[buttonRef .. i]

    if button then
      button:ClearAllPoints()

      if i == 1 then
        S.point(button, 'LEFT', frame, 'LEFT', 0, 0)
      else
        local previous = _G[buttonRef .. (i - 1)]
        S.point(button, 'LEFT', previous, 'RIGHT', spacing, 0)
      end

      button:SetAlpha(1)
      button:Show()
    end
  end
end

-- BLIZZ FUNCTIONS --

local bars = {
  'Action',
  'BonusAction',
  'MultiBarLeft',
  'MultiBarRight',
  'MultiBarBottomLeft',
  'MultiBarBottomRight',
}

function _G.MultiActionBar_ShowAllGrids()
  for _, bar in pairs(bars) do
    MultiActionBar_UpdateGrid(bar, true)
  end
end

function _G.MultiActionBar_HideAllGrids()
  for _, bar in pairs(bars) do
    MultiActionBar_UpdateGrid(bar, false)

    for i = 1, NUM_ACTIONBAR_BUTTONS do
      local button = _G[bar..'Button'..i]
      local hasAction = HasAction(ActionButton_GetPagedID(button))

      if not hasAction and button.showgrid == 0 then
        button:Hide()
      end
    end
  end
end

function _G.ActionButton_ShowGrid(button)
  if not button then button = this end

  local name = button:GetName()

  button.showgrid = button.showgrid + 1
  button:Show()
end

function _G.ActionButton_HideGrid(button)
  if not button then button = this end

  local hasAction = HasAction(ActionButton_GetPagedID(button))

  button.showgrid = button.showgrid - 1

  if not hasAction and button.showgrid == 0 then
    button:Hide()
  end
end

local function onUpdateUsable()
  local name = this:GetName()
  local icon = _G[name..'Icon']
  local normal = _G[name..'NormalTexture']
  local id = ActionButton_GetPagedID(this)
  local isUsable, notEnoughMana = IsUsableAction(id)
  local hasRange = ActionHasRange(id)
	local inRange = IsActionInRange(id)

  if isUsable then
    if hasRange and inRange == 0 then
			icon:SetVertexColor(0.8, 0.1, 0.1)
			normal:SetVertexColor(0.8, 0.1, 0.1)
		else
			icon:SetVertexColor(1.0, 1.0, 1.0)
			normal:SetVertexColor(1.0, 1.0, 1.0)
		end
	elseif notEnoughMana then
    icon:SetVertexColor(0.5, 0.5, 1.0);
    normal:SetVertexColor(0.5, 0.5, 1.0);
	else
		icon:SetVertexColor(0.3, 0.3, 0.3)
		normal:SetVertexColor(0.3, 0.3, 0.3)
	end
end

local function onUpdate(elapsed)
  if not this.rangeTimer then return end

  if this.rangeTimer == TOOLTIP_UPDATE_TIME then
		onUpdateUsable(this)
	end
end

local function onActionButtonDown(id)
  ActionButtonUp(id)
end

local function onMultiActionButtonDown(bar, id)
  MultiActionButtonUp(bar, id)
end

hooksecurefunc('ActionButton_OnUpdate', onUpdate)
hooksecurefunc('ActionButton_Update', onUpdateUsable)
hooksecurefunc('ActionButton_Update', skin)
hooksecurefunc('ActionButton_UpdateUsable', onUpdateUsable)
hooksecurefunc("ActionButtonDown", onActionButtonDown)
hooksecurefunc("MultiActionButtonDown", onMultiActionButtonDown)

function f:PLAYER_ENTERING_WORLD()
  f:UnregisterEvent('PLAYER_ENTERING_WORLD')

  -- NOTE: this needs to come before we hide blizz frames
  MultiBarBottomLeft:SetParent(actionbars.bar2)
  MultiBarBottomRight:SetParent(actionbars.bar3)
  MultiBarLeft:SetParent(actionbars.bar4)
  MultiBarRight:SetParent(actionbars.bar5)
  BonusActionBarFrame:SetParent(actionbars.bonus)
  ShapeshiftBarFrame:SetParent(actionbars.shapeshift)
  PetActionBarFrame:SetParent(actionbars.pet)

  local hideFrames = {
    MainMenuBar,
    BonusActionBarTexture0,
    BonusActionBarTexture1,
    SlidingActionBarTexture0,
    SlidingActionBarTexture1,
  }

  for _, frame in pairs(hideFrames) do
    S.kill(frame)
  end

  for _, bar in pairs(bars) do
    for i = 1, NUM_ACTIONBAR_BUTTONS do
      local button = _G[bar .. 'Button' .. i]
      button:ClearAllPoints()
      button:SetAlpha(0)
      button:Hide()
    end
  end

  -- Bar 1
  setupBar(actionbars.bar1, 'ActionButton', 6)
  S.point(actionbars.bar1, 'BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -10, 0)

  -- TODO: figure out why this is necessary for shit to work
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    local button = _G['ActionButton'..i]
    button:SetParent(actionbars.bar1)
    button:Show()
  end

  -- Bar 2
  if SHOW_MULTI_ACTIONBAR_1 then
    setupBar(actionbars.bar2, 'MultiBarBottomLeftButton', 6)
    S.point(actionbars.bar2, 'BOTTOMLEFT', Minimap, 'BOTTOMRIGHT', 10, 0)
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetAllPoints(actionbars.bar2)
  end

  -- Bar 3
  if SHOW_MULTI_ACTIONBAR_2 then
    setupBar(actionbars.bar3, 'MultiBarBottomRightButton')
    S.point(actionbars.bar3, 'LEFT', UIParent, 'LEFT', 0, 0)
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetAllPoints(actionbars.bar3)
  end

  -- Bar 4
  if SHOW_MULTI_ACTIONBAR_3 then
    setupBar(actionbars.bar4, 'MultiBarLeftButton')
    S.point(actionbars.bar4, 'TOP', UIParent, 'TOP', 0, 0)
    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetAllPoints(actionbars.bar4)
  end

  -- Bar 5
  if SHOW_MULTI_ACTIONBAR_4 then
    setupBar(actionbars.bar5, 'MultiBarRightButton')
    S.point(actionbars.bar5, 'RIGHT', UIParent, 'RIGHT', 0, 0)
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetAllPoints(actionbars.bar5)
  end

  -- Bonus bar
  setupBar(actionbars.bonus, 'BonusActionButton', 6)
  actionbars.bonus:SetAllPoints(actionbars.bar1)
  actionbars.bonus:SetFrameLevel(actionbars.bar1:GetFrameLevel() + 1)

  -- Stance / shapeshift bar
  if ShapeshiftButton1:IsShown() then
    setupBar(actionbars.shapeshift, 'ShapeshiftButton', GetNumShapeshiftForms())
    S.point(actionbars.shapeshift, 'BOTTOM', Minimap, 'TOP', 0, 10)

    -- NOTE: this odd graphical thing only happens occasionally
    S.strip(ShapeshiftBarFrame)

    -- We have to skin manually since our hooksecurefunc is not called
    for i = 1, GetNumShapeshiftForms() do
      local button = _G['ShapeshiftButton' .. i]
      skin(button)
    end
  end

  -- Pet bar
  if (PetHasActionBar()) then
    setupBar(actionbars.pet, 'PetActionButton', NUM_PET_ACTION_SLOTS)
    S.point(actionbars.pet, 'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -10, 20)

    -- TODO: test if we need this
    -- S.strip(PetActionBarFrame)

    -- We have to skin manually since our hooksecurefunc is not called
    for i = 1,NUM_PET_ACTION_SLOTS do
      local button = _G['PetActionButton' .. i]
      skin(button, 'NormalTexture2') -- ... blizz pls
    end
  end
end

f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
