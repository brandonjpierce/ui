setfenv(1, SmellyUI.engine)

local next = next

local Anim = CreateFrame('Frame')
local running = {}
local duration = 0.5

local function onAnimate(frame)
  local anim = frame.anim
	local percent = anim.total / duration
	local value = anim.start + anim.diff * percent

	if value <= 0 then value = 0.01 end

	frame:SetAlpha(value)
end


local function onFinish(frame)
	local anim = frame.anim
	frame:SetAlpha(anim.alpha)

  if frame.onfinishhide then
		frame.onfinishhide = false
    HideUIPanel(frame)
		frame.hiding = false
	end
end

local function onUpdate()
  if next(running) == nil then return end

	for i, frame in next, running do
		local anim = frame.anim
		anim.total = anim.total + arg1

		if anim.total >= duration then
			anim.total = 0
			running[i] = nil
			onFinish(frame)
		else
			onAnimate(frame)
		end
	end
end

local function onShow()
	local frame = this:GetParent()

	if frame.hiding or running[frame] then return end

	tinsert(running, frame)

	frame:SetScript('OnShow', function()
		local anim = frame.anim
		anim.alpha = 1
    anim.start = 0.1
		anim.diff = 1
	end)
end

local function onHide()
	local frame = this:GetParent()

	if frame.hiding or running[frame] then return end

	tinsert(running, frame)

	frame:SetScript('OnHide', function()
		local anim = frame.anim
		anim.alpha = 0
    anim.start = 1
		anim.diff = -1
	end)

  frame.onfinishhide = true
	frame.hiding = true
	frame:Show()
end

function Anim:RegisterFrames(...)
	for i = 1, arg.n do
		local arg = arg[i]

		if type(arg) == 'string' then
			local frame = _G[arg]

			if not frame then
        return print('Anim:|cff98F5FF '..arg..'|r not found.')
      end

			frame.anim = frame.anim or {}
			frame.anim.total = 0

			local hook = CreateFrame('Frame', nil, frame)
			hook:SetScript('OnShow', onShow)
			hook:SetScript('OnHide', onHide)
		end
	end
end

Anim:SetScript('OnUpdate', onUpdate)

S.Anim = Anim
