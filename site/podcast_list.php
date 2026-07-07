<?php
require 'ini.php';




function geturl($i){
  $a="/podcast_list.php?";
  return $a;
}


$smarty->assign('active', array('podcasts' => 'class=active'));

$smarty->compile_check = true;
//$smarty->debugging = true;

$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];

$order=$_REQUEST['order'];

$mode[$md]="class=selected";
$smarty->assign('id',$id);
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/podcast_list.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$order);




if ($_SESSION['language']=="rus") {

$smarty->assign('title', 'Подкасты');

$tb[1]="название";
$tb[2]="содержание";
$tb[3]="дата";
$tb[4]="скачан";

}
else {
		 
$smarty->assign('title', 'Podcasts');
		 
$tb[1]="title";
$tb[2]="content";
$tb[3]="date";
$tb[4]="dwns";

}

$tb_title[0]['link']="№";

$tb_title[1]['link']="<a class='mb' href='?order=title&lm=".$lm."&fr=".$fr."&up=";
if ($order=="title" and $up=="ASC") {$tb_title[1]['link'].="DESC'>$tb[1]</a> <b>&#62</b>";} elseif ($order=="title" and $up=="DESC") {$tb_title[1]['link'].="ASC'>$tb[1]</a> <b>&#60</b>";} else {$tb_title[1]['link'].="ASC'>$tb[1]</a>";}

$tb_title[2]['link']="<b>".$tb[2]."</b>";

$tb_title[3]['link']="<a class='mb' href='?order=release_date&lm=".$lm."&fr=".$fr."&up=";
if ($order=="release_date" and $up=="ASC") {$tb_title[3]['link'].="DESC'>$tb[3]</a> <b>&#62</b>";} elseif ($order=="release_date" and $up=="DESC") {$tb_title[3]['link'].="ASC'>$tb[3]</a> <b>&#60</b>";} else {$tb_title[3]['link'].="ASC'>$tb[3]</a>";}

$tb_title[4]['link']="<a class='mb' href='?order=downloads&lm=".$lm."&fr=".$fr."&up=";
if ($order=="downloads" and $up=="ASC") {$tb_title[4]['link'].="DESC'>$tb[4]</a> <b>&#62</b>";} elseif ($order=="downloads" and $up=="DESC") {$tb_title[4]['link'].="ASC'>$tb[4]</a> <b>&#60</b>";} else {$tb_title[4]['link'].="ASC'>$tb[4]</a>";}

$smarty->assign('tb_title', $tb_title);



if (!$fr) {$fr=1;}
if (!$order) {$order="release_date";}
if (!$up) {$up="DESC";}
if (!$lm or $lm<40) {$lm=40;}

$fr2=($fr-1)*40;




$z = mysqli_query($db,"SELECT COUNT(*) FROM podcast $where" );

$kl=mysqli_fetch_array($z);
$kl=$kl[0];

$kl2=Ceil($kl/40);



// PAGES

	for ($i = 1; $i <= $kl2; $i++) {
		if ($fr==$i and $lm==40) {$pages.= "<span class='Page'>$i</span>";
		} else {$pages.= "<a class='Page' href='?lm=40&fr=$i&order=$order&up=$up'>$i</a> ";}
	}
	if ($lm>40) {$pages.= " <span class='Page'>$all</span>";} else {$pages.= "<a class='Page' href='?order=$order&lm=$kl&fr=1&up=$up'>$all</a>";}


$smarty->assign('kl4', $kl);
$smarty->assign('pages', $pages);	




$z = mysqli_query($db,"SELECT * FROM podcast ORDER BY $order $up LIMIT $fr2, $lm" );

$n=0;
$i=$fr2+1;
if (!$z) {echo mysql_error();}
else
{ while ($f = mysqli_fetch_array($z)) { 
	
	
$tbtx[$n][0]=$i;

$tbtx[$n][1]="<a class='m' href='/downloads.php?id=".$f['id']."&md=podcast'>".$f['title_rus']."</a>";

$tbtx[$n]['sample_rus']=$f['sample_rus'];
$tbtx[$n]['sample_eng']=$f['sample_eng'];
$tbtx[$n][3]=date('d M y', $f['release_date']);
$tbtx[$n][4]=$f['downloads'];
$tbtx[$n]['script'] = $f['player'];
$tbtx[$n]['id'] = $f['id'];

$n++; $i++;
}

}
$smarty->assign('tbtx', $tbtx);
$smarty->assign('kl2', $n);


include "right_strip.php";  

$smarty->display('podcast_list.tpl');

