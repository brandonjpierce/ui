local S, C = SmellyUI:unpack()

local f = CreateFrame('Frame')

local chat = CreateFrame('Frame', 'SmellyUI_Chat', UIParent)
chat:SetFrameStrata('BACKGROUND')
S.size(chat, 500, 150)
S.point(chat, 'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 20)

local edit = CreateFrame('Frame', 'SmellyUI_ChatEdit', UIParent)
S.size(edit, 500, 24)
S.point(edit, 'BOTTOM', chat, 'TOP', 0, 24)

ChatTypeInfo["SYSTEM"] = { sticky = 0, flashTab = true, flashTabOnGeneral = true }
ChatTypeInfo["SAY"] = { sticky = 0, flashTab = false, flashTabOnGeneral = false }
ChatTypeInfo["PARTY"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["RAID"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["GUILD"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["OFFICER"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["WHISPER"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["WHISPER_INFORM"] = { sticky = 0, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["REPLY"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["RAID_LEADER"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["RAID_WARNING"] = { sticky = 0, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["INSTANCE_CHAT"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["INSTANCE_CHAT_LEADER"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }
ChatTypeInfo["PARTY_LEADER"] = { sticky = 1, flashTab = true, flashTabOnGeneral = false }

local shorthand = {
  guild = 'g',
  officer = 'o',
  raid = 'r',
  raidlead = 'R',
  raidwarning = 'RW',
  party = 'p',
  partylead = 'P',
  dungeonguide = 'D'
}

-- Flags
CHAT_FLAG_AFK = "<AFK>"
CHAT_FLAG_COM = "<COM>"
CHAT_FLAG_DND = "<DND>"
CHAT_FLAG_GM = "<GM>"

-- Yell/Say
CHAT_YELL_GET = "%s yells:\32"
CHAT_SAY_GET = "%s says:\32"

-- Whisper
CHAT_WHISPER_GET = "%s whispers:\32"
CHAT_WHISPER_INFORM_GET = "@ %s:\32"
CHAT_BN_WHISPER_GET = "%s whispers:\32"
CHAT_BN_WHISPER_INFORM_GET = "@ %s:\32"

-- Guild
CHAT_GUILD_GET = "|Hchannel:GUILD|h" .. shorthand.guild .. "|h %s:\32"
CHAT_OFFICER_GET = "|Hchannel:OFFICER|h" .. shorthand.officer .. "|h %s:\32"

-- Raid
CHAT_RAID_GET = "|Hchannel:RAID|h" .. shorthand.raid .. "|h %s:\32"
CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h" .. shorthand.raidlead .. "|h %s:\32"
CHAT_RAID_WARNING_GET = shorthand.raidwarning.. " %s:\32"

-- Party
CHAT_PARTY_GET = "|Hchannel:PARTY|h" .. shorthand.party .. "|h %s:\32"
CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h" .. shorthand.dungeonguide .. "|h %s:\32"
CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h" .. shorthand.partylead .. "|h %s:\32"

-- Send strings - those you see in the Editbox header
CHAT_PARTY_SEND = "Party:\32"
CHAT_RAID_SEND = "Raid:\32"
CHAT_GUILD_SEND = "Guild:\32"
CHAT_WHISPER_SEND = "@ %s:\32"
CHAT_YELL_SEND = "Yell:\32"
CHAT_SAY_SEND = "Say:\32"
CHAT_OFFICER_SEND = "O:\32"
CHAT_RAID_WARNING_SEND = "RW:\32"

local function onScroll()
  local delta = arg1

  if delta < 0 then
		if (IsShiftKeyDown()) then
			this:ScrollToBottom()
		else
			for i = 1, 3 do
				this:ScrollDown()
			end
		end
	elseif delta > 0 then
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
		if (chatType == 'CHANNEL') then
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
  local tab = _G[name..'Tab']
  local tabText = _G[name..'TabText']
  local editBox = _G[name..'EditBox']

	frame:SetFading(false)
  frame:EnableMouseWheel(true)
  frame:SetScript('OnMouseWheel', onScroll)

  hooksecurefunc(tab, "SetAlpha", function(t, alpha)
		if
      alpha ~= 1 and
      (not t.isDocked or SELECTED_CHAT_FRAME:GetID() == t:GetID())
    then
			UIFrameFadeRemoveFrame(t)
			t:SetAlpha(1)
		elseif alpha < 0.6 then
			UIFrameFadeRemoveFrame(t)
			t:SetAlpha(0.6)
		end
	end)

  S.strip(frame)
  S.strip(tab)
  S.kill(_G[name .. 'UpButton'])
  S.kill(_G[name .. 'UpButton'])
  S.kill(_G[name .. 'DownButton'])
  S.kill(_G[name .. 'DownButton'])
  S.kill(_G[name .. 'BottomButton'])
  S.kill(_G[name .. 'BottomButton'])

  for i = 1, table.getn(CHAT_FRAME_TEXTURES) do
		_G[name..CHAT_FRAME_TEXTURES[i]]:SetTexture(nil)
	end

  frame.skinned = true
end

local channelConfig = {
  [ChatFrame1] = {GENERAL},
  [ChatFrame4] = {'LocalDefense', 'GuildRecruitment', 'LookingForGroup', TRADE},
}

local messageGroupConfig = {
  [ChatFrame1] = {"SYSTEM", "SAY", "EMOTE", "YELL", "OFFICER", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "GUILD", "CREATURE", "ERRORS", "DND", "AFK", "IGNORED"},
  [ChatFrame3] = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "MONEY"},
}

local function setupChat(chatbox)
  ChatFrame_RemoveAllChannels(chatbox)
  ChatFrame_RemoveAllMessageGroups(chatbox)

  if channelConfig[chatbox] then
    for i, v in pairs(channelConfig[chatbox]) do
      ChatFrame_AddChannel(chatbox, v)
    end
  end

  if messageGroupConfig[chatbox] then
    for i, v in pairs(messageGroupConfig[chatbox]) do
      ChatFrame_AddMessageGroup(chatbox, v)
    end
  end
end

local function refresh()
  for i=1, NUM_CHAT_WINDOWS do
    local frame = _G['ChatFrame'..i]
    local tab = _G['ChatFrame'..i..'Tab']

    skin(frame)

    frame:SetParent(chat)
    S.inside(frame, chat)

    if (frame:IsVisible()) then
      tab:Show()
    end
  end

  FCF_DockUpdate()
end

local function resetChatWindows()
  for i=2, NUM_CHAT_WINDOWS do
    local chatFrameName = 'ChatFrame'..i
		local chatFrame = _G[chatFrameName];

		FCF_SetTabPosition(chatFrame, 0);
		FCF_Close(chatFrame);
		FCF_UnDockFrame(chatFrame);
		FCF_SetWindowName(chatFrame, "");
		ChatFrame_RemoveAllMessageGroups(chatFrame);
		ChatFrame_RemoveAllChannels(chatFrame);
	end
end

local function install()
  resetChatWindows()

  -- FCF_DockFrame(ChatFrame1)
  FCF_SetLocked(ChatFrame1, 1)
  FCF_SetWindowName(ChatFrame1, "G")
  setupChat(ChatFrame1)

  FCF_DockFrame(ChatFrame3)
  FCF_SetWindowName(ChatFrame3, "L")
  setupChat(ChatFrame3)

  FCF_DockFrame(ChatFrame4)
  FCF_SetWindowName(ChatFrame4, "S")
  setupChat(ChatFrame4)
end

function f:PLAYER_LOGIN()
  f:UnregisterEvent('PLAYER_LOGIN')

  install()
  refresh()
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

  hooksecurefunc('FCF_SaveDock', refresh)
  hooksecurefunc('ChatEdit_UpdateHeader', updateEditBoxColor)

  -- if not SmellyUI_PlayerDB.chat then
  --   install()
  --
  --   SmellyUI_PlayerDB.chat = true
  -- end
end

function f:OnEvent() this[event](this, arg1) end

f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', f.OnEvent)
