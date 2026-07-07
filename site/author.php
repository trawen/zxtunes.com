<?php

require 'ini.php';

$interview = (int) ($_REQUEST['interview'] ?? 0);
$play=$_REQUEST['play'];
$id=intval($_REQUEST['id']);
$up=$_REQUEST['up'];
$ln=$_REQUEST['ln'];
$md=$_REQUEST['md'];
$order=$_REQUEST['order'];
$tnid=$_REQUEST['tnid'];
$ip=$_SERVER["REMOTE_ADDR"];
$nm = 100;



$sort = $_REQUEST['sort'];
$smarty->assign('sort', $sort);


$page = $_REQUEST['page'];
if (!$page) {$page = 1;}


if (!$md) {$md=1;}
if (!$ln) {$ln="eng";}
$order = zxtunes_song_order((string) ($order ?? ''));
if (!$up) {$up="DESC";}
$up = zxtunes_sort_dir($up);
if ($ln=="rus") {$lang="";} else {$lang="_en";}

function goodname($name) {

	return rawurlencode(strtolower($name));

}

function geturl($i){
  global $id,$md,$fr,$lm,$up,$order;
  $a="/author.php?id=".$id;
  if ($i) {$a.="&tnid=".$i;}
  if ($lm and $lm!=$nm) {$a.="&lm=".$lm;}
  if ($up and $up!='DESC') {$a.="&up=".$up;}
  if ($order and $order!='year') {$a.="&order=".$order;}
  return $a;
}







$message = strip_tags(mysqli_real_escape_string($db,$_REQUEST['message']));
$name    = strip_tags(mysqli_real_escape_string($db,$_REQUEST['name']));
$email   = mysqli_real_escape_string($db,$_REQUEST['email']);
$submit  = $_REQUEST['submit'];
$tm = time(); 





if ($id and ( $submit=="Submit" or $submit=="Отправить" )) {

	csrf_verify();

	db_execute(
		'INSERT INTO guestbook (author_id, message, user_name, user_email, `update`, ip) VALUES (?, ?, ?, ?, ?, ?)',
		'isssis',
		[$id, $message, $name, $email, $tm, $ip]
	);
	
	header("Location: /author.php?id=$id&md=4");
	exit;	
	
}








$smarty->compile_check = true;
$smarty->assign('active', array('authors' => 'class=active'));

//$smarty->debugging = true;

$mode[$md]="class=selected";
$smarty->assign('id',$id);
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/author.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$ord);






$smarty->assign('author_id', $id);




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
$tb[5]="dwns";
$tb[6]="rating";

		 
$smarty->assign('au', "Authors");
$smarty->assign('per', "by");

$smarty->assign('kl1', "authors");
$smarty->assign('kl3', "from");
$all="ALL";
}













if (!$bot) {if (!strpos ($_SESSION['last_url'], "id=".$id)) {
db_execute('UPDATE muzx_authors SET views=views+1 WHERE id=? LIMIT 1', 'i', [$id]);
};}

$row1 = db_fetch_one('SELECT * FROM muzx_authors WHERE id=? LIMIT 1', 'i', [$id]);



if (!$row1)
	echo 'Author not found';
else
{ 

$row1['goodname'] = goodname($row1['nickname']);


if ($_SESSION['language']=="rus") {if ($row1['first_name'] or $row1['last_name']) 
   {$t=$row1['first_name']." ".$row1['last_name'];}}
else {if ($row1['first_name_en'] or $row1['last_name_en']) 
   {$t=$row1['first_name_en']." ".$row1['last_name_en'];}
}

$t=$row1['nickname']." (".$t.")";
if ($md==1) {if ($_SESSION['language']=="rus") {$t.=" - треки";} else {$t.=" - tunes";};}
elseif ($md==2) {if ($_SESSION['language']=="rus") {$t.=" - альбомы";} else {$t.=" - albums";};}
elseif ($md==3) {if ($_SESSION['language']=="rus") {$t.=" - интервью";} else {$t.=" - interviews";};}
elseif ($md==4) {if ($_SESSION['language']=="rus") {$t.=" - гостевая";} else {$t.=" - guestbook";};}
$smarty->assign('title', $t);


if ($row1['dead']) {$row1['dead'] = dt($row1['dead']);}



$smarty->assign('author', $row1);
$f="";
switch (strtolower($row1['country_en']))
		{case 'russia': $f= "ru"; break; 
		 case 'belarus': $f= "by"; break; 
		 case 'ukraine': $f= "ua"; break;
		 case 'england': $f= "en"; break; 
		 case 'poland': $f= "pl"; break; 
		 case 'slovakia': $f= "sk"; break; 
		 case 'united kingdom': $f= "uk"; break; 
		 case 'czech': $f= "cz"; break; 
		 case 'latvia': $f= "lv"; break; 
		 case 'litva': $f= "lt"; break; 
		 case 'germany': $f= "de"; break; 
		 case 'spain': $f= "sp"; break; 
		 case 'kazakhstan': $f= "kz"; break; 
		 case 'finland': $f= "fn"; break; 
		 case 'france': $f= "fr"; break;
		 case 'usa': $f= "us"; break;
		 case 'northern ireland': $f= "ne"; break;
		 case 'sweden': $f= "se"; break;
		 case 'scotland': $f= "sc"; break;
		 case 'estonia': $f= "es"; break; 
		 } 
if ($f) {$smarty->assign('flag', "images/$f.png");}





$groups = db_fetch_all(
	'SELECT group_authors.*, `groups`.name, `groups`.id AS gid FROM group_authors JOIN `groups` ON `groups`.id = group_authors.group_id WHERE group_authors.author_id=?',
	'i',
	[$id]
);
if ($groups) {
	$n=0;
	foreach ($groups as $group) {
		if ($n>0) {$grp.= ", ";};
		if ($group['status']&2) {$grp.= "<del>".h($group['name'])."</del>";}
		else {$grp.= h($group['name']);}
		$grid[$n]['id']=$group['gid'];
		$grid[$n]['name']=$group['name'];
		$n++;
	}
$smarty->assign('group', $grp);
}





$m=0; 
$n=0;

while ($grid[$m]['id']) {

	$idx = (int) $grid[$m]['id'];
	
	$others_rows = db_fetch_all(
		'SELECT muzx_authors.* FROM muzx_authors JOIN group_authors ON muzx_authors.id = group_authors.author_id WHERE group_authors.group_id=?',
		'i',
		[$idx]
	);

	$m++; 
	
	
foreach ($others_rows as $others) {
  
	if ($others['id']!=$id) { 

	   $oth_auth[$n]['nickname']=$others['nickname']; $oth_auth[$n]['id']=$others['id']; $n++;
	
	}
		
}
}







$z=0;
for ($i=0; $i<$n; $i++) {$f=0; for ($x=0; $x<=$i; $x++) {if ($oth_auth[$i]['id']==$oth_auth2[$x]['id']) {$f++;}}
if (!$f) { $oth_auth2[$z]['id']=$oth_auth[$i]['id']; $oth_auth2[$z]['nickname']=$oth_auth[$i]['nickname']; $z++;}
}

for ($i=0; $i<$z; $i++) {if ($i>0) {$other.=", ";}
$other.="<a href='author.php?id=".$oth_auth2[$i]['id']."'>".$oth_auth2[$i]['nickname']."</a>";}

$smarty->assign('others', $other);









if ($row1['city'] or $row1['city_en']) {
if ($ln=="rus") {$smarty->assign('city', "<a href='/authors_list.php?mask=2&letter=ALL&order=city&up=ASC&sr=".$row1['city']."'>".$row1['city']."</a>");} 
else {$smarty->assign('city', "<a href='/authors_list.php?mask=2&letter=ALL&order=city&up=ASC&sr=".$row1['city_en']."'>".$row1['city_en']."</a>");}}



if ($row1['country'] or $row1['country_en']) {
if ($ln=="rus") {$smarty->assign('country', "<a href='/authors_list.php?mask=2&letter=ALL&order=country&up=ASC&sr=".$row1['country']."'>".$row1['country']."</a>");} 
else {$smarty->assign('country', "<a href='/authors_list.php?mask=2&letter=ALL&order=country&up=ASC&sr=".$row1['country_en']."'>".$row1['country_en']."</a>");}}


$m = $amdate[date("m", $row1['last_update'])];
$smarty->assign('last_update', date("d", $row1['last_update']) ." $m ".date("Y", $row1['last_update']));




}











if (is_file("tunes_zip/".sprintf('%08X', $row1['id']))) {
$szip=ceil(filesize("tunes_zip/".sprintf('%08X', $row1['id']))/1000);
$smarty->assign('szip', $szip);
}

$gbk = db_fetch_one('SELECT COUNT(*) AS cnt FROM guestbook WHERE author_id=?', 'i', [$id]);
$gbk = ['cnt' => (int) ($gbk['cnt'] ?? 0), 0 => (int) ($gbk['cnt'] ?? 0)];
$smarty->assign('gb', $gbk);
$nm_interview = db_fetch_one('SELECT COUNT(*) AS cnt FROM interview WHERE int_author_id=?', 'i', [$id]);
if ($nm_interview) {$smarty->assign('intv', ['COUNT(*)' => $nm_interview['cnt'], 0 => $nm_interview['cnt']]);}




if ($md==1) {



 

  
$sort = zxtunes_whitelist((string) ($sort ?? ''), ['rating', 'playing', 'year'], 'year');
if ($sort === 'rating') {$ord = 'muzx_songs.rating';}
elseif ($sort === 'playing') {$ord = 'muzx_songs.downloads';}
else {$ord = 'muzx_songs.year';}

$count_row = db_fetch_one(
	'SELECT COUNT(*) AS cnt FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? AND muzx_songs.hidden!=1',
	'i',
	[$id]
);
$kl = (int) ($count_row['cnt'] ?? 0);

$song_rows = db_fetch_all(
	"SELECT muzx_songs.*, muzx_songs_authors.author_id FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? AND muzx_songs.hidden!=1 ORDER BY $ord DESC, muzx_songs.filename ASC",
	'i',
	[$id]
);






$i=$fr2+1;
$n=0; 
unset($a);
$last = 0;
foreach ($song_rows as $t) { 

	
	if ($last != $t['year']) {$t['print_year'] = 1; $last = $t['year'];}
	
	$t['name'] = htmlentities($t['name']);
	$s = ceil($t['time']/50);
	$sec = sprintf("%02d", $s - ((intval($s/60)) * 60));
	$min = intval($s/60);
	$t['time'] = $min.":".$sec;
	$t['nm'] = $i;
	$t['last_update'] = date('d.m.Y', $t['last_update']);
	$ri = $t['id'];
	if ($_REQUEST['rt'.$ri]) {$t['rt'] = "r_off";} else {$t['rt'] = "rating";}
	
	$a[$n] = $t;

	if ($t['id'] == $_REQUEST['play']) {

		$autoplay_title = $row1['nickname']." - ".$t['filename'];
		if ($t['name']) { $autoplay_title.= " - ".$t['name'];}
		$smarty->assign('autoplay_title', $autoplay_title);
		
	}
	
	$i++;
	$n++;
	
}

for($x=0; $x<$n; $x++) {

    $a[$x]['next_id'] = $a[$x+1]['id'];
	$a[$x]['prev_id'] = $a[$x-1]['id'];
	
}
$a[0]['prev_id'] = $a[$n-1]['id'];
$a[$n-1]['next_id'] = $a[0]['id'];

$smarty->assign('playlist', $a);





$smarty->assign('kl2', $n);

}
elseif ($md==3) {


if ($interview) {
	$intv = db_fetch_one('SELECT * FROM interview WHERE int_id=? AND int_author_id=? LIMIT 1', 'ii', [$interview, $id]);
}
else {	
	$intv = db_fetch_one('SELECT * FROM interview WHERE int_author_id=? LIMIT 1', 'i', [$id]);
}

	if ($intv) {
		$smarty->assign('interview', $intv);
		if (!$bot) {db_execute('UPDATE interview SET int_views=int_views+1 WHERE int_author_id=?', 'i', [$id]);}
	}
		
	
	if (($nm_interview['cnt'] ?? $nm_interview[0] ?? 0) > 1) {

		$first = $intv['int_id'];
		$in = db_fetch_all(
			'SELECT int_id, int_author_id, int_title FROM interview WHERE int_author_id=? AND int_id!=?',
			'ii',
			[$id, (int) $first]
		);
		$smarty->assign('all_interview', $in);
	}
	
}
elseif ($md==4) {








$gb_rows = db_fetch_all('SELECT * FROM guestbook WHERE author_id=? ORDER BY `update` DESC', 'i', [$id]);
$n=0;
foreach ($gb_rows as $gb) {

$gb['nm']=$gbk[0];
if ($_SESSION['language']=="rus") {$m=$amdate[date("m", $gb['update'])]; echo "";
$gb['update']=date("j $m Y", $gb['update']);}

else {$gb['update']=date("F j\\t\h Y", $gb['update']);}
$g[$n]=$gb;

$n++;
$gbk[0]--;
}

$smarty->assign('guestbook', $g);
}

$smarty->assign('autoplay', $_REQUEST['play']);

$smarty->assign('fym_hidden', $_REQUEST['fym_hidden']);

if ($kl < 20) {$nmtrpl = 150 + $kl * 22;}
else {$nmtrpl = 600;} 
$smarty->assign('nmtrpl', $nmtrpl);


$smarty->assign('id_fym', sprintf("%04d", $id));
$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('author5.tpl');
?>