<?php
require 'online.inc';

//echo $_SERVER['HTTP_REFERER'];

$nmt = 200;
//$smarty->debugging = true;
$smarty->compile_check = true;


$page = $_REQUEST['page'];
if (!$page) {$page=1;}

$sort = $_REQUEST['sort'];
if (!$sort) {$sort=1;}



$smarty->assign('sort', $sort);

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



$z = mysqli_query($db,"SELECT COUNT(*) FROM last_rate");
$p = mysqli_fetch_array($z);
$nm_pages = ceil($p[0] / $nmt);
$from = ($page-1) * $nmt;

for ($i = 1; $i <= $nm_pages; $i++) {

	$pg[$i-1] = $i;
	
}	
$smarty->assign('pages', $pg);
$smarty->assign('page', $page);
$smarty->assign('nm1', $nmt);
$smarty->assign('nm2', $p[0]);


if ($sort == 1) {$srt = "last_rate.date DESC";}
elseif ($sort == 2) {$srt = "muzx_authors.nickname ASC";}
elseif ($sort == 3) {$srt = "muzx_songs.rating DESC";}
elseif ($sort == 4) {$srt = "rand()";}



$v = mysqli_query($db,"SELECT * FROM last_rate, muzx_songs, muzx_authors WHERE muzx_authors.id = last_rate.id_author AND  muzx_songs.id = last_rate.id_song ORDER BY $srt LIMIT $from, $nmt");


$n=0;
while ($src = mysqli_fetch_array($v)) {

	$src['name'] = htmlentities($src['name']);
	$src['nm']=$n+1;
	$src['id'] = $src['id_song'];
	$ri = $src['id'];
	if ($_REQUEST['rt'.$ri]) {$src['rt'] = "r_off";} else {$src['rt'] = "rating";}
	
	$sr[$n]=$src;
	$n++;

}


for($x=0; $x<$n; $x++) {

    $sr[$x]['next_id'] = $sr[$x+1]['id'];
	$sr[$x]['prev_id'] = $sr[$x-1]['id'];
	
}
$sr[0]['prev_id'] = $sr[$n-1]['id'];
$sr[$n-1]['next_id'] = $sr[0]['id'];

$smarty->assign('search', $sr);





include "right_strip.php";

$smarty->display('last_rated.tpl');
?>