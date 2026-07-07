<?php
require 'ini.php';



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
  $a="/news.php?";
  return $a;
}



$smarty->compile_check = true;
$smarty->assign('active', array('news' => 'class=active'));

//$smarty->debugging = true;

$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/news.php");


if ($_SESSION['language']=="rus") {$smarty->assign('title', 'Новости');
}
else {$smarty->assign('title', 'News');
}


if ($_SESSION['language']=="rus") {

$tb[1]="имя файла";
$tb[2]="название";
$tb[3]="год";
$tb[4]="обновлен";
$tb[5]="скачан";
$tb[6]="рейтинг";



$smarty->assign('au', "Авторы");
$smarty->assign('per', "по");
if ($order=="interview" or $order=="photo" or $order=="contact" ) {$smarty->assign('per', "с");}


$smarty->assign('kl1', "показано");
$smarty->assign('kl3', "из");
$all="ВСЕ";

}
else {
		 
$tb[1]="file name";
$tb[2]="title";
$tb[3]="year";
$tb[4]="update";
$tb[5]="downloads";
$tb[6]="rating";


		 
$smarty->assign('au', "Authors");
$smarty->assign('per', "by");

$smarty->assign('kl1', "authors");
$smarty->assign('kl3', "from");
$all="ALL";
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


//$z = mysqli_query($db,"SELECT COUNT(*) FROM news " );
//$k = mysqli_fetch_array($zapros8);



$zapros8 = mysqli_query($db,"SELECT COUNT(*) FROM news " );
if (!$zapros8) {echo mysql_error();}
else {$gbk=mysqli_fetch_array($zapros8);
}

$zapros = mysqli_query($db,"SELECT news.*, IF(users.login != '', users.login, IF(news.user_name != '', news.user_name, 'zxtunes')) AS username FROM news LEFT JOIN users ON news.user_id=users.id ORDER BY news.update DESC " );
if (!$zapros)
	echo mysql_error();
else
{ $n=0;
while ($gb = mysqli_fetch_array($zapros)) {

$gb['nm']=$gbk[0];
if ($_SESSION['language']=="rus") {$m=$amdate[date("m", $gb['update'])]; echo "";
$gb['update']=date("j $m Y H:i", $gb['update']);}

else {$gb['update']=date("F j\\t\h Y, H:i", $gb['update']);}
$g[$n]=$gb;

$n++;
$gbk[0]--;
}
}

$smarty->assign('code', rand(1,9)." + ".rand(1,9));



$smarty->assign('news', $g);













$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('news.tpl');