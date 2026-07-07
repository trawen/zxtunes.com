<?php
require 'ini.php';



function geturl($i){
  $a="/faq.php?";
  return $a;
}



$smarty->debugging = false;
$smarty->compile_check = true;




$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/faq.php");



if ($_SESSION['language']=="rus") {$smarty->assign('title', 'ЧАВО');
}
else {$smarty->assign('title', 'FAQ');
}
		
		 
$smarty->assign('active', array('faq' => 'class=active'));
		 
$smarty->compile_check = true;

$smarty->assign('code', rand(1,9)." + ".rand(1,9));


$z = mysqli_query($db,"SELECT faq_views, faq_update FROM misc" );

$faq=mysqli_fetch_array($z);
$faq['faq_update']=date("d.m.Y", $faq['faq_update']);
 
$smarty->assign('faq', $faq);



include "right_strip.php";  



$smarty->display('faq.tpl');

?>