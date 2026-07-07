<?php
require 'init.php';

$smarty->compile_check = true;

$nm_news = nm_post_in_page;
$nm_list = nm_pages_list;

Global $mn;
$mn = array(
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

$id = intval($_REQUEST['id']);
if (!$id) {$id = 1;}
$smarty->assign('id', $id);


$page = intval($_REQUEST['page']);
if (!$page) {$page = 1;}



$from = (($page-1) * $nm_news);

$z = mysqli_query($db,"SELECT COUNT(*) FROM full WHERE f_id_theme='$id'");
$p = mysqli_fetch_array($z);
$nm_pages = round($p[0] / $nm_news);

if ($nm_pages * $nm_news < $p[0]) {$nm_pages ++;}



$nmpp = round($nm_list / 2);


if ($page <= $nmpp or $nmpp > $nm_pages or $nm_list > $nm_pages) {

	for ($a = 0; $a < $nm_list; $a++) {
		
		if ($a == $nm_pages) {break;}
		$pg[$a] = $a + 1;
		
		
	}

}
elseif ($page > $nmpp and $page+$nmpp <= $nm_pages) {

	for ($a = 0; $a < $nm_list; $a++) {
		
		$pg[$a] = $page - $nmpp + $a;
		
		
	}

}
else {

	for ($a = 0; $a < $nm_list; $a++) {
		
		$pg[$a] = $nm_pages - $nm_list + $a;
		
	}

}

$smarty->assign('news_pages', $pg);
$smarty->assign('news_tk_page', $page);


$z = mysqli_query($db,"SELECT * FROM themes WHERE t_pub=1 AND t_id='$id'");
$p = mysqli_fetch_array($z);
$p['t_title'] = iconv("CP1251", "UTF-8", $p['t_title']);
$smarty->assign('title', $p['t_title']);

$dir = ceil($p['t_id'] / 1000);

$txt = explode(chr(7), file_get_contents("2/".$dir."/".$p['t_id']."_$page.html"));

$z = mysqli_query($db,"SELECT * FROM full WHERE f_id_theme='$id' ORDER BY f_date ASC LIMIT $from, $nm_news" );


$n = 0;
while ($t = mysqli_fetch_array($z)) {


$t['id'] = $t['f_id'];
$t['title'] = $t['f_title'];
$t['author'] = iconv("CP1251", "UTF-8",  $t['f_name']);
$dir = ceil($t['f_id'] / 1000);
$t['text'] = iconv("CP1251", "UTF-8", $txt[$n]);

$t['nm'] = $n;

$m = $mn[date("m", $t['f_date'])];
$t['date'] = date("j ".$m." G:i", $t['f_date']);
$list[$n] = $t;

$n++;

}

$smarty->assign('news_list', $list);




mysqli_query($db,"UPDATE themes SET t_views=t_views+1 WHERE t_id=$id LIMIT 1");






$smarty->assign('mode', 1);
mysql_connect(DB_HOST, DB_USER, DB_PASS)
or die(mysql_error());
mysql_select_db(DB_NAME)
or die(mysql_error());
mysqli_query($db,"SET NAMES 'utf8'");


if (!defined('_SAPE_USER')){
      define('_SAPE_USER', 'df148749a7a956a4334286aea4e556e8'); 
}
require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php'); 
$sape = new SAPE_client();

include "right_strip.php";

$smarty->display('index.tpl');

?>