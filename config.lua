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

C.textures = {}
C.textures.blank = 'Interface\\AddOns\\SmellyUI\\textures\\blank'
C.textures.mail = 'Interface\\AddOns\\SmellyUI\\textures\\mail'

C.graphics = {}
C.graphics.mult = mult
C.graphics.width = width
C.graphics.height = height
