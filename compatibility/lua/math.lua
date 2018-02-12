local assert = assert
local ceil = math.ceil
local floor = math.floor
local format = string.format
local type = type

function math.modf(i)
	assert(
    type(i) == 'number',
    format(
      'bad argument #1 to "modf" (number expected, got %s)',
      i and type(i) or 'no value'
    )
  )

	local int = i >= 0 and floor(i) or ceil(i)

	return int, i - int
end

function math.round(i, place)
  assert(
    type(i) == 'number',
    format(
      'bad argument #1 to "round" (number expected, got %s)',
      i and type(i) or 'no value'
    )
  )

  return floor(i / place + 0.5) * place
end
