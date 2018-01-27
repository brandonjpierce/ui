setfenv(1, SmellyUI.engine)

local f = CreateFrame('Frame')

local shadows = CreateFrame('Frame')
shadows:SetFrameStrata('BACKGROUND')
shadows:SetScale(C.graphics.scale)
S.size(shadows, 1024, 256)
S.point(shadows, 'BOTTOM', 0, 11)

shadows.left = CreateFrame('Frame', 'ShadowLeft', shadows)
shadows.left.t = shadows.left:CreateTexture('ShadowLeftT', 'BACKGROUND')
shadows.left.t:SetTexture(C.textures.shadows.left)
S.size(shadows.left.t, 512, 256)
S.point(shadows.left.t, 'LEFT', shadows, 'LEFT', 0, 0)

shadows.leftCombat = CreateFrame('Frame', 'ShadowLeftCombat', shadows)
shadows.leftCombat.t = shadows.leftCombat:CreateTexture('ShadowLeftCombatT', 'BACKGROUND')
shadows.leftCombat.t:SetTexture(C.textures.shadows.leftCombat)
S.size(shadows.leftCombat.t, 512, 256)
S.point(shadows.leftCombat.t, 'LEFT', shadows, 'LEFT', 0, 0)

shadows.right = CreateFrame('Frame', 'ShadowRight', shadows)
shadows.right.t = shadows.right:CreateTexture('ShadowRightT', 'BACKGROUND')
shadows.right.t:SetTexture(C.textures.shadows.right)
S.size(shadows.right.t, 512, 256)
S.point(shadows.right.t, 'RIGHT', shadows, 'RIGHT', 0, 0)

shadows.rightCombat = CreateFrame('Frame', 'ShadowRightCombat', shadows)
shadows.rightCombat.t = shadows.rightCombat:CreateTexture('ShadowRightCombatT', 'BACKGROUND')
shadows.rightCombat.t:SetTexture(C.textures.shadows.rightCombat)
S.size(shadows.rightCombat.t, 512, 256)
S.point(shadows.rightCombat.t, 'RIGHT', shadows, 'RIGHT', 0, 0)

shadows.leftDead = CreateFrame('Frame', 'ShadowLeftDead', shadows)
shadows.leftDead.t = shadows.leftDead:CreateTexture('ShadowLeftDeadT', 'BACKGROUND')
shadows.leftDead.t:SetTexture(C.textures.shadows.leftDead)
S.size(shadows.leftDead.t, 512, 256)
S.point(shadows.leftDead.t, 'LEFT', shadows, 'LEFT', 0, 0)

shadows.rightDead = CreateFrame('Frame', 'ShadowRightDead', shadows)
shadows.rightDead.t = shadows.rightDead:CreateTexture('ShadowRightDeadT', 'BACKGROUND')
shadows.rightDead.t:SetTexture(C.textures.shadows.rightDead)
S.size(shadows.rightDead.t, 512, 256)
S.point(shadows.rightDead.t, 'RIGHT', shadows, 'RIGHT', 0, 0)

shadows.leftWater = CreateFrame('Frame', 'ShadowLeftWater', shadows)
shadows.leftWater.t = shadows.leftWater:CreateTexture('ShadowLeftWaterT', 'BACKGROUND')
shadows.leftWater.t:SetTexture(C.textures.shadows.leftWater)
shadows.leftWater:SetFrameLevel(shadows.left:GetFrameLevel() + 1)
S.size(shadows.leftWater.t, 512, 256)
S.point(shadows.leftWater.t, 'LEFT', shadows, 'LEFT', 0, 0)

shadows.rightWater = CreateFrame('Frame', 'ShadowRightWater', shadows)
shadows.rightWater.t = shadows.rightWater:CreateTexture('ShadowRightWaterT', 'BACKGROUND')
shadows.rightWater.t:SetTexture(C.textures.shadows.rightWater)
shadows.rightWater:SetFrameLevel(shadows.right:GetFrameLevel() + 1)
S.size(shadows.rightWater.t, 512, 256)
S.point(shadows.rightWater.t, 'RIGHT', shadows, 'RIGHT', 0, 0)

shadows.left:Hide()
shadows.leftCombat:Hide()
shadows.leftWater:Hide()
shadows.leftDead:Hide()
shadows.right:Hide()
shadows.rightCombat:Hide()
shadows.rightWater:Hide()
shadows.rightDead:Hide()

S.Anim:RegisterFrames(
  'ShadowLeft',
  'ShadowLeftCombat',
  'ShadowRight',
  'ShadowRightCombat',
  'ShadowLeftWater',
  'ShadowRightWater',
  'ShadowLeftDead',
  'ShadowRightDead'
)

f:RegisterEvent("PLAYER_ALIVE")
f:RegisterEvent("PLAYER_UNGHOST")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent("UNIT_HEALTH");
f:RegisterEvent("UNIT_MAX_HEALTH");
f:SetScript('OnEvent', function()
  local inCombat = UnitAffectingCombat('player')
  local isDead = UnitIsDeadOrGhost('player')

  if event == 'PLAYER_ENTERING_WORLD' then
    if isDead then
      shadows.leftDead:Show()
      shadows.rightDead:Show()
    else
      shadows.left:Show()
      shadows.right:Show()
    end
  end

  if event == 'PLAYER_REGEN_DISABLED' then
    if inCombat then
      shadows.left:Hide()
      shadows.leftCombat:Show()

      shadows.right:Hide()
      shadows.rightCombat:Show()
    end
  end

  if event == 'PLAYER_REGEN_ENABLED' then
    if not inCombat then
      shadows.left:Show()
      shadows.leftCombat:Hide()

      shadows.right:Show()
      shadows.rightCombat:Hide()
    end
  end

  if event == 'PLAYER_ALIVE' then
    if isDead then
      shadows.left:Hide()
      shadows.leftDead:Show()

      shadows.right:Hide()
      shadows.rightDead:Show()
    end
  end

  if event == 'PLAYER_UNGHOST' then
    shadows.left:Show()
    shadows.leftDead:Hide()

    shadows.right:Show()
    shadows.rightDead:Hide()
  end

  if event == 'UNIT_HEALTH' or event == 'UNIT_MAX_HEALTH' then
    local unitHealthPrecentage = UnitHealth('player') / UnitHealthMax('player')

    if unitHealthPrecentage < 0.5 and not isDead then
      shadows.left.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadows.right.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)

      shadows.leftCombat.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadows.rightCombat.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)

      shadows.leftWater.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadows.rightWater.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
    else
      shadows.left.t:SetVertexColor(1, 1, 1);
      shadows.right.t:SetVertexColor(1, 1, 1);

      shadows.leftCombat.t:SetVertexColor(1, 1, 1);
      shadows.rightCombat.t:SetVertexColor(1, 1, 1);

      shadows.leftWater.t:SetVertexColor(1, 1, 1);
      shadows.rightWater.t:SetVertexColor(1, 1, 1);
    end
  end
end)

local appliedWaterHud = false

hooksecurefunc("MirrorTimerFrame_OnUpdate", function(frame)
  if frame.paused then return end
  if not frame.value then return end
  if not frame.scale then return end

  if frame.timer == 'BREATH' and not appliedWaterHud then
    shadows.leftWater:Show()
    shadows.rightWater:Show()
    appliedWaterHud = true
  end
end)

hooksecurefunc('MirrorTimerFrame_OnEvent', function()
  if event == 'MIRROR_TIMER_STOP' and appliedWaterHud then
    shadows.leftWater:Hide()
    shadows.rightWater:Hide()
    appliedWaterHud = false
  end
end)
