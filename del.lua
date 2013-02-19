--[[del]]
local metainfo = KEYS[1]..':ml'
local metainfonum=KEYS[1]..':n'

local len = tonumber(redis.call('get',metainfonum));
if (len == nil) then
	return false
end


local element = redis.call('lrange',metainfo,0,-1)
local i=1
local j=0
while (element[i] ~= nil) do
	j=j+redis.call('del', KEYS[1]..':'..element[i])
	i = i+1
end

j=j+redis.call('del', metainfo, metainfonum)
return j
