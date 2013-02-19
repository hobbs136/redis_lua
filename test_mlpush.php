<?php
function get($key){
	static $a;
	$ports = array(6379,6378,6377,6376);
	$k = (int)fmod(floatval(sprintf("%u",\crc32($key))),\count($ports));
	if (!isset($a[$k])){
		$o = new  Redis();
		$o->connect("127.0.0.1", $ports[$k]);
		$cmd = file_get_contents("mlpush.lua");
		$cmd = $o->script('load',$cmd);
		$a[$k] = array($o, $cmd);
	}
	return $a[$k];
}
//$max = 1;
$start = 100001;
$max = 100000;
for($i=$start; $i<=$start+$max; $i++){
	$key = "user:$i";
	$tmp = get($key);
	$o = $tmp[0];
	$cmd = $tmp[1];
	$rand = 1;
	$r = range($rand, $rand+10000-1);
	array_unshift($r, $key);
	$re = $o->evalSha($cmd, $r, 1);
	echo $i.":".$re;
	//var_dump($re);
	//var_dump($o->getLastError());
	//echo $i.":".call_user_func_array(array($o,"lPush"), $r);
	echo "\n";
}
