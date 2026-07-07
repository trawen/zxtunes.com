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
if (!$id) {$id = 1;}


$smarty->assign('active', array('remix_mp3' => 'class=active'));

$smarty->compile_check = true;
//$smarty->debugging = true;



$z = mysqli_query($db,"SELECT * FROM remix_from WHERE rfr_id='$id' LIMIT 1" );
$smarty->assign('remix_info', mysqli_fetch_array($z));


$z = mysqli_query($db,"SELECT * FROM remix_tune, remix_title, muzx_songs, muzx_songs_authors, muzx_authors, remix_album WHERE rtu_id_from='$id' AND rti_id=rtu_id_title AND muzx_songs.id=rtu_id_song AND song_id=muzx_songs.id AND  muzx_authors.id=author_id AND ral_id=rtu_id_album ORDER BY rtu_id_album, rti_title_ru" );

$n = 0;
$last = "";
while ($t = mysqli_fetch_array($z)) {

	if ($last <> $t['rtu_id_album']) {$last = $t['rtu_id_album']; $t['show_album'] = 1;} 
	
	$t['nm'] = $n+1;
	$r[$n] = $t;
	$n++;
}

for($x=0; $x<$n; $x++) {

    $r[$x]['next_id'] = $r[$x+1]['song_id'];
	$r[$x]['prev_id'] = $r[$x-1]['song_id'];
	
}
$r[0]['prev_id'] = $r[$n-1]['song_id'];
$r[$n-1]['next_id'] = $r[0]['song_id'];

$smarty->assign('remixes', $r);



include "right_strip.php";  

$smarty->display('ay_remixes_play.tpl');

