#!/bin/bash
cmd=`cat lpush.lua`
redis-benchmark -r 10000 -n 10000 eval "$cmd" 1 mylist 
