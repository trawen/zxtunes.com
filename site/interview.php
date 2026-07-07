<?php
require 'ini.php';



function geturl($i){
  $a="/interview.php?";
  return $a;
}


$smarty->compile_check = true;



$smarty->assign('sel_link',"/interview.php");
$smarty->assign('active', array('interview' => 'class=active'));













$z = mysqli_query($db,"SELECT int_id,int_author_id,int_views,int_year,int_title,int_language, photo, id, nickname,  first_name, last_name, int_author FROM interview, muzx_authors WHERE id=int_author_id ORDER BY int_year" ); echo mysql_error();

$n=0;
while ($t = mysqli_fetch_array($z)) { 
	
	$t['nm'] = $n+1;
	$in[$n] = $t;
	$n++;
				
}
$smarty->assign('interview', $in);
		
$smarty->assign('num_interviews', $n+1);
				
		

include "right_strip.php";  


$smarty->display('interview.tpl');
?>