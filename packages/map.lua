local S, C = SmellyUI:unpack()

-- TODO
-- 1. Zone coords
-- 2. Current time
-- 3. Latency & Ping

local backdrop = S.backdrop
local inside = S.inside
local kill = S.kill
local outside = S.outside
local point = S.point
local size = S.size

local f = CreateFrame('Frame')

local function onMinimapScroll()
  if arg1 > 0 then
    Minimap_ZoomIn()
  else
    Minimap_ZoomOut()
  end
end

function f:ADDON_LOADED(addon)
  if addon ~= 'SmellyUI' then return end
  f:UnregisterEvent('ADDON_LOADED')

  -- HIDE BLIZZARD --

  local hideFrames = {
    MinimapBorder,
    MinimapBorderTop,
    MinimapZoomIn,
    MinimapZoomOut,
    MinimapToggleButton,
    MinimapZoneTextButton,
    MiniMapMailBorder,
    GameTimeFrame,
  }

  for _, frame in pairs(hideFrames) do
    kill(frame)
  end

  -- STYLE --

  Minimap:SetParent(UIParent)
  Minimap:SetMaskTexture(C.textures.blank)
  Minimap:ClearAllPoints()
  size(Minimap, 150)
  backdrop(Minimap)
  point(Minimap, 'TOPRIGHT', UIParent, 'TOPRIGHT', -30, -30)

  -- Mail icon
  MiniMapMailFrame:ClearAllPoints()
  point(MiniMapMailFrame, 'TOPRIGHT', Minimap, 'TOPRIGHT', 0, 3)
  size(MiniMapMailFrame, 30)

  MiniMapMailIcon:SetTexture(C.textures.mail)
  inside(MiniMapMailIcon)

  -- Zone text
  local zone = CreateFrame("Frame", nil, Minimap)
  zone:SetHeight(20)
  zone:SetWidth(Minimap:GetWidth())
  zone:SetFrameLevel(Minimap:GetFrameLevel() + 1)
  zone:SetFrameStrata('HIGH')
  zone:SetPoint("TOP", Minimap, 'TOP', 0, 0)
  zone:SetAlpha(0)

  zone.text = zone:CreateFontString("zoneText", "LOW", "GameFontNormal")
  zone.text:SetFont('Fonts\\FRIZQT__.TTF', 12, "OUTLINE")
  zone.text:SetAllPoints(zone)
  zone.text:SetJustifyH("CENTER")

  -- Coords text
  local coords = CreateFrame("Frame", nil, Minimap)
  coords:SetHeight(20)
  coords:SetWidth(Minimap:GetWidth())
  coords:SetFrameLevel(Minimap:GetFrameLevel() + 1)
  coords:SetFrameStrata('HIGH')
  coords:SetPoint("BOTTOM", Minimap, 'BOTTOM', 0, 3)
  coords:SetAlpha(0)

  coords.text = coords:CreateFontString("zoneText", "LOW", "GameFontNormal")
  coords.text:SetFont('Fonts\\FRIZQT__.TTF', 12, "OUTLINE")
  coords.text:SetAllPoints(coords)
  coords.text:SetJustifyH("CENTER")

  local zoneAnim = CreateAnimationGroup(zone)
  local coordsAnim = CreateAnimationGroup(coords)

  local zoneFadeIn = zoneAnim:CreateAnimation('fade')
  zoneFadeIn:SetChange(1)
  zoneFadeIn:SetDuration(0.2)
  zoneFadeIn:SetSmoothing('inout')

  local zoneFadeOut = zoneAnim:CreateAnimation('fade')
  zoneFadeOut:SetChange(0)
  zoneFadeOut:SetDuration(0.2)
  zoneFadeOut:SetSmoothing('inout')

  local coordsFadeIn = coordsAnim:CreateAnimation('fade')
  coordsFadeIn:SetChange(1)
  coordsFadeIn:SetDuration(0.2)
  coordsFadeIn:SetSmoothing('inout')

  local coordsFadeOut = coordsAnim:CreateAnimation('fade')
  coordsFadeOut:SetChange(0)
  coordsFadeOut:SetDuration(0.2)
  coordsFadeOut:SetSmoothing('inout')

  -- INTERACTIONS --

  Minimap:EnableMouseWheel(true)
  Minimap:SetScript('OnMouseWheel', onMinimapScroll)

  Minimap:SetScript("OnEnter", function()
    SetMapToCurrentZone()
    zone.text:SetText(GetMinimapZoneText())

    local posX, posY = GetPlayerMapPosition("player")

    if posX ~= 0 and posY ~= 0 then
      coords.text:SetText(math.round(posX * 100, 1) .. ", " .. math.round(posY * 100, 1))
    else
      coords.text:SetText("|cffffaaaaN/A")
    end

    zoneFadeIn:Play()
    coordsFadeIn:Play()
  end)

  Minimap:SetScript("OnLeave", function()
    zoneFadeOut:Play()
    coordsFadeOut:Play()
  end)
end

function f:OnEvent()
  this[event](this, arg1)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', f.OnEvent)
