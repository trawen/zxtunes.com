<?php
require 'ini.php';
require_once __DIR__ . '/includes/upload_safe.php';

function geturl($i){
  $a="/informer.php?";
  return $a;
}

//error_reporting(E_ALL | E_STRICT);

$message = $_REQUEST['message'];
$name    = $_REQUEST['name'];
$email   = $_REQUEST['email'];
$submit  = $_REQUEST['submit'];

$tm=time(); 
$ip=$_SERVER["REMOTE_ADDR"];




if ($submit=="Submit" or $submit=="Отправить") {

	csrf_verify();

	$file_name = $_FILES['file']['name'];


	if ($_FILES['file']['name']) {
		$ext = strtolower(pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION));
		if ($ext) {
			zxtunes_safe_upload($_FILES['file'], "informer/".$tm.".".$ext);
		}
	}

	require 'email.inc';
			
			
	$message = "Здравствуйте, newart! \n\nВам пришло новое сообщение от «".$name."» [$email]\n\n\n$message\n\n\n";
	
	if ($file_name) { $message .= "Файл: /downloads.php?id=$tm&md=informer&name=$file_name\n\n"; }

		
	if (!send_email("vtcd@mail.ru", "", "Сообщение от информера zxtunes.com", $message)) {

		$_SESSION['error'] = 1;
	
	}
	else {
	
		$_SESSION['error'] = 2;
	
	}
			
	header("Location: /wanted.php");
	exit;	
	
}



//$smarty->debugging = true;
$smarty->compile_check = true;




$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/informer.php");




if ($_SESSION['language']=="rus") {$smarty->assign('title', 'Отправить информацию или музыку');
}
else {$smarty->assign('title', 'Submit info or music');
}
		
		 
$smarty->assign('active', array('informer' => 'class=active'));





























// $z = mysqli_query($db,"SELECT faq_views, faq_update FROM misc" );

// $faq=mysqli_fetch_array($z);
// $faq['faq_update']=date("d.m.Y", $faq['faq_update']);
 
// $smarty->assign('faq', $faq);

$smarty->assign('error', $_SESSION['error']);
unset($_SESSION['error']);

include "right_strip.php";  

$smarty->display('wanted.tpl');

