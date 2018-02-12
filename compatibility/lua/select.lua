local assert = assert
local format = string.format
local getn = table.getn
local type = type
local unpack = unpack

function select(n, ...)
	assert(
    type(n) == 'number' or (type(n) == 'string' and n == '#'),
    format(
      'bad argument #1 to "select" (number expected, got %s)',
      n and type(n) or 'no value'
    )
  )

	if type(n) == 'string' then
		return getn(arg)
	end

	if n == 1 then
		return unpack(arg)
	end

	local args = {}

	for i = n, getn(arg) do
		args[i-n+1] = arg[i]
	end

	return unpack(args)
end
