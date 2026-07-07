<?php
require 'online.inc';

$id=$_REQUEST['id'];
$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];
$ln=$_REQUEST['ln'];
$md=$_REQUEST['md'];
$order=$_REQUEST['order'];
$rate=$_REQUEST['rate'];
$tnid = explode("=", $md);
$ip=$_SERVER["REMOTE_ADDR"];
$client = " ".($_SERVER['HTTP_USER_AGENT'] ?? ''); 
if(strstr($client,"Yandex") or strstr($client,"Googlebot")) {$bot=1;} else {$bot=0;}

if ($tnid[1]) {$md=$tnid[0];}

if (!$md) {$md=1;}
if (!$fr) {$fr=1;}
if (!$ln) {$ln="eng";}
if (!$order) {$order="year";}
if (!$up) {$up="DESC";}
if (!$lm or $lm<40) {$lm=40;}
if ($ln=="rus") {$lang="";} else {$lang="_en";}

$fr2=($fr-1)*40;


function geturl($i){
  $a="/updates.php?";
  return $a;
}



$smarty->compile_check = true;

//$smarty->debugging = true;

$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/soft.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$ord);


if ($_SESSION['language']=="rus") {$smarty->assign('title', 'Обновления - полный список');
}
else {$smarty->assign('title', 'Updates - full list');
}




$amdate = array(
		"01"=>"января",
		"02"=>"февраля",
		"03"=>"марта",
		"04"=>"апреля",
		"05"=>"мая",
		"06"=>"июня",
		"07"=>"июля",
		"08"=>"августа",
		"09"=>"сентября",
		"10"=>"октября",
		"11"=>"ноября",
		"12"=>"декабря");


		
$upl = mysqli_query($db,"SELECT log.event,log.event_id,log.update,log.misc,muzx_authors.nickname, muzx_authors.id  FROM log, muzx_authors WHERE log.event_id=muzx_authors.id AND log.hidden=0 AND log.event!=2 AND log.event!=8 ORDER BY FLOOR(log.update/86400) DESC" );

if (!$upl) {echo mysql_error();}
else { $n=0;
while ($gb = mysqli_fetch_array($upl)) {


$tm1=ceil(time()/86400);
if ($_SESSION['language']=="rus") {

$m=$amdate[date("m", $gb['update'])];
$gb['update2']=date("Y", $gb['update']);
$gb['update']=date("j $m", $gb['update']);
}

else {$gb['update2']=date("Y", $gb['update']); $gb['update']=date("F j\\t\h", $gb['update']); }

if ($lsup!=$gb['update']) {$lsup=$gb['update'];}
else {unset($gb['update']);}
$u[$n]=$gb;

$n++;
}
}
$smarty->assign('updates', $u);

unset($u);


$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('updates.tpl');