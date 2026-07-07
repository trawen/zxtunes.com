<?php
require 'ini.php';
require_once __DIR__ . '/includes/upload_safe.php';

$ip=$_SERVER["REMOTE_ADDR"];
$client = " ".($_SERVER['HTTP_USER_AGENT'] ?? ''); 

$confirm_id=$_REQUEST['confirm_id'];
$confirm_code = strtoupper($_REQUEST['confirm_code']);


$a=1;
$cc2="";
for ($i=1; $i<7; $i++) {$cc2.=substr($confirm_id, $a, 1); $a=$a+2;}




if(strstr($client,"Yandex") or strstr($client,"Googlebot")) {$bot=1;} else {$bot=0;}

if ($bot) {header("Location: ".$_SESSION['last_url']); exit;}

function getext ($i) {
$n=strlen($i)-1;
while (substr($i, $n, 1)!=".") {$res.=substr($i, $n, 1); $n--; if (!$n) {break;};}
$res=strtolower(strrev($res));
return $res;
}

$author_id=$_REQUEST['id'];
$message=$_REQUEST['message'];
$user_name=$_REQUEST['user_name'];
$user_email=$_REQUEST['user_email'];
$user_site=$_REQUEST['user_site'];
$user_from=$_REQUEST['user_from'];
$submit=$_REQUEST['submit'];
$mode = $_REQUEST['mode'];


function tst_err($a) {
global $message, $user_name, $user_email, $user_site, $code, $confirm_code, $c, $author_id, $cc2;
$err=0;
if ($_SESSION['language']=="rus") {
if (!$message) {$err++; $ert="$err. Поле <b>сообщение</b> слишком короткое.<br>"; }
if (mb_strlen($message, "UTF-8")>3048) {$err++; $ert.="$err. Поле <b>сообщение</b> слишком длинное.<br>";}
if (!$user_name) {$err++; $ert.="$err. <b>Имя</b> слишком короткое.<br>";}
if ($user_email and mb_strlen($user_email)<7) {$err++; $ert.="$err. Поле <b>почта</b> слишком короткое.<br>";}
if ($user_site and mb_strlen($user_site)<5) {$err++; $ert.="$err. Поле <b>сайт</b> слишком короткое.<br>";}
if ($cc2 != $confirm_code or strlen($cc2)!=6) {$err++; $ert.="$err. <b>Неверный код.</b><br>";}
}
else {
if (!$message) {$err++; $ert="$err. <b>Message</b> too short.<br>";}
if (mb_strlen($message, "UTF-8")>3048) {$err++; $ert.="$err. <b>Message</b> too long.<br>";}
if (!$user_name) {$err++; $ert.="$err. <b>Name</b> too short.<br>";}
if ($user_email and mb_strlen($user_email)<7) {$err++; $ert.="$err. <b>E-Mail</b> too short.<br>";}
if ($user_site and mb_strlen($user_site)<5) {$err++; $ert.="$err. <b>Site</b> too short.<br>";}
if ($cc2 != $confirm_code or strlen($cc2)!=6) {$err++; $ert.="$err. <b>Confirm code error.</b><br>";}
}
return $ert;
}


$tm=time(); 
$ip=$_SERVER["REMOTE_ADDR"];
$ert=tst_err(0);



$spam=strpos(" ".$user_name , "osama");
if ($spam) {echo "fuck you!!"; exit;}


if ($submit=="submit" or $submit=="отправить") {

csrf_verify();

if ($mode=="guestbook") {

if (!$ert) {
db_execute(
	'INSERT INTO guestbook (author_id, message, user_id, user_name, user_email, flag, `update`, site, `from`, ip) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
	'isssisiiss',
	[(int) $author_id, $message, (int) ($user_id ?? 0), $user_name, $user_email, (int) ($flag ?? 0), $tm, $user_site, $user_from, $ip]
);

	if ($_SESSION['language']=="rus") {$_SESSION['error']="Ваше сообщение добавлено.<br>";}
	else {$_SESSION['error']="Your message has been added.<br>";}

}
else {
$_SESSION['error']=$ert;
$_SESSION['message']=$message;
$_SESSION['user_name']=$user_name;
$_SESSION['user_email']=$user_email;
$_SESSION['user_site']=$user_site;

}

header("Location: ".$_SESSION['last_url']."#message"); 
}



elseif ($mode=="informer" or $mode=='faq') {



if ($_FILES['file']['size']>16000000) {
	if ($_SESSION['language']=="rus") {$ert="Файл слишком большой!<br>";}
	else {$ert="File size too big!<br>";}
}


if (!$ert) {
$file_name=$_FILES['file']['name'] ?? '';
db_execute(
	'INSERT INTO informer (message, user_name, user_email, `update`, user_site, file_name, ip, mode) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
	'sssissss',
	[$message, $user_name, $user_email, $tm, $user_site, $file_name, $ip, $mode]
);
$id_file=db_insert_id();

if ($_FILES['file']['name'] and $id_file) {
	$ext = getext($_FILES['file']['name']);
	if ($ext && zxtunes_safe_upload($_FILES['file'], "informer/".$id_file.".".$ext)) {
		// stored as informer/{id}.{ext}
	}
}

	
	
	

require("mailer/class.phpmailer.php");

$mail = new PHPMailer();
$mail->From = "www.zxtunes.com";
$mail->AddAddress("newart@untergrund.net");


$mail->WordWrap = 50;
$mail->IsHTML(true);

$mail->Subject = "Message from $mode.";
$mail->Body    = iconv("UTF-8", "CP1251", "name: ".$user_name."<br>"."e-mail: ".$user_email."<br>site: ".$user_site."<br><br>".$message); 


if(!$mail->Send())
{$_SESSION['error']="Mailer Error: " . $mail->ErrorInfo;
$_SESSION['message']=$message;
$_SESSION['user_name']=$user_name;
$_SESSION['user_email']=$user_email;
$_SESSION['user_site']=$user_site;
}

if ($mode=="faq") {
	if ($_SESSION['language']=="rus") {$_SESSION['error']="Благодарим за Ваш вопрос.<br>Мы постараемся на него ответить в ближайшее время.";}
	else {$_SESSION['error']="Thanks for your question. <br>We shall try to answer it in the near future.";}
}
else {
	if ($_SESSION['language']=="rus") {$_SESSION['error']="Благорим за информацию.<br>";}
	else {$_SESSION['error']="Thanks you for information.<br>";}
}


}
else {
$_SESSION['error']=$ert;
$_SESSION['message']=$message;
$_SESSION['user_name']=$user_name;
$_SESSION['user_email']=$user_email;
$_SESSION['user_site']=$user_site;
}

if ($mode=="faq") {
header("Location: ".$_SESSION['last_url']."#question"); 
exit;
}
else {
header("Location: ".$_SESSION['last_url']); 
exit;
}

}
elseif ($mode=="search") {




$srtext=$_REQUEST['srtext'];
$srtype=$_REQUEST['srtype'];
if (strlen($srtext)>=2 and strlen($srtext)<32) {

if ($srtype=="authors") {
$like = '%' . db_like_escape($srtext) . '%';
$rows = db_fetch_all(
	'SELECT * FROM muzx_authors WHERE nickname LIKE ? OR also1 LIKE ? OR also2 LIKE ? OR also3 LIKE ? OR also4 LIKE ? OR also5 LIKE ?',
	'ssssss',
	array_fill(0, 6, $like)
);
$klp=0; $n=0; $idsr=0;
foreach ($rows as $src) {
$srsr[0]=$src['id'];
if ($srtext==strtolower($src['nickname']) or $srtext==strtolower($src['also1']) or $srtext==strtolower($src['also2']) or $srtext==strtolower($src['also3']) or $srtext==strtolower($src['also4']) or $srtext==strtolower($src['also5'])) {$klp++; $idsr=$src['id'];}
}
if ($klp==1) {   header("Location: /author.php?id=".$idsr);
exit;	
} 
}



elseif ($srtype=="software") {
$like = '%' . db_like_escape($srtext) . '%';
$rows = db_fetch_all('SELECT * FROM software WHERE title LIKE ?', 's', [$like]);
$klp=0; $n=0; $idsr=0;
foreach ($rows as $src) {
$srsr[0]=$src['id'];
if ($srtext==strtolower($src['title'])) {$klp++; $idsr=$src['id'];}
}
if ($klp==1) {header("Location: /software.php?id=".$idsr);
exit;	
} 
}

header("Location: ".$_SESSION['last_url']); 
exit;
}

}
}
?>

