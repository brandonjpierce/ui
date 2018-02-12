local Engine = {}
Engine[1] = CreateFrame('Frame', 'SmellyUI', UIParent)
Engine[2] = {}

SmellyUI = Engine
SmellyUI_DB = {}
SmellyUI_PlayerDB = {}

function Engine:unpack()
	return Engine[1], Engine[2]
end

SLASH_RELOADUI1 = '/rl'
SlashCmdList.RELOADUI = ReloadUI
