<?php
require 'ini.php';


//error_reporting(E_ALL);

function geturl($i){
  $a="/remix_mp3.php?";
  return $a;
}


$smarty->assign('active', array('remix_mp3' => 'class=active'));

$smarty->compile_check = true;
//$smarty->debugging = true;

$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];
$md=$_REQUEST['md'];
if ($md=="") {$md=0;}
$order=$_REQUEST['order'];

$mode[$md]="class=selected";
$smarty->assign('id',$id);
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/remix_mp3.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$order);





if ($_SESSION['language']=="rus") {

$smarty->assign('title', 'Ремиксы в MP3 формате');


}
else {
		 
$smarty->assign('title', 'MP3 Remixes');
		 

}









if (!$md) {$md=0;}
if (!$fr) {$fr=1;}
if (!$order) {$order="title";}
if (!$up) {$up="ASC";}
if (!$lm or $lm<40) {$lm=40;}

$fr2=($fr-1)*40;


$where= $md ? "WHERE type='".$md."'" : "";

$from="remix_mp3";

$z = mysqli_query($db,"SELECT COUNT(*) FROM $from $where" );
echo mysql_error();

$kl=mysqli_fetch_array($z);
$kl=$kl[0];

$kl2=Ceil($kl/40);



// PAGES

	for ($i = 1; $i <= $kl2; $i++) {
		if ($fr==$i and $lm==40) {$pages.= "<span class='Page'>$i</span>";
		} else {$pages.= "<a class='Page' href='?lm=40&fr=$i&order=$order&up=$up&md=$md'>$i</a> ";}
	}
	if ($lm>40) {$pages.= " <span class='Page'>$all</span>";} else {$pages.= "<a class='Page' href='?order=$order&lm=$kl&fr=1&up=$up&md=$md'>$all</a>";}


$smarty->assign('kl4', $kl);
$smarty->assign('pages', $pages);	
	







$tb_title[0]['link']="№";

$tb_title[1]['link']="<a href='?order=title&lm=".$lm."&fr=".$fr."&up=";
if ($order=="title" and $up=="ASC") {$tb_title[1]['link'].="DESC'>$tb[1]</a> <b>&#62</b>";} elseif ($order=="title" and $up=="DESC") {$tb_title[1]['link'].="ASC'>$tb[1]</a> <b>&#60</b>";} else {$tb_title[1]['link'].="ASC'>$tb[1]</a>";}

$tb_title[2]['link']="<a class='mb' href='?order=author&lm=".$lm."&fr=".$fr."&up=";
if ($order=="author" and $up=="ASC") {$tb_title[2]['link'].="DESC'>$tb[2]</a> <b>&#62</b>";} elseif ($order=="author" and $up=="DESC") {$tb_title[2]['link'].="ASC'>$tb[2]</a> <b>&#60</b>";} else {$tb_title[2]['link'].="ASC'>$tb[2]</a>";}

$tb_title[3]['link']="<a class='mb' href='?order=composer_name&lm=".$lm."&fr=".$fr."&up=";
if ($order=="composer_name" and $up=="ASC") {$tb_title[3]['link'].="DESC'>$tb[3]</a> <b>&#62</b>";} elseif ($order=="composer_name" and $up=="DESC") {$tb_title[3]['link'].="ASC'>$tb[3]</a> <b>&#60</b>";} else {$tb_title[3]['link'].="ASC'>$tb[3]</a>";}

$tb_title[4]['link']="<a class='mb' href='?order=year&lm=".$lm."&fr=".$fr."&up=";
if ($order=="year" and $up=="ASC") {$tb_title[4]['link'].="DESC'>$tb[4]</a> <b>&#62</b>";} elseif ($order=="year" and $up=="DESC") {$tb_title[4]['link'].="ASC'>$tb[4]</a> <b>&#60</b>";} else {$tb_title[4]['link'].="ASC'>$tb[4]</a>";}

$tb_title[5]['link']="<a class='mb' href='?order=comment&lm=".$lm."&fr=".$fr."&up=";
if ($order=="comment" and $up=="ASC") {$tb_title[5]['link'].="DESC'>$tb[5]</a> <b>&#62</b>";} elseif ($order=="comment" and $up=="DESC") {$tb_title[5]['link'].="ASC'>$tb[5]</a> <b>&#60</b>";} else {$tb_title[5]['link'].="ASC'>$tb[5]</a>";}

$tb_title[6]['link']="<a class='mb' href='?order=upd&lm=".$lm."&fr=".$fr."&up=";
if ($order=="upd" and $up=="ASC") {$tb_title[6]['link'].="DESC'>$tb[6]</a> <b>&#62</b>";} elseif ($order=="update" and $up=="DESC") {$tb_title[6]['link'].="ASC'>$tb[6]</a> <b>&#60</b>";} else {$tb_title[6]['link'].="ASC'>$tb[6]</a>";}

$tb_title[7]['link']="<a class='mb' href='?order=downloads&lm=".$lm."&fr=".$fr."&up=";
if ($order=="downloads" and $up=="ASC") {$tb_title[7]['link'].="DESC'>$tb[7]</a> <b>&#62</b>";} elseif ($order=="downloads" and $up=="DESC") {$tb_title[7]['link'].="ASC'>$tb[7]</a> <b>&#60</b>";} else {$tb_title[7]['link'].="ASC'>$tb[7]</a>";}

$smarty->assign('tb_title', $tb_title);








$z = mysqli_query($db,"SELECT * FROM $from $where ORDER BY $order $up LIMIT $fr2, $lm" );
//echo mysql_error();

$n=0;
while ($f = mysqli_fetch_array($z)) { 
	
	//$tbtx[$n][6]=date('d.m.y', $f['upd']);

	$rm[$n] = $f;

	$n++;
}


$smarty->assign('remixes', $rm);
$smarty->assign('kl2', $n);




include "right_strip.php";  

$smarty->display('remix_mp3.tpl');

