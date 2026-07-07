<?php

require("mailer/class.phpmailer.php");

function send_email($email, $login, $subj, $message) {
			
$mail = new PHPMailer();
$mail->IsSMTP(); // telling the class to use SMTP
$mail->SMTPDebug  = false;                     // enables SMTP debug information (for testing)
                                          // 1 = errors and messages
                                           // 2 = messages only
$mail->SMTPAuth   = true;                  // enable SMTP authentication
$mail->Host       = "ssl://smtp.gmail.com"; // sets the SMTP server
$mail->Port       = 465;                    // set the SMTP port for the GMAIL server
$mail->Username   = "spectrum4ever.org@gmail.com"; // SMTP account username
$mail->Password   = "spectrum1ffd";        // SMTP account password
$mail->SetFrom('spectrum4ever.org@gmail.com', '');
//$mail->AddReplyTo("admin@purebasic.ru","");
$mail->AddAddress($email, $login);
$mail->Sender = "spectrum4ever.org@gmail.com";
$mail->From = "Admin";
$mail->WordWrap = 100;
$mail->IsHTML(false);
$mail->CharSet = 'UTF-8';
$mail->Subject = $subj;
$mail->Body    = $message; 

				
$mail->Send();

}
?>