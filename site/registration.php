<?php
session_start();
require 'common.inc.php';
initDB();


$username = $_REQUEST['username'];
$email = $_REQUEST['email'];
$password = $_REQUEST['password'];
$password_confirm = $_REQUEST['password_confirm'];
$login = $_REQUEST['login'];
$login_confirm = $_REQUEST['login_confirm'];
$confirm_code = strtoupper($_REQUEST['confirm_code']);
$icq = $_REQUEST['icq'];
$email_pub = $_REQUEST['email_pub'];
$url = $_REQUEST['url'];
$first_name = $_REQUEST['first_name'];
$last_name = $_REQUEST['last_name'];
$city = $_REQUEST['city'];
$country = $_REQUEST['country'];
$submit = $_REQUEST['submit'];
$confirm_id = $_REQUEST['confirm_id'];


$a=1;
for ($i=1; $i<9; $i++) {$cc2.=substr($confirm_id, $a, 1); $a=$a+2;}

// echo "submit: ".$submit."<br>";

// echo "password: ".$password."<br>";
// echo "password_confirm: ".$password_confirm."<br>";
// echo "confrim code: ".$confirm_code."<br>";
// echo "cc2: ".$cc2."<br>";
// echo "password_id: ".$confirm_id."<br><br>";


$err=0;
$error[1]="The passwords you entered did not match.";
$error[2]="You must fill in the required fields.";
$error[4]="The confirmation code you entered was incorrect.";
$error[8]="Password too short.";
$error[16]="Sorry, but this username has already been taken.";
$error[32]="MySQL error 2.";

if ($submit=="Submit") {
	if ($password != $password_confirm) {$err=$err | 1;} 
	if (!$username or !$email or !$password or !$password_confirm) {$err=$err | 2;}
	if ($cc2 != $confirm_code or strlen($cc2)!=8) {$err=$err | 4;}
	if (strlen($password)<8) {$err=$err | 8;} 
	
	$zapros = mysqli_query($db,"SELECT * FROM users WHERE username='$username'");
	$us = mysqli_fetch_array($zapros);
	if ($us['username']==$username and $username) {$err=$err | 16;}
	
	if ($err==0) {
	$ins=mysqli_query($db,"INSERT INTO users (id, id_authors, username, password, first_name, last_name, city, country, icq, email, email_pub, url, status) VALUES (NULL, '','$username','$password','$first_name','$last_name','$city','$country','$icq','$email', '$email_pub', '$url','1') ");
	
	if (!$ins) {$err=$err | 32;}
		 }
}	
		 
	if ($err>0 and $submit=="Submit") {
	    $a=1;
		for ($i=1; $i<7; $i++) { if ($err & $a) {echo $error[$err & $a]."<br>";} $a=$a * 2;} 
		echo "<br>";
	}
		
	elseif ($submit=="Submit") {echo "Registration OK!<br><br>";}	 
					  	
					  

if ($submit!="Submit" or $err>0) {

$cc="";
for ($i=1; $i<18; $i++) {$cc.=chr(rand(65,90));}

//echo $cc;

require 'registration.inc';
}
?>