<?php
$o = new  Redis();
$o->connect("127.0.0.1");
$o->script('flush');
$cmd = file_get_contents("lrange.lua");
$cmd = $o->script('load',$cmd);
if (!$cmd){
	exit('load error'. $o->getLastError());
}
$max = 1;
$max = 10;
for($i=1; $i<=$max; $i++){
	$key = "user:$i";
	//$re = $o->lrange($key, $j);
	$r = array();
	$r[] = $key;
	//$r[] = rand(1,980);
	$r[] = 512*18+164;
	$r[] = 20;
	$re = $o->evalSha($cmd, $r, 1);
	var_dump($re);
//	var_dump($o->getLastError());
	//echo $i.":".$re;
	echo "\n";
}
