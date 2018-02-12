local getn = table.getn

CLASS_SORT_ORDER = {
	'WARRIOR',
	'PALADIN',
	'PRIEST',
	'SHAMAN',
	'DRUID',
	'ROGUE',
	'MAGE',
	'WARLOCK',
	'HUNTER'
}

MAX_CLASSES = getn(CLASS_SORT_ORDER)

CLASS_ICON_TCOORDS = {
	['WARRIOR'] = {0, 0.25, 0, 0.25},
	['MAGE'] = {0.25, 0.49609375, 0, 0.25},
	['ROGUE'] = {0.49609375, 0.7421875, 0, 0.25},
	['DRUID'] = {0.7421875, 0.98828125, 0, 0.25},
	['HUNTER'] = {0, 0.25, 0.25, 0.5},
	['SHAMAN'] = {0.25, 0.49609375, 0.25, 0.5},
	['PRIEST'] = {0.49609375, 0.7421875, 0.25, 0.5},
	['WARLOCK'] = {0.7421875, 0.98828125, 0.25, 0.5},
	['PALADIN'] = {0, 0.25, 0.5, 0.75},
}

QUEST_DIFFICULTY_COLORS = {
	['impossible'] = {r = 1.00, g = 0.10, b = 0.10},
	['verydifficult'] = {r = 1.00, g = 0.50, b = 0.25},
	['difficult'] = {r = 1.00, g = 1.00, b = 0.00},
	['standard'] = {r = 0.25, g = 0.75, b = 0.25},
	['trivial'] = {r = 0.50, g = 0.50, b = 0.50},
	['header'] = {r = 0.70, g = 0.70, b = 0.70},
}

QUEST_DIFFICULTY_HIGHLIGHT_COLORS = {
	["impossible"] = {r = 1.00, g = 0.40, b = 0.40},
	["verydifficult"]	= {r = 1.00, g = 0.75, b = 0.44},
	["difficult"] = {r = 1.00, g = 1.00, b = 0.10},
	["standard"] = {r = 0.43, g = 0.93, b = 0.43},
	["trivial"] = {r = 0.70, g = 0.70, b = 0.70},
	["header"] = {r = 1.00, g = 1.00, b = 1.00},
};
