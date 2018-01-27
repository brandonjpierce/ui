local f = CreateFrame('Frame')

function f:QUEST_COMPLETE(addon)
  if getn(QUEST_WATCH_LIST) == 0 then return end

  local title = GetTitleText()
  if not title then return end

  for i = 1, getn(QUEST_WATCH_LIST) do
    if title == GetQuestLogTitle(QUEST_WATCH_LIST[i].index) then
      table.remove(QUEST_WATCH_LIST, i)
      break
    end
  end
end

f:RegisterEvent('QUEST_COMPLETE')
f:SetScript('OnEvent', function()
  this[event](this, arg1)
end)
