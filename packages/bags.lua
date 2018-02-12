local S, C = SmellyUI:unpack()

local f = CreateFrame('Frame')

local itemsPerRow = 8
local buttonSize = 32
local buttonSpacing = 3
local bagPadding = 10

-- Bag / Bank IDs
local BACKPACK = { -2, 0, 1, 2, 3, 4 }
local BANK = { -1, 5, 6, 7, 8, 9, 10, 11 }

-- Blizzard bag buttons
local BLIZZARD_BAGS = {
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
}


local storages = CreateFrame('Frame')

local function getBagFamily(bag)
  if bag == -2 then return "KEYRING" end
  if bag == 0 then return "BAG" end

  local itemLink = GetInventoryItemLink("player", ContainerIDToInventoryID(bag))
  local _, _, id = strfind(itemLink or "", "item:(%d+)")

  if id then
    local _, _, _, _, itemType, subType = GetItemInfo(id)

    if subType == "Bag" then return "BAG" end
    if subType == "Soul Bag" then return "SOULBAG" end
    if subType == "Quiver" then return "QUIVER" end
    if subType == nil then return "SPECIAL" end
  end

  return nil
end

local function skinButton(button)
  if not button then button = this return end
  if button.skinned then return end

  local name = button:GetName()
  local icon = _G[name..'IconTexture']
  local junk = _G[name..'JunkIcon']
  local border = _G[name..'IconBorder']
  local normal = _G[name .. 'NormalTexture']
  local count = _G[name..'Count']

  S.backdrop(button)
  button.bg:SetAllPoints()

  if normal then
    button:SetNormalTexture('')
    button.SetNormalTexture = S.noop
    normal:SetTexture(nil)
    normal:SetAlpha(0)
    normal:Hide()
  end

  if border then
	   S.kill(border)
  end

  if junk then
    S.kill(junk)
  end

  if count then
    count:ClearAllPoints()
    S.point(count, 'BOTTOMRIGHT', button, 'BOTTOMRIGHT', -3, 3)
  end

  if icon then
    icon:SetTexCoord(.08, .92, .08, .92)
    icon:ClearAllPoints()
    S.inside(icon)
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

local function updateSlot(bag, item)
  -- print('calling updateSlot(' .. bag .. ',' .. item:GetID() ..')')
  if not item then return end

  local id = item:GetID()
  local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, id)

  if item.bg then
    if quality and quality > 1 then
      item.bg:SetBackdropBorderColor(GetItemQualityColor(quality), 0.8)
    elseif quality then
      if quality == 1 then
        item.bg:SetBackdropBorderColor(1, 1, 1, .8)
      else
        item.bg:SetBackdropBorderColor(.5, .5, .5, 1)
      end
    else
      local bagtype = getBagFamily(bag)

      if bagtype == "QUIVER" then
        item.bg:SetBackdropBorderColor(1,1,.5,.8)
      elseif bagtype == "SOULBAG" then
        item.bg:SetBackdropBorderColor(1,.5,.5,.8)
      elseif bagtype == "SPECIAL" then
        item.bg:SetBackdropBorderColor(.5,.5,1,.8)
      elseif bagtype == "KEYRING" then
        item.bg:SetBackdropBorderColor(.5,1,1,.8)
      elseif bagtype == "BAG" then
        item.bg:SetBackdropBorderColor(0.15,0.15,0.15,1)
      end
    end
  end

  if texture then
    item.hasItem = 1
  else
    item.hasItem = nil
  end

  ContainerFrame_UpdateCooldown(bag, item)

  item.readable = readable
  SetItemButtonTexture(item, texture)
  SetItemButtonCount(item, itemCount)
  SetItemButtonDesaturated(item, locked, 0.5, 0.5, 0.5)

  item:Show()
end

local function updateBag(id)
  print('calling updateBag(' .. id .. ')')
  local size = GetContainerNumSlots(id)

	for slot = 1, size do
		local button = _G["ContainerFrame"..(id + 1).."Item"..slot]

		if button then
      if not button:IsShown() then
				button:Show()
			end

      updateSlot(id, button)
    end
  end
end

local function updateAllBags()
  print('calling updateAllBags')
  local firstButton
  local lastButton = ContainerFrame1Item1
  local lastRowButton = ContainerFrame1Item1
  local numRows = 0
  local numButtons = 1

  for bag = 5, 1, -1 do
		local id = bag - 1
		local slots = GetContainerNumSlots(id)

		for item = slots, 1, -1 do
			local button = _G["ContainerFrame"..bag.."Item"..item]
      if not firstButton then firstButton = button end

      button:ClearAllPoints()
      button:SetFrameStrata("HIGH")
      button:SetFrameLevel(2)

      S.size(button, buttonSize)
      skinButton(button)

      if button == firstButton then
				button:SetPoint('TOPLEFT', storages.Bag, 'TOPLEFT', bagPadding, -bagPadding)
				lastRowButton = button
				lastButton = button
			elseif numButtons == itemsPerRow then
				button:SetPoint("TOPRIGHT", lastRowButton, "TOPRIGHT", 0, -(buttonSpacing + buttonSize))
				button:SetPoint("BOTTOMLEFT", lastRowButton, "BOTTOMLEFT", 0, -(buttonSpacing + buttonSize))
				lastRowButton = button
				numRows = numRows + 1
				numButtons = 1
			else
				button:SetPoint("TOPRIGHT", lastButton, "TOPRIGHT", (buttonSpacing + buttonSize), 0)
				button:SetPoint("BOTTOMLEFT", lastButton, "BOTTOMLEFT", (buttonSpacing + buttonSize), 0)
				numButtons = numButtons + 1
			end

      lastButton = button
    end

    updateBag(id)
  end

  storages.Bag:SetHeight(((buttonSize + buttonSpacing) * (numRows + 1) + (bagPadding * 2)) - buttonSpacing)
end

local function openBag(id)
  print('calling openBag(' .. id .. ')')
  local size = GetContainerNumSlots(id)
	local openFrame = ContainerFrame_GetOpenFrame()
  local openFrameName = openFrame:GetName()

  for i = 1, size, 1 do
    local index = size - i + 1
    local button = _G[openFrameName .. 'Item' .. i]

    button:SetID(index)
    button:Show()
  end

  openFrame.size = size
  openFrame:SetID(id)
  openFrame:Show()

	if (id == 4) then
		updateAllBags()
	elseif (id == 11) then
		-- Bags:UpdateAllBankBags()
	end
end

local function closeBag(id)
  print('calling closeBag(' .. id .. ')')
  CloseBag(id)
end

local function openAllBags()
  print('calling openAllBags')
  openBag(0, 1)

	for i = 1, 4 do
		openBag(i, 1)
	end

  if IsBagOpen(0) then
    PlaySound("igBackPackOpen");
		storages.Bag:Show()
  end
end

local function closeAllBags()
  print('calling closeAllBags')
  CloseAllBags()
  PlaySound("igBackPackClose")
end

local function toggleBags()
  print('calling toggleBags')
  if storages.Bag:IsShown() or storages.Bank:IsShown() then
		if MerchantFrame:IsVisible() or InboxFrame:IsVisible() then
			return
		end

    closeAllBags()

		return
	end

	if not storages.Bag:IsShown() then
    openAllBags()
	end
end

local function createContainer(type)
  local container = CreateFrame('Frame', 'SmellyUI_' .. type, UIParent)
  container:SetFrameStrata("MEDIUM")
	container:SetFrameLevel(50)
  container:EnableMouse(true)
  container:Hide()

  S.backdrop(container)
  S.width(container, ((buttonSize + buttonSpacing) * itemsPerRow + (bagPadding * 2)) - buttonSpacing)

  if type == 'Bag' then
    container.b = CreateFrame('Frame', nil, container)
    container.b:SetParent(container)
    S.point(container.b, 'TOPRIGHT', container, 'TOPLEFT', -10, 0)
    S.backdrop(container.b)

    local lastBagButton

    for i, bbag in pairs(BLIZZARD_BAGS) do
      bbag:SetParent(container.b)
      bbag:ClearAllPoints()
      bbag:SetFrameStrata("HIGH")
      bbag:SetFrameLevel(2)

      S.size(bbag, buttonSize)
      skinButton(bbag)

      if lastBagButton then
				bbag:SetPoint("TOP", lastBagButton, "BOTTOM", 0, -buttonSpacing)
			else
				bbag:SetPoint("TOP", container.b, "TOP", 0, -buttonSpacing)
			end

      lastBagButton = bbag
      container.b:SetHeight((buttonSize * getn(BLIZZARD_BAGS)) + (buttonSpacing * (getn(BLIZZARD_BAGS) + 1)))
			container.b:SetWidth(buttonSize + (buttonSpacing * 2))

      local bagId = i

      -- Highlight slots that bag button corresponds to
      bbag:SetScript('OnEnter', function()
        local bagsize = GetContainerNumSlots(bagId)

        for slot = 1, bagsize do
          local button = _G["ContainerFrame".. bagId + 1 .."Item" .. slot]

          if button.bg then
            button.bg:SetBackdropBorderColor(.2,1,.8,1)
          end
        end
      end)

      bbag:SetScript('OnLeave', function() updateBag(bagId) end)
    end

    for _, bag in pairs(BACKPACK) do
      local bagsize = GetContainerNumSlots(bag)

      for slot = 1, bagsize do
        local button = _G["ContainerFrame"..(bag + 1).."Item"..slot]

        if button then
          updateSlot(bag, button)
        end
      end
    end
  end

  storages[type] = container
  return container
end

f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function()
  if not C.modules.bags then return end

  if event == 'ADDON_LOADED' then
    if arg1 ~= 'SmellyUI' then return end
    f:UnregisterEvent('ADDON_LOADED')

    createContainer('Bag')
    createContainer('Bank')
    tinsert(UISpecialFrames, "SmellyUI_Bag")

    storages.Bag:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -30, 30)
    storages.Bank:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 30, 30)

    local Bag = ContainerFrame1

    Bag:SetScript('OnHide', function() storages.Bag:Hide() end)
    Bag:SetScript('onShow', function() storages.Bag:Show() end)

    -- Rewrite Blizzard Bags Functions
    function _G.UpdateContainerFrameAnchors() end
    function _G.ToggleBag() ToggleAllBags() end
    function _G.ToggleBackpack() ToggleAllBags() end
    function _G.OpenAllBags() ToggleAllBags() end
    function _G.OpenBackpack() ToggleAllBags() end
    function _G.ToggleAllBags() toggleBags() end
  end

  if event == 'PLAYER_ENTERING_WORLD' then
    storages:RegisterEvent('BAG_UPDATE')
    storages:RegisterEvent('BAG_CLOSED')
    storages:RegisterEvent('PLAYERBANKSLOTS_CHANGED')
    storages:RegisterEvent('PLAYERBANKBAGSLOTS_CHANGED')
    storages:RegisterEvent('BAG_UPDATE_COOLDOWN')
    storages:SetScript('OnEvent', function()
      if event == 'BAG_UPDATE' then
        updateBag(arg1)
      end

      if event == 'BAG_CLOSED' then
        local Bag = arg1 + 1

    		-- We need to hide buttons from a bag when closing it because they are not parented to the original frame
    		local Container = _G["ContainerFrame"..Bag]
    		local Size = Container.size

    		for i = 1, Size do
    			local Button = _G["ContainerFrame"..Bag.."Item"..i]

    			if Button then
    				Button:Hide()
    			end
    		end

        closeAllBags()
      end

      if event == 'PLAYERBANKSLOTS_CHANGED' then
        p('PLAYERBANKSLOTS_CHANGED')
        print(arg1)
      end

      if event == 'PLAYERBANKBAGSLOTS_CHANGED' then
        p('PLAYERBANKBAGSLOTS_CHANGED')
        print(arg1)
      end
    end)
  end
end)
