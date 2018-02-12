local S, C = SmellyUI:unpack()

local f = CreateFrame('Frame')

local chat = CreateFrame('Frame', 'SmellyUI_Chat', UIParent)
chat:SetFrameStrata('BACKGROUND')
S.size(chat, 500, 200)
S.point(chat, 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 20)

local edit = CreateFrame('Frame', 'SmellyUI_ChatEdit', UIParent)
S.size(edit, 500, 24)
S.point(edit, 'BOTTOMLEFT', chat, 'BOTTOMLEFT', 0, 0)

local function onScroll()
  local delta = arg1

  if (delta < 0) then
		if (IsShiftKeyDown()) then
			this:ScrollToBottom()
		else
			for i = 1, 3 do
				this:ScrollDown()
			end
		end
	elseif (delta > 0) then
		if (IsShiftKeyDown()) then
			this:ScrollToTop()
		else
			for i = 1, 3 do
				this:ScrollUp()
			end
		end
	end
end

local function updateEditBoxColor()
  local editBox = this
  if not editBox then return end

	local chatType = editBox.chatType
	local backdrop = editBox.bg

	if backdrop then
		if (chatType == "CHANNEL") then
			local id = GetChannelName(editBox.channelTarget)

			if (id == 0) then
				backdrop.anim:SetChange(0,0,0,1)
			else
				backdrop.anim:SetChange(ChatTypeInfo[chatType..id].r, ChatTypeInfo[chatType..id].g, ChatTypeInfo[chatType..id].b)
			end
		else
			backdrop.anim:SetChange(ChatTypeInfo[chatType].r, ChatTypeInfo[chatType].g, ChatTypeInfo[chatType].b)
		end

		backdrop.anim:Play()
	end
end

local function skin(frame)
  if frame.skinned then return end

  local id = frame:GetID()
  local name = frame:GetName()
  local tab = _G[name.."Tab"]
  local tabText = _G[name.."TabText"]
  local editBox = _G[name.."EditBox"]

	frame:SetFading(false)
  frame:EnableMouseWheel(true)
  frame:SetScript("OnMouseWheel", onScroll)

  S.strip(frame)
  S.strip(tab)
  S.kill(_G[name .. "UpButton"])
  S.kill(_G[name .. "UpButton"])
  S.kill(_G[name .. "DownButton"])
  S.kill(_G[name .. "DownButton"])
  S.kill(_G[name .. "BottomButton"])
  S.kill(_G[name .. "BottomButton"])

  for i = 1, table.getn(CHAT_FRAME_TEXTURES) do
		_G[name..CHAT_FRAME_TEXTURES[i]]:SetTexture(nil)
	end

  frame.skinned = true
end

local function refresh()
  ChatTypeInfo.WHISPER.sticky = 1
  ChatTypeInfo.OFFICER.sticky = 1
  ChatTypeInfo.RAID_WARNING.sticky = 1
  ChatTypeInfo.CHANNEL.sticky = 1

  for i=1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame"..i]
    local tab = _G["ChatFrame"..i.."Tab"]

    skin(frame)

    if i == 1 then
      FCF_DockFrame(frame)
      frame:SetParent(chat)
      S.inside(frame, chat)
    else
      FCF_UnDockFrame(frame)
      frame:SetParent(UIParent)
      tab:SetParent(UIParent)
    end

    if (frame:IsVisible()) then
      tab:Show()
    end
  end
end

local function install()
  for i=1, NUM_CHAT_WINDOWS do
    FCF_Close(_G["ChatFrame"..i])
    FCF_DockUpdate()
  end

	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_OpenNewWindow(GENERAL)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)
  FCF_OpenNewWindow(LOOT)
	FCF_DockFrame(ChatFrame4)

  ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, TRADE)
	ChatFrame_RemoveChannel(ChatFrame1, GENERAL)
  ChatFrame_RemoveChannel(ChatFrame1, 'LocalDefense')
  ChatFrame_RemoveChannel(ChatFrame1, 'GuildRecruitment')
  ChatFrame_RemoveChannel(ChatFrame1, 'LookingForGroup')
  ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")

  ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddChannel(ChatFrame3, TRADE)
	ChatFrame_AddChannel(ChatFrame3, GENERAL)
  ChatFrame_AddChannel(ChatFrame1, 'LocalDefense')
  ChatFrame_AddChannel(ChatFrame1, 'GuildRecruitment')
  ChatFrame_AddChannel(ChatFrame1, 'LookingForGroup')

  ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")

  DEFAULT_CHAT_FRAME:SetUserPlaced(true)

  for i = 1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame"..i]
		local id = frame:GetID()

    S.size(frame, chat:GetWidth(), chat:GetHeight())

    if (id == 1) then
      FCF_SetWindowName(frame, "G, S & W")
    end

    if (id == 2) then
      FCF_SetWindowName(frame, "Log")
    end

    FCF_SetLocked(frame, 1)
  end

  refresh()
end

function f:PLAYER_ENTERING_WORLD()
  refresh()
  FCF_DockUpdate()
end

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  ChatFrameEditBox:SetParent(edit)
  ChatFrameEditBox:ClearAllPoints()
  ChatFrameEditBox:SetAltArrowKeyMode(false)
  S.inside(ChatFrameEditBox, edit)

  S.backdrop(ChatFrameEditBox)
  ChatFrameEditBox.bg:SetFrameStrata('LOW')
  ChatFrameEditBox.bg:SetFrameLevel(1)
  ChatFrameEditBox.bg.anim = CreateAnimationGroup(ChatFrameEditBox.bg):CreateAnimation('color')
  ChatFrameEditBox.bg.anim:SetDuration(0.5)
  ChatFrameEditBox.bg.anim:SetSmoothing('inout')
  ChatFrameEditBox.bg.anim:SetColorType('border')

  local a, b, c = select(6, ChatFrameEditBox:GetRegions())
  S.kill(a)
  S.kill(b)
  S.kill(c)

  S.kill(ChatFrameMenuButton)

  local default = " " .. "%s" .. "|r:" .. "\32"
  _G.CHAT_CHANNEL_GET = "%s" .. "|r:" .. "\32"
  _G.CHAT_GUILD_GET = '[G]' .. default
  _G.CHAT_OFFICER_GET = '[O]'.. default
  _G.CHAT_PARTY_GET = '[P]' .. default
  _G.CHAT_RAID_GET = '[R]' .. default
  _G.CHAT_RAID_LEADER_GET = '[RL]' .. default
  _G.CHAT_RAID_WARNING_GET = '[RW]' .. default
  _G.CHAT_BATTLEGROUND_GET = '[BG]' .. default
  _G.CHAT_BATTLEGROUND_LEADER_GET = '[BL]' .. default
  _G.CHAT_SAY_GET = '[S]' .. default
  _G.CHAT_YELL_GET = '[Y]' .. default

  for i=1,NUM_CHAT_WINDOWS do
    if not _G["ChatFrame"..i].HookAddMessage then
      _G["ChatFrame"..i].HookAddMessage = _G["ChatFrame"..i].AddMessage
    end

    _G["ChatFrame"..i].AddMessage = function (frame, text, ...)
      if text then
        _G["ChatFrame"..i].HookAddMessage(frame, text, unpack(arg))
      end
    end
  end

  chat:SetScript('OnShow', refresh)

  hooksecurefunc("FCF_SaveDock", refresh)
  hooksecurefunc("ChatEdit_UpdateHeader", updateEditBoxColor)

  install()

  -- if not SmellyUI_PlayerDB.chat then
  --   install()
  --
  --   SmellyUI_PlayerDB.chat = true
  -- end
end

function f:OnEvent() this[event](this, arg1) end

f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', f.OnEvent)
