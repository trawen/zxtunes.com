<?php
require 'online.inc';






//$smarty->debugging = true;

$order=$_REQUEST['order'];
$letter=$_REQUEST['letter'];
$up=$_REQUEST['up'];
$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$sr=$_REQUEST['sr'];
$search=$_REQUEST['search'];
$srtype=$_REQUEST['srtype'];
$srtext=strtolower($_REQUEST['srtext']);


if (!$order) {$order="nickname";}
if ($order=="num_tracks" or $order=="years_from") {$letter="ALL";}
if (!$mask) {$mask=2;}
if (!$letter) {$letter="ALL";}
if (!$up) {$up="ASC";}
if (!$fr) {$fr=1;}
if (!$lm or $lm<40) {$lm=40;}
if ($sr) {$letter="ALL";}


function geturl($i){
  global $id,$fr,$lm,$up,$order,$letter,$sr;
  $a="/authors_list.php?";
  if ($fr and $fr!=1) {$a.="&fr=".$fr;}
  if ($lm and $lm!=40) {$a.="&lm=".$lm;}
  if ($up and $up!='ASC') {$a.="&up=".$up;}
  if ($sr) {$a.="&sr=".$sr;}
  if ($letter and $letter!="ALL") {$a.="&letter=".$letter;}
  if ($order and $order!="nickname") {$a.="&order=".$order;}
  return $a;
}


$fr2=($fr-1)*40;



$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/authors_list.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$ord);



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

$tb[0]="ник";
$tb[1]="имя";
$tb[2]="фамилия";
$tb[3]="группа";
$tb[4]="треки";
$tb[5]="активность ";
$tb[6]="город";
$tb[7]="страна";

$au['nickname']="никам";
$au['first_name']="именам";
$au['last_name']="фамилиям";
$au['group_name']="группам";
$au['num_tracks']="количеству треков";
$au['years_from']="годам активности";
$au['city']="городам";
$au['country']="странам";
$au['interview']="интервью";
$au['photo']="фото";
$au['contact']="контактами";
$au['views']="количеству просмотров";

$smarty->assign('au', "Музыканты");
$smarty->assign('per', "по");
if ($order=="interview" or $order=="photo" or $order=="contact" ) {$smarty->assign('per', "с");}

$smarty->assign('kl1', "показано");
$smarty->assign('kl3', "из");
$all="ВСЕ";

$smarty->assign('title', "Музыканты по ".$au[$order]);
}
else {

$lang="_en";
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
		 
$tb[0]="nickname";
$tb[1]="fr. name";
$tb[2]="ls. name";
$tb[3]="group";
$tb[4]="tunes";
$tb[5]="activity";
$tb[6]="city";
$tb[7]="country";

$au['nickname']="nicknames";
$au['first_name']="first names";
$au['last_name']="last names";
$au['group_name']="groups";
$au['num_tracks']="tunes";
$au['years_from']="activities";
$au['city']="cities";
$au['country']="countries";
$au['interview']="inteviews";
$au['photo']="photos";
$au['contact']="contacts";
$au['views']="views";
		 
$smarty->assign('au', "Musicians");
$smarty->assign('per', "by");

$smarty->assign('kl1', "musicians");
$smarty->assign('kl3', "from");
$all="ALL";

$smarty->assign('title', "Musicians by ".$au[$order]);
}
		 
$smarty->assign('srt', $au[$order]);

		 
$smarty->assign('active', array('authors' => 'class=active'));
		 
$smarty->compile_check = true;






// if ($search=="search" and strlen($srtext)>=2 and strlen($srtext)<20) {

	 // $v = mysqli_query($db,"SELECT * FROM muzx_authors WHERE nickname LIKE '%$srtext%' OR also1 LIKE '%$srtext%' OR also2 LIKE '%$srtext%' OR also3 LIKE '%$srtext%' OR also4 LIKE '%$srtext%' OR also5 LIKE '%$srtext%'" );
	 
// if (!$v) {echo mysql_error();}
// else { $klp=0; $n=0;
// while ($src = mysqli_fetch_array($v)) {
// $srsr[0]=$src['id'];
// if ($srtext==strtolower($src['nickname']) or $srtext==strtolower($src['also1']) or $srtext==strtolower($src['also2']) or $srtext==strtolower($src['also3']) or $srtext==strtolower($src['also4']) or $srtext==strtolower($src['also5'])) {$klp++; $idsr=$src['id'];}
// }
// }
// if ($klp==1) {   header("Location: http://".$_SERVER['SERVER_NAME']."/author_profile.php?id=".$idsr."?ln=".$ln);
// exit;	


// } 


// }






$z = mysqli_query($db,"SELECT * FROM muzx_authors ORDER BY last_update DESC");

while ($t = mysqli_fetch_array($z)) {
	
	$id = $t['id'];
	$zx = mysqli_query($db,"SELECT COUNT(*) FROM guestbook WHERE author_id=$id" );
	$kl = mysqli_fetch_array($zx);
	//echo "<a href='author.php?id=".$t['id']."'>".$kl[0]."</a><br>";
	if ($kl[0] == 0) {
	echo "/author.php?id=".$t['id']."&md=4<br>";
	}
	$n++;

}





?>