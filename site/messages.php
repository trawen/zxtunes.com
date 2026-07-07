<?php
require 'ini.php';


$ip=$_SERVER["REMOTE_ADDR"];


function geturl($i){
  $a="/messages.php?";
  return $a;
}

if ($_SESSION['language']=="rus") {$smarty->assign('title', 'Гостевые сообщения - полный список');}
else {$smarty->assign('title', 'Guest messages - the full list');}


$smarty->compile_check = true;


//$smarty->debugging = true;

$mode[$md]="class=selected";
$smarty->assign('id',$id);
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/messages.php");




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






$zapros = mysqli_query($db,"SELECT * FROM guestbook ORDER BY guestbook.update DESC " );
if (!$zapros)
	echo mysql_error();
else
{ $n=0;
while ($gb = mysqli_fetch_array($zapros)) {

$gb['nm']=$gbk[0];
if ($_SESSION['language']=="rus") {$m=$amdate[date("m", $gb['update'])]; echo "";
$gb['update']=date("j $m Y H:i", $gb['update']);}

else {$gb['update']=date("F j\\t\h Y, H:i", $gb['update']);}

$messages[$n]=$gb;

$n++;
$gbk[0]--;
}
}

$smarty->assign('messages', $messages);


include "right_strip.php";  

$smarty->display('messages.tpl');