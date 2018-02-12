local S, C = SmellyUI:unpack()

local f = CreateFrame('Frame')

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  SetCVar('uiScale', 0.71)
  SetCVar("buffDurations", 1)
  SetCVar("countdownForCooldowns", 1)
  SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
  SetCVar("removeChatDelay", 1)
  SetCVar("alwaysShowActionBars", 1)
  SetCVar("nameplateShowSelf", 0)
  SetCVar('profanityFilter', '0')

  ConsoleExec('CameraDistanceMaxFactor 5')

  -- MultiActionBar_ShowAllGrids()
  -- ALWAYS_SHOW_MULTIBARS = '1'
  -- SHOW_BUFF_DURATIONS = '1'
  -- QUEST_FADING_DISABLE = '1'
  -- NAMEPLATES_ON = '1'
  -- SHOW_COMBAT_TEXT = '1'
  -- COMBAT_TEXT_SHOW_LOW_HEALTH_MANA = '1'
  -- COMBAT_TEXT_SHOW_AURAS = '1'
  -- COMBAT_TEXT_SHOW_AURA_FADE = '1'
  -- COMBAT_TEXT_SHOW_COMBAT_STATE = '1'
  -- COMBAT_TEXT_SHOW_DODGE_PARRY_MISS = '1'
  -- COMBAT_TEXT_SHOW_RESISTANCES = '1'
  -- COMBAT_TEXT_SHOW_REPUTATION = '1'
  -- COMBAT_TEXT_SHOW_REACTIVES = '1'
  -- COMBAT_TEXT_SHOW_FRIENDLY_NAMES = '1'
  -- COMBAT_TEXT_SHOW_COMBO_POINTS = '1'
  -- COMBAT_TEXT_SHOW_MANA = '1'
  -- COMBAT_TEXT_FLOAT_MODE = '1'
  -- COMBAT_TEXT_SHOW_HONOR_GAINED = '1'
  -- UIParentLoadAddOn('Blizzard_CombatText')

  UIParent:SetScale(C.graphics.scale)
  UIParent:SetWidth(C.graphics.width)
  UIParent:SetHeight(C.graphics.height)
  UIParent:SetPoint("CENTER",0,0)
end

function f:OnEvent()
  this[event](this, arg1)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', f.OnEvent)
