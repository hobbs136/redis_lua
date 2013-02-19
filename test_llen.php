<?php
$o = new  Redis();
$o->connect("127.0.0.1");
$cmd = file_get_contents("llen.lua");
$max = 1;
$max = 100;
for($i=$max; $i>=1; $i--){
	$key = "user:$i";
	//$re = $o->lSize($key);
	$r = array();
	$r[] = $key;
	$re = $o->eval($cmd, $r, 1);
	//var_dump($re);
	//var_dump($o->getLastError());
	echo $i.":".$re;
	echo "\n";
}
