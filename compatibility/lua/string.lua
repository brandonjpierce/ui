local assert = assert
local find = string.find
local format = string.format
local getn = table.getn
local gfind = string.gfind
local gsub = string.gsub
local loadstring = loadstring
local sub = string.sub
local tonumber = tonumber
local tostring = tostring
local tinsert = table.insert
local type = type
local unpack = unpack

function string.join(delimiter, ...)
	assert(
    type(delimiter) == 'string' or type(delimiter) == 'number',
    format(
      'bad argument #1 to "join" (string expected, got %s)',
      delimiter and type(delimiter) or 'no value'
    )
  )

	local size = getn(arg)

	if size == 0 then
		return ''
	end

	local text = arg[1]

	for i = 2, size do
		text = text..delimiter..arg[i]
	end

	return text
end

function string.match(str, pattern, index)
	assert(
    type(str) == 'string' or type(str) == 'number',
    format(
      'bad argument #1 to "match" (string expected, got %s)',
      str and type(str) or 'no value'
    )
  )

	assert(
    type(pattern) == 'string' or type(pattern) == 'number',
    format(
      'bad argument #2 to "match" (string expected, got %s)',
      pattern and type(pattern) or 'no value'
    )
  )

	assert(
    not index or type(index) == 'number' or type(index) == 'string',
    format(
      'bad argument #3 to "match" (number expected, got %s)',
      index and type(index) or 'no value'
    )
  )

	str = type(str) == 'number' and tostring(str) or str
	pattern = type(pattern) == 'number' and tostring(pattern) or pattern

	if type(index) == 'string' then
		index = index ~= '' and tonumber(index) or nil
	end

	local i1, i2, match, match2 = find(str, pattern, index)

	if not match and i2 and i2 >= i1 then
		return sub(str, i1, i2)
	elseif match2 then
		return select(3, find(str, pattern, index))
	end

	return match
end

function string.split(delimiter, str)
	assert(
    type(delimiter) == 'string' or type(str) == 'number',
    format(
      'bad argument #1 to "split" (string expected, got %s)',
      delimiter and type(delimiter) or 'no value'
    )
  )

	assert(
    type(str) == 'string' or type(str) == 'number',
    format(
      'bad argument #2 to "split" (string expected, got %s)',
      str and type(str) or 'no value'
    )
  )

	str = type(str) == 'number' and tostring(str) or str

	local fields = {}

	gsub(
		str,
		format('([^%s]+)', delimiter),
		function(c) fields[getn(fields) + 1] = c end
	)

	return unpack(fields)
end

string.gmatch = gfind
strjoin = join
strmatch = match
strsplit = split
