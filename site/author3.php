<?php
require 'online.inc';

$id=$_REQUEST['id'];
$up=$_REQUEST['up'];
$ln=$_REQUEST['ln'];
$md=$_REQUEST['md'];
$order=$_REQUEST['order'];
$tnid=$_REQUEST['tnid'];
$ip=$_SERVER["REMOTE_ADDR"];
$nm = 100;

$page = $_REQUEST['page'];
if (!$page) {$page = 1;}


if (!$md) {$md=1;}
if (!$ln) {$ln="eng";}
if (!$order) {$order="year";}
if (!$up) {$up="DESC";}
if ($ln=="rus") {$lang="";} else {$lang="_en";}



function geturl($i){
  global $id,$md,$fr,$lm,$up,$order;
  $a="/author.php?id=".$id;
  if ($i) {$a.="&tnid=".$i;}
  if ($lm and $lm!=$nm) {$a.="&lm=".$lm;}
  if ($up and $up!='DESC') {$a.="&up=".$up;}
  if ($order and $order!='year') {$a.="&order=".$order;}
  return $a;
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

mysqli_query($db,"UPDATE muzx_authors SET views=views+1 WHERE id='$id' LIMIT 1 ");};}

$zapros = mysqli_query($db,"SELECT * FROM muzx_authors WHERE id='$id' ");


if (!$zapros)
	echo mysql_error();
else
{ $row1 = mysqli_fetch_array($zapros);



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
if ($f) {$smarty->assign('flag', "images/".$f);}





$zapros7 = mysqli_query($db,"SELECT * FROM group_authors, `groups` WHERE group_authors.author_id='$id' AND `groups`.id = group_authors.group_id" );
if (!$zapros7)
	echo mysql_error();
else
{ $n=0; while ($group = mysqli_fetch_array($zapros7)) {

	if ($n>0) {$grp.= ", ";};
	if ($group['status']&2) {$grp.= "<del>".$group['name']."</del>";}
	else {$grp.= $group['name'];}
	$grid[$n]['id']=$group['id'];
	$grid[$n]['name']=$group['name'];
	$n++;
}
$smarty->assign('group', $grp);
}



$m=0; $n=0;
while ($grid[$m]['id']) {$idx=$grid[$m]['id'];
$zapros8 = mysqli_query($db,"SELECT * FROM muzx_authors, group_authors WHERE group_authors.group_id='$idx' AND muzx_authors.id = group_authors.author_id" ); $m++;
if (!$zapros8)
	echo mysql_error();
else
{while ($others = mysqli_fetch_array($zapros8)) {
  
  if ($others[0]!=$id) { 


	   $oth_auth[$n]['nickname']=$others['nickname']; $oth_auth[$n]['id']=$others[0]; $n++;}
		
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



$smarty->assign('last_update', date("d.m.Y", $row1['last_update']));





if ($row1['photo']) {$smarty->assign('scr', "/photo/".$row1['id'].".jpg");} 
else {$smarty->assign('scr', "/photo/noph.png");}


}
mysqli_free_result($zapros);

if (is_file("tunes_zip/".sprintf('%08X', $row1['id']))) {
$szip=ceil(filesize("tunes_zip/".sprintf('%08X', $row1['id']))/1000);
$smarty->assign('szip', $szip);
}

$zapros8 = mysqli_query($db,"SELECT COUNT(*) FROM guestbook WHERE author_id='$id'" );
if (!$zapros8) {echo mysql_error();}
else {$gbk=mysqli_fetch_array($zapros8); $smarty->assign('gb', $gbk);
}
$zapros8 = mysqli_query($db,"SELECT COUNT(*) FROM interview WHERE author_id='$id'" );
if (!$zapros8) {echo mysql_error();}
else {$smarty->assign('intv', mysqli_fetch_array($zapros8));
}







if ($md==1) {


 


  
$ord="muzx_songs.".$order;
  
$z = mysqli_query($db,"SELECT COUNT(*) FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id AND muzx_songs.hidden!=1");
$z = mysqli_fetch_array($z);
$kl = $z[0];  
  
  
if ($page == 'all') {

$zapros = mysqli_query($db,"SELECT * FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id AND muzx_songs.hidden!=1 ORDER BY $ord $up" );

}
else {  
  
$fr = ($page-1) * $nm;  
$zapros = mysqli_query($db,"SELECT * FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id AND muzx_songs.hidden!=1 ORDER BY $ord $up LIMIT $fr, $nm " );

}

$kl2=Ceil($kl/$nm);
$smarty->assign('kl4', $kl);


	
	

for ($i = 1; $i <= $kl2; $i++) {

	$pg[$i-1] = $i;
	
}	
$smarty->assign('pages', $pg);
$smarty->assign('page', $page);





$i=$fr2+1;
$n=0; 
unset($a);
$last = 0;
while ($t = mysqli_fetch_array($zapros)) { 

	
	if ($last != $t['year']) {$t['print_year'] = 1; $last = $t['year'];}
	
	$t['name'] = htmlentities($t['name']);
	$t['nm'] = $i;
	$t['last_update'] = date('d/m/y', $t['last_update']);

	$a[$n] = $t;

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

$zapros = mysqli_query($db,"SELECT * FROM interview WHERE interview.author_id='$id'" );
if (!$zapros) {echo mysql_error();}
else
{ $smarty->assign('interview', mysqli_fetch_array($zapros));};
if (!$bot) {$zapros33 = mysqli_query($db,"UPDATE interview SET views=views+1 WHERE interview.author_id='$id'");}
echo mysql_error();

}



elseif ($md==4) {




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






$zapros = mysqli_query($db,"SELECT * FROM guestbook WHERE guestbook.author_id='$id' ORDER BY guestbook.update DESC " );
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

}

$smarty->assign('guestbook', $g);








$smarty->assign('fym_hidden', $_REQUEST['fym_hidden']);

if ($kl < 20) {$nmtrpl = 150 + $kl * 22;}
else {$nmtrpl = 600;} 
$smarty->assign('nmtrpl', $nmtrpl);


$smarty->assign('id_fym', sprintf("%04d", $id));
$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('author3.tpl');