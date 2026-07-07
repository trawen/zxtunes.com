<?php
require 'online.inc';

function geturl($i){
  global $id,$md,$fr,$lm,$up,$order;
  $a="/author.php?id=".$id;
  if ($i) {$a.="&tnid=".$i;}
  if ($fr and $fr!=1) {$a.="&fr=".$fr;}
  if ($lm and $lm!=40) {$a.="&lm=".$lm;}
  if ($up and $up!='DESC') {$a.="&up=".$up;}
  if ($order and $order!='year') {$a.="&order=".$order;}
  return $a;
}




$type = $_REQUEST['type'];
if (!$type) {$type = 1;}


$smarty->assign('active', array('remix_mp3' => 'class=active'));

$smarty->compile_check = true;
//$smarty->debugging = true;


$z = mysqli_query($db,"SELECT * FROM remix_from WHERE rfr_type='$type' ORDER BY rfr_name_ru" );
$n = 0;
$last = "";
while ($t = mysqli_fetch_array($z)) {

	$t['lit'] = mb_substr($t['rfr_name_ru'], 0, 1, 'UTF-8');
	
	if ($last <> $t['lit']) {$last = $t['lit']; $t['show_lit'] = 1;} 
	
	$t['nm'] = $n+1;
	$r[$n] = $t;
	$n++;
}

$smarty->assign('remixes', $r);




$smarty->assign('type', $type);

include "right_strip.php";  

$smarty->display('ay_remixes.tpl');

