<?php
require 'ini.php';

$id = (int) $_REQUEST['id'];
$md=$_REQUEST['md'];

function geturl($i){
global $id;
  $a="/software.php?id=$id&";
  return $a;
}

if (!$bot) {db_execute('UPDATE software SET views=views+1 WHERE id=? LIMIT 1', 'i', [$id]);}



//$smarty->debugging = true;





$smarty->assign('sel_link',"/software_list.php");



if ($_SESSION['language']=="ru") {
}
else {
}
		 

		 
$smarty->assign('active', array('soft' => 'class=active'));
		 
$smarty->compile_check = true;



$n=0;
while (is_file("software/scr/".sprintf("%03X_%01X", $id, $n))) {
$soft_images.="<img vspace=2 src='software/scr/".sprintf('%03X_%01X', $id, $n)."'><br>"; 
$n++;}

$smarty->assign('soft_images',$soft_images);


$sm = db_fetch_one('SELECT * FROM software_manual WHERE id_software=? LIMIT 1', 'i', [$id]) ?? [];

$sys[1]="TR-DOS";
$sys[2]="TAP";
$sys[3]="TZX";
$sys[4]="MB02+";
$sys[5]="D80";
$sys[6]="DSK";
$sys[7]="Z80";
$sys[8]="Windows";
$sys[9]="Linux";
$sys[0]="n/a";



$sf = db_fetch_one('SELECT * FROM software WHERE id=? LIMIT 1', 'i', [$id]);
if (!$sf) {
	http_response_code(404);
	exit('Software not found');
}
$sf['update_']=date("d.m.Y", $sf['update_']);
 
$smarty->assign('sf', $sf);
$smarty->assign('title', $sf['title']." ".$sf['version']." by ".$sf['author']);


$mode[$sf['type']]="class=selected";
$smarty->assign('mode',$mode);



$file_rows = db_fetch_all('SELECT * FROM software_file WHERE id_software=?', 'i', [$id]);
$n=0;
foreach ($file_rows as $sf) {
$sf['size']=ceil(filesize("software/files/".$sf['id_file'])/1000);
$sf['system']=$sys[$sf['system']];
$s22[$n]=$sf;
$n++;
}



$smarty->assign('sz',$s22);
$smarty->assign('soft_article',$sm['text'] ?? '');

$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('software.tpl');

