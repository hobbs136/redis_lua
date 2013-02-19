local config = redis.call('config','get','list-max-ziplist-entries')
local maxzipNum=tonumber(config[2])

local metainfo=KEYS[1]..':ml'
local metainfonum=KEYS[1]..':n'

local tmpKey, value, tmpV
local argvLen = #ARGV
local i=1

if argvLen ~= 1 then
	return false
end

local tmpTable = redis.call('lrange', metainfo, 0,-1)
if (#tmpTable == 0) then
	return false
end
--[[如果小于最后一个，则说明不属于任何分段，直接返回]]
value = tonumber(ARGV[1])
if value < tonumber(tmpTable[#tmpTable]) then
	return false
end

tmpV = tonumber(tmpTable[1])
--[[如果大于等于第一个，则说明可能在第一个分段]]
if value >= tmpV then
	tmpKey = KEYS[1] .. ':' .. tmpV
else
	tmpV = math.floor(#tmpTable/2)
	if tonumber(tmpTable[tmpV])>value then
		i = tmpV
	end
	while (tmpTable[i]) do
		tmpV = tonumber(tmpTable[i])
		if tmpV <= value then
			tmpKey = KEYS[1] .. ':' .. tmpV
			break
		end
		i = i+1
	end
end
if tmpKey == nil then
	return false
end

if redis.call('lrem',tmpKey, 1, value) > 0 then
	return redis.call('incrby',metainfonum,-1)
else
	return false
end
