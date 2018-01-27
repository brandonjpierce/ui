setfenv(1, SmellyUI.engine)

local mult
local width
local height
local scale = GetCVar('uiScale')
local resolution = GetCVar('gxResolution')

for screenWidth, screenHeight in string.gfind(resolution, '(.+)x(.+)') do
  height = screenHeight
  width = screenWidth
  mult = 768 / screenHeight / scale
end

C.graphics = {
  scale = scale,
  mult = mult,
  width = width,
  height = height,
}

C.textures = {
  blank = 'Interface\\AddOns\\SmellyUI\\textures\\blank',
  mail = 'Interface\\AddOns\\SmellyUI\\textures\\mail',
  map = 'Interface\\AddOns\\SmellyUI\\textures\\map',
  shadows = {
    right = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\right',
    rightCombat = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\right-combat',
    rightDead = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\right-dead',
    rightWater = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\right-swim',
    left = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\left',
    leftCombat = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\left-combat',
    leftDead = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\left-dead',
    leftWater = 'Interface\\AddOns\\SmellyUI\\textures\\shadows\\left-swim',
  }
}
