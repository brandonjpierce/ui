local assert = assert
local format = string.format
local getn = table.getn
local pairs = pairs
local setn = table.setn
local type = type

function table.wipe(t)
	assert(
    type(t) == 'table',
    format(
      'bad argument #1 to "wipe" (table expected, got %s)',
      t and type(t) or 'no value'
    )
  )

	for k in pairs(t) do
		t[k] = nil
	end

	if getn(t) ~= 0 then
		setn(t, 0)
	end

	return t
end

wipe = table.wipe
