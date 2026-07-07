<?php




$upl = mysqli_query($db,"SELECT * FROM muzx_authors WHERE muzx_authors.first_name_en='' OR muzx_authors.last_name_en='' OR muzx_authors.city_en='' OR muzx_authors.country_en='' OR
muzx_authors.years_from='0' OR muzx_authors.photo='' ORDER BY RAND() LIMIT 4 " );

while ($wan = mysqli_fetch_array($upl)) {

$z=0;
$wanted.="<A class=m href='/author.php?id=".$wan['id']."'>".$wan['nickname']."</A> ";

if ($_SESSION['language']=="rus") {
if (!$wan['first_name'] and !$wan['last_name']) {$wanted.="ФИО"; $z++;}
elseif (!$wan['first_name']) {$wanted.="имя"; $z++;}
elseif (!$wan['last_name']) {$wanted.="фамилия"; $z++;}

if (!$wan['photo']) {if ($z) {$wanted.=", ";}; $wanted.="фото"; $z++;}
if (!$wan['city']) {if ($z) {$wanted.=", ";}; $wanted.="город"; $z++;}
if (!$wan['country']) {if ($z) {$wanted.=", ";}; $wanted.="страна"; $z++;}
if (!$wan['years_from']) {if ($z) {$wanted.=", ";}; $wanted.="года активности"; $z++;}
if (!$wan['num_tracks']) {if ($z) {$wanted.=", ";}; $wanted.="треки"; $z++;}
$wanted.=". ";
}

else {
if (!$wan['first_name'] and !$wan['last_name']) {$wanted.="name, surname"; $z++;}
elseif (!$wan['first_name']) {$wanted.="name"; $z++;}
elseif (!$wan['last_name']) {$wanted.="surname"; $z++;}

if (!$wan['photo']) {if ($z) {$wanted.=", ";}; $wanted.="photo"; $z++;}
if (!$wan['city']) {if ($z) {$wanted.=", ";}; $wanted.="city"; $z++;}
if (!$wan['country']) {if ($z) {$wanted.=", ";}; $wanted.="country"; $z++;}
if (!$wan['years_from']) {if ($z) {$wanted.=", ";}; $wanted.="activity years"; $z++;}
if (!$wan['num_tracks']) {if ($z) {$wanted.=", ";}; $wanted.="tunes"; $z++;}
$wanted.=". ";
}

}

$smarty->assign('wanted', $wanted);


$a = mysqli_query($db,"SELECT nickname,id FROM muzx_authors ORDER BY views DESC LIMIT 15 " );
$n=0;
while ($t = mysqli_fetch_array($a)) {
	
	$bests[$n] = $t;
	$bests[$n]['z']=", ";
		
	$n++;
}
$n--;
$bests[$n]['z']=".";
$smarty->assign('bests', $bests);






// $z = mysqli_query($db,"SELECT muzx_songs.id,muzx_songs.filename,muzx_authors.id,muzx_authors.nickname FROM muzx_songs, muzx_songs_authors, muzx_authors WHERE muzx_songs.id = song_id AND muzx_authors.id=muzx_songs_authors.author_id AND muzx_songs.hidden!='1' ORDER BY RAND() LIMIT 5" );
// $n=0;
// while ($ss = mysqli_fetch_array($z)) {$s1[$n]=$ss; $n++;}
// $smarty->assign('rnds', $s1);








unset($g);

$zapros = mysqli_query($db,"SELECT author_id, message, user_name, guestbook.update FROM guestbook ORDER BY guestbook.update DESC LIMIT 5" );
$n=0;
while ($gb = mysqli_fetch_array($zapros)) {

$tm1=ceil(time()/86400);
$tm2=ceil(time()/172800);
if ($_SESSION['language']=="rus") {
	if (ceil($gb['update']/86400)==$tm1) {$gb['update']="сегодня ".date("H:i", $gb['update']);}
	elseif (ceil($gb['update']/86400)==$tm2) {$gb['update']="вчера ".date("H:i", $gb['update']);}
	else {$m=$amdate[date("m", $gb['update'])];
	$gb['update']=date("j $m", $gb['update']);}
	}

else {
	if (ceil($gb['update']/86400)==$tm1) {$gb['update']="today ".date("H:i", $gb['update']);}
	elseif (ceil($gb['update']/86400)==$tm2) {$gb['update']="yesterday ".date("H:i", $gb['update']);}
	else {$gb['update']=date("F j\\t\h", $gb['update']);}
	}

if (mb_strlen($gb['message'], "UTF-8")>40) {unset($t); $t=preg_split('/\s+/u', $gb['message'], 6 );
$gb['message']=$t[0]." ".$t[1]." ".$t[2]." ".$t[3]." ".$t[4]." ...";}

$g[$n]=$gb;

$n++;
}

$smarty->assign('gbs', $g);






$upl = mysqli_query($db,"SELECT log.event,log.event_id,log.update,log.misc,muzx_authors.nickname, muzx_authors.id FROM log,muzx_authors WHERE log.event_id=muzx_authors.id AND log.hidden=0 AND log.event!=2 ORDER BY log.update DESC LIMIT 5" );
$n=0;
while ($gb = mysqli_fetch_array($upl)) {


$tm1=ceil(time()/86400);
$tm2=ceil(time()/172800);
if ($_SESSION['language']=="rus") {
	if (ceil($gb['update']/86400)==$tm1) {$gb['update']="сегодня ".date("H:i", $gb['update']);}
	elseif (ceil($gb['update']/86400)==$tm2) {$gb['update']="вчера ".date("H:i", $gb['update']);}
	else {$m=$amdate[date("m", $gb['update'])];
	$gb['update']=date("j $m", $gb['update']);}
	}

else {
	if (ceil($gb['update']/86400)==$tm1) {$gb['update']="today ".date("H:i", $gb['update']);}
	elseif (ceil($gb['update']/86400)==$tm2) {$gb['update']="yesterday ".date("H:i", $gb['update']);}
	else {$gb['update']=date("F j\\t\h", $gb['update']);}
	}

if (mb_strlen($gb['message'], "UTF-8")>40) {unset($t); $t=preg_split('/\s+/u', $gb['message'], 6 );
$gb['message']=$t[0]." ".$t[1]." ".$t[2]." ".$t[3]." ".$t[4]." ...";}

$u[$n]=$gb;

$n++;
}

$smarty->assign('upd', $u);
$smarty->assign('language', $_SESSION['language']);





$z = mysqli_query($db,"SELECT COUNT(*) FROM online" );
$smarty->assign('online', mysqli_fetch_array($z));




$_SESSION['last_url']="http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];





$smarty->assign('sape_links', $sape ? $sape->return_links() : '');

$smarty->assign('test',$ts);



$v = mysqli_query($db,"SELECT * FROM last_rate, muzx_songs, muzx_authors WHERE muzx_authors.id = last_rate.id_author AND  muzx_songs.id = last_rate.id_song ORDER BY RAND() LIMIT 5");


$n=0;
while ($src = mysqli_fetch_array($v)) {

	$src['nm'] = $n+1;
	$src['id'] = $src['id_song'];

	$best[$n]=$src;
	$n++;

}

$smarty->assign('best',$best);

$smarty->assign('tkurl', geturl(0)."&");

?>
