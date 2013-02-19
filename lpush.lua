local config = redis.call('config','get','list-max-ziplist-entries')
local maxzipNum=tonumber(config[2])
local metainfo=KEYS[1]..':ml' --[[ 存储分段信息 ]]
local metainfonum=KEYS[1]..':n' --[[存储list中有多少个元素]]
local tmpKey
local new=false
local firstelement = redis.call('lrange',metainfo,0,0) 
if #firstelement > 0 then
	tmpKey = KEYS[1]..':'..firstelement[1]
	if redis.call('llen',tmpKey) >= maxzipNum then
		new=true
	end
else
	new=true
end
if new then
	tmpKey = KEYS[1]..':'..ARGV[1]
	redis.call('lpush', metainfo, ARGV[1])
end
redis.call('lpush',tmpKey, ARGV[1])
return redis.call('incrby',metainfonum,1)
