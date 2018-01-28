setfenv(1, SmellyUI.engine)

local f = CreateFrame('Frame')

local shadows = CreateFrame('Frame')
shadows:SetFrameStrata('BACKGROUND')
shadows:SetScale(C.graphics.scale)
S.size(shadows, 1024, 256)
S.point(shadows, 'BOTTOM', 0, 11)

local shadowsAnim = CreateAnimationGroup(shadows)

local shadowsFadeIn = shadowsAnim:CreateAnimation('fade')
shadowsFadeIn:SetDuration(1)
shadowsFadeIn:SetChange(1)

local shadowsFadeOut = shadowsAnim:CreateAnimation('fade')
shadowsFadeOut:SetDuration(1)
shadowsFadeOut:SetChange(0)

shadows.left = CreateFrame('Frame', 'ShadowLeft', shadows)
shadows.left.t = shadows.left:CreateTexture('ShadowLeftT', 'BACKGROUND')
shadows.left.t:SetTexture(C.textures.shadows.left)
S.size(shadows.left.t, 512, 256)
S.point(shadows.left.t, 'LEFT', shadows, 'LEFT', 0, 0)

shadows.right = CreateFrame('Frame', 'ShadowRight', shadows)
shadows.right.t = shadows.right:CreateTexture('ShadowRightT', 'BACKGROUND')
shadows.right.t:SetTexture(C.textures.shadows.right)
S.size(shadows.right.t, 512, 256)
S.point(shadows.right.t, 'RIGHT', shadows, 'RIGHT', 0, 0)

local shadowsCombat = CreateFrame('Frame')
shadowsCombat:SetFrameStrata('BACKGROUND')
shadowsCombat:SetScale(C.graphics.scale)
S.size(shadowsCombat, 1024, 256)
S.point(shadowsCombat, 'BOTTOM', 0, 11)

local shadowsCombatAnim = CreateAnimationGroup(shadowsCombat)

local shadowsCombatFadeIn = shadowsCombatAnim:CreateAnimation('fade')
shadowsCombatFadeIn:SetDuration(1)
shadowsCombatFadeIn:SetChange(1)

local shadowsCombatFadeOut = shadowsCombatAnim:CreateAnimation('fade')
shadowsCombatFadeOut:SetDuration(1)
shadowsCombatFadeOut:SetChange(0)

shadowsCombat.left = CreateFrame('Frame', 'ShadowLeftCombat', shadowsCombat)
shadowsCombat.left.t = shadowsCombat.left:CreateTexture('ShadowLeftCombatT', 'BACKGROUND')
shadowsCombat.left.t:SetTexture(C.textures.shadows.leftCombat)
S.size(shadowsCombat.left.t, 512, 256)
S.point(shadowsCombat.left.t, 'LEFT', shadowsCombat, 'LEFT', 0, 0)

shadowsCombat.right = CreateFrame('Frame', 'ShadowRightCombat', shadowsCombat)
shadowsCombat.right.t = shadowsCombat.right:CreateTexture('ShadowRightCombatT', 'BACKGROUND')
shadowsCombat.right.t:SetTexture(C.textures.shadows.rightCombat)
S.size(shadowsCombat.right.t, 512, 256)
S.point(shadowsCombat.right.t, 'RIGHT', shadowsCombat, 'RIGHT', 0, 0)

local shadowsDead = CreateFrame('Frame')
shadowsDead:SetFrameStrata('BACKGROUND')
shadowsDead:SetScale(C.graphics.scale)
S.size(shadowsDead, 1024, 256)
S.point(shadowsDead, 'BOTTOM', 0, 11)

local shadowsDeadAnim = CreateAnimationGroup(shadowsDead)

local shadowsDeadFadeIn = shadowsDeadAnim:CreateAnimation('fade')
shadowsDeadFadeIn:SetDuration(1)
shadowsDeadFadeIn:SetChange(1)

local shadowsDeadFadeOut = shadowsDeadAnim:CreateAnimation('fade')
shadowsDeadFadeOut:SetDuration(1)
shadowsDeadFadeOut:SetChange(0)

shadowsDead.left = CreateFrame('Frame', 'ShadowLeftDead', shadowsDead)
shadowsDead.left.t = shadowsDead.left:CreateTexture('ShadowLeftDeadT', 'BACKGROUND')
shadowsDead.left.t:SetTexture(C.textures.shadows.leftDead)
S.size(shadowsDead.left.t, 512, 256)
S.point(shadowsDead.left.t, 'LEFT', shadowsDead, 'LEFT', 0, 0)

shadowsDead.right = CreateFrame('Frame', 'ShadowRightDead', shadowsDead)
shadowsDead.right.t = shadowsDead.right:CreateTexture('ShadowRightDeadT', 'BACKGROUND')
shadowsDead.right.t:SetTexture(C.textures.shadows.rightDead)
S.size(shadowsDead.right.t, 512, 256)
S.point(shadowsDead.right.t, 'RIGHT', shadowsDead, 'RIGHT', 0, 0)

local shadowsWater = CreateFrame('Frame')
shadowsWater:SetFrameStrata('BACKGROUND')
shadowsWater:SetScale(C.graphics.scale)
S.size(shadowsWater, 1024, 256)
S.point(shadowsWater, 'BOTTOM', 0, 11)

local shadowsWaterAnim = CreateAnimationGroup(shadowsWater)

local shadowsWaterFadeIn = shadowsWaterAnim:CreateAnimation('fade')
shadowsWaterFadeIn:SetDuration(1)
shadowsWaterFadeIn:SetChange(1)

local shadowsWaterFadeOut = shadowsWaterAnim:CreateAnimation('fade')
shadowsWaterFadeOut:SetDuration(1)
shadowsWaterFadeOut:SetChange(0)

shadowsWater.left = CreateFrame('Frame', 'ShadowLeftWater', shadowsWater)
shadowsWater.left.t = shadowsWater.left:CreateTexture('ShadowLeftWaterT', 'BACKGROUND')
shadowsWater.left.t:SetTexture(C.textures.shadows.leftWater)
shadowsWater.left:SetFrameLevel(shadows.left:GetFrameLevel() + 1)
S.size(shadowsWater.left.t, 512, 256)
S.point(shadowsWater.left.t, 'LEFT', shadowsWater, 'LEFT', 0, 0)

shadowsWater.right = CreateFrame('Frame', 'ShadowRightWater', shadowsWater)
shadowsWater.right.t = shadowsWater.right:CreateTexture('ShadowRightWaterT', 'BACKGROUND')
shadowsWater.right.t:SetTexture(C.textures.shadows.rightWater)
shadowsWater.right:SetFrameLevel(shadows.right:GetFrameLevel() + 1)
S.size(shadowsWater.right.t, 512, 256)
S.point(shadowsWater.right.t, 'RIGHT', shadowsWater, 'RIGHT', 0, 0)

shadows:SetAlpha(0)
shadowsCombat:SetAlpha(0)
shadowsDead:SetAlpha(0)
shadowsWater:SetAlpha(0)

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
      shadowsDeadFadeIn:Play()
    else
      shadowsFadeIn:Play()
    end
  end

  if event == 'PLAYER_REGEN_DISABLED' then
    if inCombat then
      shadowsFadeOut:Play()
      shadowsCombatFadeIn:Play()
    end
  end

  if event == 'PLAYER_REGEN_ENABLED' then
    if not inCombat then
      shadowsFadeIn:Play()
      shadowsCombatFadeOut:Play()
    end
  end

  if event == 'PLAYER_ALIVE' then
    if isDead then
      shadowsFadeOut:Play()
      shadowsDeadFadeIn:Play()
    end
  end

  if event == 'PLAYER_UNGHOST' then
    shadowsFadeIn:Play()
    shadowsDeadFadeOut:Play()
  end

  if event == 'UNIT_HEALTH' or event == 'UNIT_MAX_HEALTH' then
    local unitHealthPrecentage = UnitHealth('player') / UnitHealthMax('player')

    if unitHealthPrecentage < 0.5 and not isDead then
      shadows.left.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadows.right.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)

      shadowsCombat.left.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadowsCombat.right.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)

      shadowsWater.left.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
      shadowsWater.right.t:SetVertexColor(1, unitHealthPrecentage, unitHealthPrecentage)
    else
      shadows.left.t:SetVertexColor(1, 1, 1);
      shadows.right.t:SetVertexColor(1, 1, 1);

      shadowsCombat.left.t:SetVertexColor(1, 1, 1);
      shadowsCombat.right.t:SetVertexColor(1, 1, 1);

      shadowsWater.left.t:SetVertexColor(1, 1, 1);
      shadowsWater.right.t:SetVertexColor(1, 1, 1);
    end
  end
end)

local appliedWaterHud = false

hooksecurefunc("MirrorTimerFrame_OnUpdate", function(frame)
  if frame.paused then return end
  if not frame.value then return end
  if not frame.scale then return end

  if frame.timer == 'BREATH' and not appliedWaterHud then
    shadowsWaterFadeIn:Play()
    appliedWaterHud = true
  end
end)

hooksecurefunc('MirrorTimerFrame_OnEvent', function()
  if event == 'MIRROR_TIMER_STOP' and appliedWaterHud then
    shadowsWaterFadeOut:Play()
    appliedWaterHud = false
  end
end)
