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


function geturl($i){
  $a="/stats.php?";
  return $a;
}


$smarty->compile_check = true;
$smarty->assign('active', array('stats' => 'class=active'));

//$smarty->debugging = true;

$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/stats.php");



if ($_SESSION['language']=="rus") {
$smarty->assign('title',"Статистика");
}
else {
$smarty->assign('title',"Statistics");
}


$snd[1]="Sound Tracker";
$snd[2]="Sound Tracker Pro";
$snd[3]="Global Tracker";
$snd[4]="Fast Tracker";
$snd[5]="Pro Sound Maker";
$snd[6]="Pro Sound Creator";
$snd[7]="Pro Tracker 2.x";
$snd[8]="Pro Tracker 3.x";
$snd[9]='Unknown ("ay")';
$snd[10]='Unknown ("vtx")';
$snd[11]="SQ-Tracker";
$snd[12]="Asc Sound Master";
$snd[13]="Pro Tracker 1.x";
$snd[14]="Flash Tracker";
$snd[15]="Fuxoft AY";

$lns[1]=24;
$lns[2]=1;
$lns[4]=8;
$lns[5]=6;
$lns[6]=5;
$lns[7]=37;
$lns[8]=4;
$lns[11]=2;
$lns[12]=13;
$lns[13]=3;



$i=0;
$type_rows = db_fetch_all(
	'SELECT DISTINCT type, COUNT(*) AS kl FROM muzx_songs WHERE type NOT IN (0, 9, 10) GROUP BY type ORDER BY kl DESC'
);
foreach ($type_rows as $types) {
$types['lnk']=$lns[$types['type']];
$types['type']=$snd[$types['type']];

$t[$i] = $types; $i++;

}
$smarty->assign('types', $t);




$i=0;
$l = zxtunes_lang_suffix();
if ($l === '_en') {
$country_rows = db_fetch_all(
	"SELECT DISTINCT country_en, COUNT(*) AS kl FROM muzx_authors WHERE country_en!='' GROUP BY country_en ORDER BY kl DESC LIMIT 10"
);
} else {
$country_rows = db_fetch_all(
	"SELECT DISTINCT country, COUNT(*) AS kl FROM muzx_authors WHERE country!='' GROUP BY country ORDER BY kl DESC LIMIT 10"
);
}
foreach ($country_rows as $authors) {$c[$i] = $authors; $i++;}
$smarty->assign('bycountry', $c);


$i=0;
if ($l === '_en') {
$city_rows = db_fetch_all(
	"SELECT DISTINCT city_en, COUNT(*) AS kl FROM muzx_authors WHERE city_en!='' GROUP BY city_en ORDER BY kl DESC LIMIT 10"
);
} else {
$city_rows = db_fetch_all(
	"SELECT DISTINCT city, COUNT(*) AS kl FROM muzx_authors WHERE city!='' GROUP BY city ORDER BY kl DESC LIMIT 10"
);
}
foreach ($city_rows as $authors) {$c[$i] = $authors; $i++;}
$smarty->assign('bycity', $c);

// $i=0;
// $zapros = mysqli_query($db,"SELECT DISTINCT  muzx_songs_authors.author_id, COUNT(*) AS kl FROM muzx_songs_authors GROUP BY author_id  ORDER BY kl DESC" );
// if (!$zapros) {echo mysql_error();}
// else
// { while ($songs=mysqli_fetch_array($zapros)) {
// $id=$songs['author_id'];
// $zapros5 = mysqli_query($db,"SELECT * FROM muzx_authors WHERE id='$id' ");
// if (!$zapros5) {echo mysql_error();} else {$auth=mysqli_fetch_array($zapros5);
// $author[$i]= "<a href='/author_profile.php?id=".$id."&ln=".$ln."'>".$auth['nickname']."</a>: ".$songs[1]."<br>";
// $i++;
// }
// }
// }


$i=0;
$auth_rows = db_fetch_all('SELECT * FROM muzx_authors ORDER BY num_tracks DESC LIMIT 10');
foreach ($auth_rows as $auth) {$auth['nm']=$i+1; $c[$i] = $auth; $i++;}
$smarty->assign('bytunes', $c);


$i=0;
$years_rows = db_fetch_all("SELECT id, nickname, years_from, years_to, ((years_to) - (years_from)) AS act FROM muzx_authors WHERE years_from!='' AND years_to!='' ORDER BY act DESC LIMIT 10");
foreach ($years_rows as $activ) {$activ[4]++; $c[$i]=$activ; $i++;}
$smarty->assign('byyears', $c);



$smarty->assign('authors', db_count_compat('SELECT COUNT(*) AS cnt FROM muzx_authors'));

$smarty->assign('photos', db_count_compat("SELECT COUNT(*) AS cnt FROM muzx_authors WHERE photo='1'"));

$smarty->assign('interviews', db_count_compat('SELECT COUNT(*) AS cnt FROM interview'));

$smarty->assign('messages', db_count_compat('SELECT COUNT(*) AS cnt FROM guestbook'));

$smarty->assign('tunes', db_count_compat("SELECT COUNT(*) AS cnt FROM muzx_songs WHERE hidden='0'"));


$act = '';
$active_rows = db_fetch_all("SELECT nickname, id FROM muzx_authors WHERE years_to>'2008' ORDER BY nickname");
$n=0;
foreach ($active_rows as $g) {
if ($n) {$act.=", ";}
$act.="<a href='/author.php?id=".(int)$g['id']."'>".h($g['nickname'])."</a>"; $n++;
}
$smarty->assign('act', $act);


$k_auth = 0;
$yg = [];
$author_rows = db_fetch_all('SELECT years_from, years_to FROM muzx_authors');
foreach ($author_rows as $gr) {
$k_auth++;
$yf=$gr['years_from'];
$yk=($gr['years_to']-$gr['years_from'])+1;
if ($yf) {for ($i=0; $i<$yk; $i++) {$yg[$yf+$i-1984]++;};}
}


$songy = [];
$year_rows = db_fetch_all("SELECT year FROM muzx_songs WHERE hidden='0' AND year!='0'");
foreach ($year_rows as $ys) { $songy["y".$ys['year']]++;}

for ($i=0; $i<25; $i++) {$gr.= "&yg".$i."=".$yg[$i];}
for ($i=1984; $i<2011; $i++) {$gr.= "&ys".$i."=".$songy["y".$i];}




$nm="images/grafik.png";
//if (file_exists($nm)) {$tm=ceil(filectime($nm)/43200);
//if ($tm!=ceil(time()/43200)) {unlink($nm); $img=require("/grafik2.php?i=0&$gr");}
//}
//else {$img=require("/grafik2.php?i=0&$gr");}
//$img=require("/grafik2.php?i=0&$gr");


include "right_strip.php";  



$smarty->display('stats.tpl');

?>

