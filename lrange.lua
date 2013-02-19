--[[lrange]]
local tonumber=tonumber
local config = redis.call('config','get','list-max-ziplist-entries')
local maxzipNum=tonumber(config[2])

local metainfo=KEYS[1]..':ml'
local metainfonum=KEYS[1]..':n'

local len = tonumber(redis.call('get',metainfonum));
if (len == nil) then
	return false
end

local offset = tonumber(ARGV[1])
local pagesize = tonumber(ARGV[2])


if (offset >= len) then
	return false
end


local element = redis.call('lrange',metainfo,0,-1)
local tmpLen, tmpTable
local i=1

while (element[i] ~= nil) do
	tmpLen = redis.call('llen',KEYS[1]..':'..element[i])
	if offset > tmpLen then
		offset = offset - tmpLen
	else
		break
	end
	i = i+1
end


local tmpList =  {}
tmpLen = pagesize
while (tmpLen > 0) do
	if element[i] == nil then
		break;
	end

	tmpTable = redis.call('lrange', KEYS[1]..':'..element[i], offset, offset+tmpLen-1)
	if (#tmpTable == pagesize) then
		tmpList = tmpTable
		break
	end

	if (#tmpTable == 0) then
		break;
	end

	for _,v in ipairs(tmpTable) do
		tmpList[#tmpList+1] = v
	end
	i = i+1
	tmpLen = tmpLen - #tmpTable
	if offset > #tmpTable then
		offset = offset - #tmpTable
	end
end

return tmpList
