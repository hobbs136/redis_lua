local config = redis.call('config','get','list-max-ziplist-entries')
local maxzipNum=tonumber(config[2])
local argvLen = #ARGV
local j
local i=1
local tmpKey
local len

local metainfo=KEYS[1]..':ml'
local metainfonum=KEYS[1]..':n'

local firstelement = redis.call('lrange',metainfo,0,0)
if (#firstelement > 0) then --[[非第一次插入]]
	tmpKey = KEYS[1]..':'..firstelement[1]
	len = redis.call('llen', tmpKey)
	j = i+maxzipNum-len
	if j>i then
		redis.call('lpush', unpack(ARGV, i, j-1))
	end
	i=j
end

while (i<argvLen) do
	j = i+maxzipNum
	if j > argvLen then
		j = argvLen+1
	end
	redis.call('lpush', KEYS[1]..':'..ARGV[i], unpack(ARGV, i, j-1))
	redis.call('lpush', metainfo, ARGV[i])
	i=j
end
return redis.call('incrby',metainfonum,#ARGV)

