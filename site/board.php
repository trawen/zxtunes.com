<?php

require 'init.php';

if ($_REQUEST['fix'] == 1) {

	$z = mysqli_query($db,"SELECT COUNT(*) FROM themes");
	$p = mysqli_fetch_array($z);

	$l = round($p[0] / 5);

	mysqli_query($db,"UPDATE themes SET t_pub=1 ORDER BY t_date ASC LIMIT $l");

	echo "FIXED $l from ".$p[0]."<br><br>";

}

if ($_REQUEST['spectrum'] > 1) {

	$id = $_REQUEST['spectrum'];
	
	mysqli_query($db,"DELETE FROM themes WHERE t_id=$id LIMIT 1");

}

$nm_news = nm_news_in_page;
$nm_list = nm_pages_list;




$page = intval($_REQUEST[$link_2_id]);
if (!$page) {$page = 1;}





$smarty->compile_check = true;

$from = (($page-1) * $nm_news);

$z = mysqli_query($db,"SELECT COUNT(*) FROM themes WHERE t_pub=1 AND t_len>0");
$p = mysqli_fetch_array($z);
$nm_pages = round($p[0] / $nm_news);



$nmpp = round($nm_list / 2);

if ($page <= $nmpp) {

	for ($a = 0; $a < $nm_list; $a++) {
		
		$pg[$a] = $a + 1;
		
	}

}
elseif ($page > $nmpp and $page+$nmpp <= $nm_pages) {

	for ($a = 0; $a < $nm_list; $a++) {
		
		$pg[$a] = $page - $nmpp + $a ;
		
	}

}
else {

	for ($a = 0; $a < $nm_list; $a++) {
		
		$pg[$a] = $nm_pages - $nm_list + $a;
		
	}

}

$smarty->assign('news_pages', $pg);
$smarty->assign('news_tk_page', $page);
$smarty->assign('news_nm_pages', $nm_pages);




$z = mysqli_query($db,"SELECT * FROM themes WHERE t_pub=1 AND t_len>0 ORDER BY themes.t_date DESC LIMIT $from, $nm_news" );

$mtime = microtime(); 
$mtime = explode(" ",$mtime); 
$mtime = $mtime[1] + $mtime[0]; 
$tstart = $mtime;

$n = 0;
while ($t = mysqli_fetch_array($z)) {

$id = $t['t_id'];
$x = mysqli_query($db,"SELECT * FROM full WHERE f_id_theme = '$id' " );
$f = mysqli_fetch_array($x);


$t['id'] = $t['t_id'];
$t['title'] = iconv("CP1251", "UTF-8", $t['t_title']);
$t['author'] = iconv("CP1251", "UTF-8", $f['f_name']);
$dir = ceil($t['id'] / 1000);


$t['text'] = file_get_contents("2/".$dir."/".$t['id']."_1.html");
$t['text'] = iconv("CP1251", "UTF-8", substr($t['text'], 0, $t['t_len']));

      $o = 0;
      $pos = 0;
      do {
        $pos = $pos + 1;
        $pos = strpos(" ".$t['text'], "<div", $pos);
        If ($pos) {$o = $o + 1;}
      }
      while ($pos <> 0);

      
      $c = 0;
      $pos = 0;
      do {
        $pos = $pos + 1;
        $pos = strpos(" ".$t['text'], "</div", $pos);
        If ($pos) {$c = $c + 1;}
      } 
      while ($pos <> 0);
      
      $t['t_div'] = $o - $c;


$t['messages'] = $t['t_messages'];
$t['text'] = $t['text']. str_repeat("</div>", $t['t_div']); 
$t['nm'] = $n;

$m = $mn[date("m", $t['t_date'])];
$t['date'] = date("j ".$m." G:i", $t['t_date']);
$t['date2'] = date("j m - G:i", $t['t_date']);
$list[$n] = $t;

$n++;

}

$smarty->assign('news_list', $list);


$mtime = microtime(); 
$mtime = explode(" ",$mtime); 
$mtime = $mtime[1] + $mtime[0]; 
$tend = $mtime; 
$totaltime = ($tend - $tstart); 
$smarty->assign('time', $totaltime);

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