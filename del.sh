#!/bin/bash
cmd=`cat del.lua`
redis-cli eval "$cmd" 1 mylist
