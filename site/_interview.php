<?php
require 'online.inc';

function geturl($i){
  $a="/interview.php?";
  return $a;
}


$smarty->compile_check = true;
//$smarty->debugging = true;



$smarty->assign('sel_link',"/interview.php");
$smarty->assign('active', array('interview' => 'class=active'));







if (!$fr) {$fr=1;}
if (!$up) {$up="DESC";}
if (!$lm or $lm<40) {$lm=40;}

$fr2=($fr-1)*40;




$z = mysqli_query($db,"SELECT COUNT(*) FROM podcast $where" );

$kl=mysqli_fetch_array($z);
$kl=$kl[0];

$kl2=Ceil($kl/40);



// PAGES

	for ($i = 1; $i <= $kl2; $i++) {
		if ($fr==$i and $lm==40) {$pages.= "<span class='Page'>$i</span>";
		} else {$pages.= "<a class='Page' href='?lm=40&fr=$i&order=$order&up=$up'>$i</a> ";}
	}
	if ($lm>40) {$pages.= " <span class='Page'>$all</span>";} else {$pages.= "<a class='Page' href='?order=$order&lm=$kl&fr=1&up=$up'>$all</a>";}


$smarty->assign('kl4', $kl);
$smarty->assign('pages', $pages);	




$z = mysqli_query($db,"SELECT id,author_id,views,year,title,language FROM interview ORDER BY year" );

$n=0;
while ($t = mysqli_fetch_array($z)) { 
	
	$t['nm'] = $n+1;
	$in[$n] = $t;
	$n++;
				
}
$smarty->assign('interview', $in);
		
		
$smarty->assign('kl2', $n);


include "right_strip.php";  

$smarty->display('interview.tpl');


?>