<?php
require 'ini.php';

$id=$_REQUEST['id'];


function geturl($i){
global $id;
  $a="/podcast.php?id=$id";
  return $a;
}

if (!$bot) {if (!strpos ($_SESSION['last_url'], "id=".$id)) {
mysqli_query($db,"UPDATE podcast SET views=views+1 WHERE id='$id' LIMIT 1");};}




//$smarty->debugging = true;





$smarty->assign('sel_link',"/podcast.php");
$smarty->assign('active', array('podcasts' => 'class=active'));
$smarty->compile_check = true;





$z = mysqli_query($db,"SELECT * FROM podcast WHERE id='$id'" );

$t = mysqli_fetch_array($z);
$t['release_date'] = date("d.m.Y", $t['release_date']);
 
$smarty->assign('podcast', $t);

if ($_SESSION['language']=="rus") {$smarty->assign('title', $t['topic_rus']);}
else {$smarty->assign('title', $t['topic_eng']);}





$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('podcast.tpl');

