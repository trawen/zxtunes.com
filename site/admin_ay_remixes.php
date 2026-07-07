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




$id = $_REQUEST['id'];
if ($id) {$smarty->assign('id', $id);}

$smarty->assign('mode', $_REQUEST['mode']);
$smarty->assign('type', $_REQUEST['type']);


$z = mysqli_query($db,"SELECT * FROM remix_from WHERE rfr_id = $id" );
$t = mysqli_fetch_array($z);
$smarty->assign('remix', $t);



$z = mysqli_query($db,"SELECT * FROM remix_tune WHERE rtu_id_from=$id " ); 
echo mysql_error();
$n = 0;
while ($t = mysqli_fetch_array($z)) {

	$id_remix = $t['rtu_id_song'];

	
	$z2 = mysqli_query($db,"SELECT * FROM muzx_songs WHERE id = $id_remix " ); //echo mysql_error();
	$m = 0;
	while ($t2 = mysqli_fetch_array($z2)) {

		$tr[$m] = $t2;
		$m++;

	}
	
	$t['tracks'] = $tr;
	
	$rem[$n] = $t;
	$n++;

}
$smarty->assign('remix_tracks', $rem);







$smarty->assign('active', array('remix_mp3' => 'class=active'));

$smarty->compile_check = true;
$smarty->debugging = true;



$z = mysqli_query($db,"SELECT * FROM remix_from ORDER BY rfr_type, rfr_name_ru" ); //echo mysql_error();
$n = 0;
while ($t = mysqli_fetch_array($z)) {

	$r[$n] = $t;
	$n++;

}
$smarty->assign('remixes', $r);



$z = mysqli_query($db,"SELECT * FROM muzx_authors ORDER BY nickname" ); //echo mysql_error();
$n = 0;
while ($t = mysqli_fetch_array($z)) {

	$r[$n] = $t;
	$n++;

}
$smarty->assign('authors', $r);




include "right_strip.php";  

$smarty->display('admin_ay_remixes.tpl');

