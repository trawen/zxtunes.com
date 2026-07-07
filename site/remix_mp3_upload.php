<?php
require 'online.inc';




function geturl($i){
  $a="/remix_mp3_upload.php?";
  return $a;
}


$smarty->assign('active', array('remix_mp3' => 'class=active'));

$smarty->compile_check = true;
$smarty->debugging = true;

$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];
$md=$_REQUEST['md'];
if ($md=="") {$md=0;}
$order=$_REQUEST['order'];

$mode[$md]="class=selected";
$smarty->assign('id',$id);
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/remix_mp3.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$order);



$n=0;
$zapros = mysqli_query($db,"SELECT DISTINCT author FROM remix_mp3 GROUP BY author ORDER BY author ");

while ($t = mysqli_fetch_array($zapros)) { 

$rmx_author[$n] = $t['author'];
$n++;

}

$smarty->assign('rmx_author', $rmx_author);


$n=0;
$zapros = mysqli_query($db,"SELECT * FROM muzx_authors ORDER BY nickname ");

while ($t = mysqli_fetch_array($zapros)) { 

$org_author[$n]['id'] = $t['id'];
$org_author[$n]['name'] = $t['nickname'];

$n++;

}

$smarty->assign('org_author', $org_author);






include "right_strip.php";  

$smarty->display('remix_mp3_upload.tpl');

