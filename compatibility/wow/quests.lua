local GetQuestGreenRange = GetQuestGreenRange
local UnitLevel = UnitLevel

function GetQuestDifficultyColor(level)
	local levelDiff = level - UnitLevel('player')

	if levelDiff >= 5 then
		return QUEST_DIFFICULTY_COLORS['impossible']
	elseif levelDiff >= 3 then
		return QUEST_DIFFICULTY_COLORS['verydifficult']
	elseif levelDiff >= -2 then
		return QUEST_DIFFICULTY_COLORS['difficult']
	elseif -levelDiff <= GetQuestGreenRange() then
		return QUEST_DIFFICULTY_COLORS['standard']
	else
		return QUEST_DIFFICULTY_COLORS['trivial']
	end
end
