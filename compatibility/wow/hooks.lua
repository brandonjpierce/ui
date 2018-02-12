local assert = assert
local type = type
local unpack = unpack

function HookScript(frame, scriptType, handler)
	assert(
    type(frame) == 'table' and
      frame.GetScript and type(scriptType) == 'string' and
      type(handler) == 'function',
    'Usage: HookScript(frame, \'type\', function)'
  )

	local originalScript = frame:GetScript(scriptType)

	if originalScript then
		frame:SetScript(scriptType, function(...)
			local originalReturn = {originalScript(unpack(arg))}
			handler(unpack(arg))

			return unpack(originalReturn)
		end)
	else
		frame:SetScript(scriptType, handler)
	end
end

function hooksecurefunc(arg1, arg2, arg3)
	local isMethod = type(arg1) == 'table' and
    type(arg2) == 'string' and
    type(arg1[arg2]) == 'function' and
      type(arg3) == 'function'

	assert(
    isMethod or (
      type(arg1) == 'string' and
      type(_G[arg1]) == 'function' and
      type(arg2) == 'function'
    ),
    'Usage: hooksecurefunc([table,] \'functionName\', hookfunc)'
  )

	if not isMethod then
		arg1, arg2, arg3 = _G, arg1, arg2
	end

	local originalFunc = arg1[arg2]

	arg1[arg2] = function(...)
		local originalReturn = {originalFunc(unpack(arg))}
		arg3(unpack(arg))

		return unpack(originalReturn)
	end
end
