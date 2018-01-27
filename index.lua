-- Temp
ScriptErrors:SetScript('OnShow', function(msg)
  DEFAULT_CHAT_FRAME:AddMessage('|cffcc3333ERROR: |cffff5555'..ScriptErrors_Message:GetText())
  ScriptErrors:Hide()
end)

SLASH_RELOADUI1 = '/rl'
SlashCmdList.RELOADUI = ReloadUI

SmellyUI = CreateFrame('Frame', 'SmellyUI', UIParent)
SmellyUI.engine = {}
SmellyUI.engine.C = {} -- Config
SmellyUI.engine.S = {} -- API functions

setmetatable(SmellyUI.engine, {__index = getfenv(0)})

SmellyUI:RegisterEvent('ADDON_LOADED')
SmellyUI:SetScript('OnEvent', function()
  if arg1 == 'SmellyUI' then
    SetCVar('uiScale', 0.71)
    -- SetCVar('autoSelfCast', '1')
    SetCVar('profanityFilter', '0')
    ConsoleExec('CameraDistanceMaxFactor 5')
    MultiActionBar_ShowAllGrids()
    ALWAYS_SHOW_MULTIBARS = '1'
    SHOW_BUFF_DURATIONS = '1'
    QUEST_FADING_DISABLE = '1'
    NAMEPLATES_ON = '1'
    SHOW_COMBAT_TEXT = '1'
    COMBAT_TEXT_SHOW_LOW_HEALTH_MANA = '1'
    COMBAT_TEXT_SHOW_AURAS = '1'
    COMBAT_TEXT_SHOW_AURA_FADE = '1'
    COMBAT_TEXT_SHOW_COMBAT_STATE = '1'
    COMBAT_TEXT_SHOW_DODGE_PARRY_MISS = '1'
    COMBAT_TEXT_SHOW_RESISTANCES = '1'
    COMBAT_TEXT_SHOW_REPUTATION = '1'
    COMBAT_TEXT_SHOW_REACTIVES = '1'
    COMBAT_TEXT_SHOW_FRIENDLY_NAMES = '1'
    COMBAT_TEXT_SHOW_COMBO_POINTS = '1'
    COMBAT_TEXT_SHOW_MANA = '1'
    COMBAT_TEXT_FLOAT_MODE = '1'
    COMBAT_TEXT_SHOW_HONOR_GAINED = '1'
    UIParentLoadAddOn('Blizzard_CombatText')

    local resolution = GetCVar("gxResolution")

    for screenwidth, screenheight in string.gfind(resolution, "(.+)x(.+)") do
      local screenheight = tonumber(screenheight) / 8
      local scale = 768 / screenheight

      UIParent:SetScale(scale)
      UIParent:SetWidth(screenwidth)
      UIParent:SetHeight(screenheight)
      UIParent:SetPoint("CENTER",0,0)
    end
  end
end)
