<?php
$o = new  Redis();
$o->connect("127.0.0.1");
$cmd = file_get_contents("lrem.lua");
$max = 1;
$max = 1000;
for($i=1; $i<=$max; $i++){
	$key = "user:$i";
	//$re = $o->lrange($key, $j);
	$r = array();
	$r[] = $key;
	//$r[] = rand(1,980);
	$r[] = 5;
	$re = $o->eval($cmd, $r, 1);
	var_dump($o->getLastError());
	var_dump($re);
	//echo $i.":".$re;
	echo "\n";
}
