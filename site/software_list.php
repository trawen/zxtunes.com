<?php
require 'ini.php';



function geturl($i){
  $a="/software_list.php?";
  return $a;
}




//$smarty->debugging = true;
$smarty->compile_check = true;



$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];
$md=$_REQUEST['md'];
if ($md=="") {$md=1;}
$order=$_REQUEST['order'];

$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/software_list.php?fr=".$fr."&lm=".$lm."&up=".$up."&order=".$order);




if ($_SESSION['language']=="rus") {

$smarty->assign('mmenu',
    array('news' => 'новости',
          'soft' => 'софт',
          'hard' => 'железо',
		  'articles' => 'статьи',
          'stats' => 'статистика',
          'forum' => 'форум',
          'music' => 'музыка',
          'authors' => 'авторская',
		  'games' => 'игровая',
          'demos' => 'демошная',
          'press' => 'из прессы',
          'party' => 'с патей',
          'remixes' => 'ремиксы'
		  )
         );
		 
		 
$tb[1]="название";
$tb[2]="автор";
$tb[3]="год";
$tb[4]="обновление";
$tb[5]="платформа";
$tb[6]="звук";


$all="ВСЕ";
		 
$smarty->assign('title', 'Софт: редакторы, проигрыватели, утилиты');
}
else {
$smarty->assign('mmenu',
    array('news' => 'news',
          'soft' => 'software',
          'hard' => 'hardware',
		  'articles' => 'articles',
          'stats' => 'statistics',
          'forum' => 'forum',
          'music' => 'music',
          'authors' => 'authors',
		  'games' => 'games',
          'demos' => 'demos',
          'press' => 'press',
          'party' => 'parties',
          'remixes' => 'remixes'
		  )
         );

$tb[1]="title";
$tb[2]="author";
$tb[3]="year";
$tb[4]="update";
$tb[5]="platform";
$tb[6]="sound";

$all="ALL";
		 
$smarty->assign('title', 'Software: editors, players, utilities');
}
		 
$smarty->assign('data',array(1,2,3,4,5,6,7,8,9));
$smarty->assign('tr',array('bgcolor="#eeeeee"','bgcolor="#dddddd"'));
		 
$smarty->assign('active', array('soft' => 'class=active'));
		 
$smarty->compile_check = true;





$from="software";
$ord_def=0;


$pl[1]="zx";
$pl[2]="pc";


$sn[0]="ay";
$sn[1]="beeper";
$sn[2]="digital";
$sn[3]="all";



if (!$md) {$md=0;}
if (!$fr) {$fr=1;}
if (!$order) {$order="title";}
if (!$up) {$up="ASC";}
if (!$lm or $lm<40) {$lm=40;}

$fr2=($fr-1)*40;


$where= $md ? "WHERE type='".$md."'" : "";


$z = mysqli_query($db,"SELECT COUNT(*) FROM $from $where" );
echo mysql_error();

$kl=mysqli_fetch_array($z);
$kl=$kl[0];

$kl2=Ceil($kl/40);



// PAGES

	for ($i = 1; $i <= $kl2; $i++) {
		if ($fr==$i and $lm==40) {$pages.= "<span class='Page'>".$i."</span>";
		} else {$pages.= "<a class='Page' href='?id=".$id."&lm=40&fr=".$i."&order=".$order."&up=".$up."&md=".$md."'>".$i."</a> ";}
	}
	if ($lm>40) {$pages.= " <span class='Page'>$all</span>";} else {$pages.= "<a class='Page' href='?id=".$id."&order=".$order."&lm=".$kl."&fr=1&md=".$md."&up=".$up."'>$all</a>";}


$smarty->assign('kl4', $kl);
$smarty->assign('pages', $pages);	
	







$tb_title[0]['link']="№";

$tb_title[1]['link']="<a class='mb' href='?id=".$id."&order=title&lm=".$lm."&fr=".$fr."&up=";
if ($order=="title" and $up=="ASC") {$tb_title[1]['link'].="DESC&md=".$md."'>$tb[1]</a> <b>&#62</b>";} elseif ($order=="title" and $up=="DESC") {$tb_title[1]['link'].="ASC&md=".$md."'>$tb[1]</a> <b>&#60</b>";} else {$tb_title[1]['link'].="ASC&md=".$md."'>$tb[1]</a>";}


$tb_title[2]['link']="<a class='mb' href='?id=".$id."&order=author&lm=".$lm."&fr=".$fr."&up=";
if ($order=="author" and $up=="ASC") {$tb_title[2]['link'].="DESC&md=".$md."'>$tb[2]</a> <b>&#62</b>";} elseif ($order=="author" and $up=="DESC") {$tb_title[2]['link'].="ASC&md=".$md."'>$tb[2]</a> <b>&#60</b>";} else {$tb_title[2]['link'].="ASC&md=".$md."'>$tb[2]</a>";}


$tb_title[3]['link']="<a class='mb' href='?id=".$id."&order=year&lm=".$lm."&fr=".$fr."&up=";
if ($order=="year" and $up=="ASC") {$tb_title[3]['link'].="DESC&md=".$md."'>$tb[3]</a> <b>&#62</b>";} elseif ($order=="year" and $up=="DESC") {$tb_title[3]['link'].="ASC&md=".$md."'>$tb[3]</a> <b>&#60</b>";} else {$tb_title[3]['link'].="ASC&md=".$md."'>$tb[3]</a>";}


$tb_title[4]['link']="<a class='mb' href='?id=".$id."&order=update_&lm=".$lm."&fr=".$fr."&up=";
if ($order=="update_" and $up=="ASC") {$tb_title[4]['link'].="DESC&md=".$md."'>$tb[4]</a> <b>&#62</b>";} elseif ($order=="update_" and $up=="DESC") {$tb_title[4]['link'].="ASC&md=".$md."'>$tb[4]</a> <b>&#60</b>";} else {$tb_title[4]['link'].="ASC&md=".$md."'>$tb[4]</a>";}


$tb_title[5]['link']="<a class='mb' href='?id=".$id."&order=platform&lm=".$lm."&fr=".$fr."&up=";
if ($order=="platform" and $up=="ASC") {$tb_title[5]['link'].="DESC&md=".$md."'>$tb[5]</a> <b>&#62</b>";} elseif ($order=="platform" and $up=="DESC") {$tb_title[5]['link'].="ASC&md=".$md."'>$tb[5]</a> <b>&#60</b>";} else {$tb_title[5]['link'].="ASC&md=".$md."'>$tb[5]</a>";}


$tb_title[6]['link']="<a class='mb' href='?id=".$id."&order=sound&lm=".$lm."&fr=".$fr."&up=";
if ($order=="sound" and $up=="ASC") {$tb_title[6]['link'].="DESC&md=".$md."'>$tb[6]</a> <b>&#62</b>";} elseif ($order=="sound" and $up=="DESC") {$tb_title[6]['link'].="ASC&md=".$md."'>$tb[6]</a> <b>&#60</b>";} else {$tb_title[6]['link'].="ASC&md=".$md."'>$tb[6]</a>";}

$smarty->assign('tb_title', $tb_title);








$z = mysqli_query($db,"SELECT * FROM $from $where ORDER BY $order $up LIMIT $fr2, $lm" );
echo mysql_error();

//echo "#".$from."#".$where."#".$order."#".$up."#".$fr2."#".$lm;

$n=0;
$i=$fr2+1;
if (!$z) {echo mysql_error();}
else
{ while ($f = mysqli_fetch_array($z)) { 
	
$tbtx[$n][0]=$i;

$t=$f['title'];
if ($f['version']) {$t.=" ".$f['version'];}
$tbtx[$n][1]="<a class='m' href='/software.php?id=".$f['id']."'>".$t."</a>";

$tbtx[$n][2]=$f['author'];
$tbtx[$n][3]=$f['year'];
$tbtx[$n][4]=date('d.m.y', $f['update_']);
$tbtx[$n][5]=$pl[$f['platform']];
$tbtx[$n][6]=$sn[$f['sound']];
	

$n++; $i++;
}

}
$smarty->assign('tbtx', $tbtx);
$smarty->assign('kl2', $n);

















include "right_strip.php";  

$smarty->display('software_list.tpl');

