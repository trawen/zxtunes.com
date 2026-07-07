<?php
require 'ini.php';

function geturl($i){
  $a="/search.php?";
  return $a;
}

$ip=$_SERVER["REMOTE_ADDR"];
$client = " ".($_SERVER['HTTP_USER_AGENT'] ?? ''); 
if(strstr($client,"Yandex") or strstr($client,"Googlebot")) {$bot=1;} else {$bot=0;}

if ($bot) {header("Location: ".$_SESSION['last_url']); exit;}

function getext ($i) {
$n=strlen($i)-1;
while (substr($i, $n, 1)!=".") {$res.=substr($i, $n, 1); $n--; if (!$n) {break;};}
$res=strtolower(strrev($res));
return $res;
}


function microtime_float()
{
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
}


$author_id=$_REQUEST['id'];
$message=$_REQUEST['message'];
$user_name=$_REQUEST['user_name'];
$user_email=$_REQUEST['user_email'];
$user_site=$_REQUEST['user_site'];
$user_from=$_REQUEST['user_from'];
$submit=$_REQUEST['submit'];
$code=$_REQUEST['code'];
$confirm_code = $_REQUEST['confirm_code'];
$mode = $_REQUEST['mode'];
$c=explode("+", $code ?? '');
$c=intval(trim($c[0] ?? 0))+intval(trim($c[1] ?? 0));


//$smarty->debugging = true;
$smarty->compile_check = true;

$tm=time(); 
$ip=$_SERVER["REMOTE_ADDR"];



$smarty->assign('search', $sr);


if ($submit=="submit" or $submit=="OK") {

csrf_verify_if_post();

$smarty->assign('srtext', h($_REQUEST['srtext'] ?? ''));
$srtext=mb_strtolower($_REQUEST['srtext'] ?? '', "UTF-8");

$srtype=$_REQUEST['srtype'];
if (strlen($srtext)>=2 and strlen($srtext)<32) {


if ($srtype=="authors") {
$like = '%' . db_like_escape($srtext) . '%';
$rows = db_fetch_all(
	'SELECT * FROM muzx_authors WHERE nickname LIKE ? OR also LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR group_name LIKE ?',
	'sssss',
	array_fill(0, 5, $like)
);
$n=0;
foreach ($rows as $src) {

$src['nickname']=highlight_search($src['nickname'], $srtext);
$src['group_name']=highlight_search($src['group_name'], $srtext);


if ($_SESSION['language']=="rus") {
$src['first_name']=highlight_search($src['first_name'], $srtext);
$src['last_name']=highlight_search($src['last_name'], $srtext);
}
else {
$src['first_name_en']=highlight_search($src['first_name_en'], $srtext);
$src['last_name_en']=highlight_search($src['last_name_en'], $srtext);
}

 
if ($src['also1']) {
$src['also1']=highlight_search($src['also1'], $srtext);
}


if ($src['also2']) {
$src['also2']=highlight_search($src['also2'], $srtext);
}

if ($src['also3']) {
$src['also3']=highlight_search($src['also3'], $srtext);
}

if ($src['also4']) {
$src['also4']=highlight_search($src['also4'], $srtext);
}


if ($src['also5']) {
$src['also5']=highlight_search($src['also5'], $srtext);
}

$src['nm']=$n+1;
$id=$src['id'];

$sr[$n]=$src;
$n++;
}
if ($n==1) {header("Location: /author.php?id=".$id); exit;}
else {

$smarty->assign('klsr', $n);
$smarty->assign('search', $sr);

}

}



elseif ($srtype=="software") {
$like = '%' . db_like_escape($srtext) . '%';
$rows = db_fetch_all(
	'SELECT title, author, id, version FROM software WHERE title LIKE ? OR author LIKE ?',
	'ss',
	[$like, $like]
);
$n=0;
foreach ($rows as $src) {
$src['title']=highlight_search($src['title'], $srtext);
$src['author']=highlight_search($src['author'], $srtext);
$src['nm']=$n+1;
$id=$src['id'];
$sr[$n]=$src;
$n++;
}
if ($n==1) {header("Location: /software.php?id=".$id); exit;}
else {

$smarty->assign('klsr', $n);
$smarty->assign('search', $sr);

}
}



elseif ($srtype=="tunes") {

$time_start = microtime_float();

$like = '%' . db_like_escape($srtext) . '%';
$rows = db_fetch_all(
	'SELECT a.*, b.song_id, c.nickname FROM muzx_songs a JOIN muzx_songs_authors b ON a.id = b.song_id JOIN muzx_authors c ON c.id = b.author_id WHERE (a.filename LIKE ? OR a.name LIKE ?) AND a.hidden=0 AND a.denied=0 ORDER BY c.nickname LIMIT 350',
	'ss',
	[$like, $like]
);

unset($_SESSION['srid']);
unset($_SESSION['srnk']);

$n=0;
foreach ($rows as $src) {

	$src['filename']=highlight_search($src['filename'], $srtext);
	$src['name']=highlight_search($src['name'], $srtext);

	$src['nm']=$n+1;
	$src['id'] = $src['song_id'];
		
	$srid[$n] = $src['song_id'];
	$srnk[$n] = $src['nickname'];
	
	$ri = $src['id'];
	if ($_REQUEST['rt'.$ri]) {$src['rt'] = "r_off";} else {$src['rt'] = "rating";}

	$sr[$n]=$src;
	$n++;
}


for($x=0; $x<$n; $x++) {

    $sr[$x]['next_id'] = $sr[$x+1]['id'];
	$sr[$x]['prev_id'] = $sr[$x-1]['id'];
	
}
$sr[0]['prev_id'] = $sr[$n-1]['id'];
$sr[$n-1]['next_id'] = $sr[0]['id'];








function clean_filename($filename) {
	$reserved = preg_quote('\/:*?"<>|', '/');
	return preg_replace_callback(
		"/([\\x00-\\x40\\x7f-\\xff{$reserved}])/u",
		static fn ($m) => '_',
		$filename
	);
}



$smarty->assign('klsr', $n);
$smarty->assign('search', $sr);
$_SESSION['srid']=$srid;
$_SESSION['srnk']=$srnk;
$_SESSION['srtx']=clean_filename($_REQUEST['srtext']);
$smarty->assign('srtx', $_SESSION['srtx']);
$smarty->assign('srsz',$n*1.2);
}

}

}

$smarty->assign('mdsr', $srtype);
if ($_SESSION['language']=="rus") {$smarty->assign('title', "Поиск - «".$_REQUEST['srtext']."»");}
else {$smarty->assign('title', "Search - «".$_REQUEST['srtext']."»");}










/// DOWNLOAD SEARCH FILES IN ZIP
if ($_REQUEST['download']) {

$srid=$_SESSION['srid'];
$smarty->assign('srid', $srid);
$srnk=$_SESSION['srnk'];
$smarty->assign('srnk', $srnk);


include_once('pclzip.lib.php');

function myPreAddCallBack($p_event, &$p_header)
{global $tname, $nik, $nm;
 $info = pathinfo($p_header['filename']);
if (!$info['extension']) {$p_header['stored_filename'] = $tname['t'.$p_header['stored_filename']][1]."_".$tname['t'.$p_header['stored_filename']][0];}
else {$p_header['stored_filename']=$info['basename'];}
return 1;
}

$nm=0;

while ($srid[$nm]) {

$id=(int)$srid[$nm];


$tunes = db_fetch_one(
	'SELECT filename FROM muzx_songs WHERE id=? AND hidden=0 AND denied=0 LIMIT 1',
	'i',
	[$id]
);
if ($tunes) {

$hex=sprintf("%08X", $srid[$nm]);
$tlist.="tunes/".$hex.",";
$tname['t'.$hex][0]=$tunes['filename'];
$tname['t'.$hex][1]=$srnk[$nm];

}
$nm++;
}
$tlist=substr($tlist, 0, strlen($tlist)-1);



$sid=session_id();
mkdir("temp/".$sid, 0777);
$fn='temp/'.$sid.'/'.time();
$archive = new PclZip($fn);
$v_list = $archive->create($tlist, PCLZIP_CB_PRE_ADD, 'myPreAddCallBack', PCLZIP_OPT_REMOVE_PATH, 'tunes');
if ($v_list == 0) {echo "Error : ".$archive->errorInfo(true);}

$fs = filesize ($fn);
ob_clean();
	
header('Content-type: application/octet-stream');
header('Content-Disposition: attachment; filename=zxtunes_search_'.$_SESSION['srtx'].'.zip');
header("Content-Length: ".$fs);

readfile($fn);
unlink($fn);
rmdir("temp/".$sid);
unset($_SESSION['srid']);
unset($_SESSION['srnk']);
exit;
}

include "right_strip.php";  

$smarty->display('search.tpl');
?>

