<?php

error_reporting(false);

$true = strpos($_SERVER['HTTP_REFERER'], "zxtunes.com");

if (!$true) {echo "fuck you bot!"; exit;}


define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '18gWNUai');
define('DB_NAME', 'zxtunes');


	mysql_connect(DB_HOST, DB_USER, DB_PASS)
		or die(mysql_error());
	mysql_select_db(DB_NAME)
		or die(mysql_error());
	mysqli_query($db,"SET NAMES 'utf8'");
	
		
		
$tm = time();
$id = intval($_REQUEST['id']);
$nick = $_REQUEST['nick'];
$mess = $_REQUEST['mess'];
$email = $_REQUEST['email'];
$id_author = intval($_REQUEST['id_author']);


echo "<div style='padding-left: 32px; padding-top: 16px; padding-bottom: 16px'>";

if ($nick and $mess and $id > 0) {

	mysqli_query($db,"INSERT INTO comments_songs (`id`, `id_song`, `id_author`, `text`, `e-mail`, `name`, `date`) VALUES (NULL, '$id', '$id_author', '$mess', '$email', '$nick', '$tm') ");
	mysqli_query($db,"UPDATE muzx_songs SET comments=comments+1 WHERE id='$id' LIMIT 1");

}
if ($id > 0) {

	$z = mysqli_query($db,"SELECT * FROM comments_songs WHERE id_song='$id' ORDER BY date" );

	$n = 0;
	while ($t = mysqli_fetch_array($z)) {

		// $m = $amdate[date("m", $t['date'])];
        // $d = date("j.m.Y H:i", $t['date']);
		
		echo "<div><b>";
		
		if ($t['e-mail']) {echo "<a href='mailto:".$t['e-mail']."'>".$t['name']."</a>";}
		else {echo $t['name'];}
		
		echo "</b> <span style='color: #888'>";
		echo date("j.m.Y H:i", $t['date'])."</span></div><div>".$t['text']."</div><br>";
	
	}


}


?>
<br><br>

<table>
<tr><td colspan="2" style="font: bold 10px Verdana">
<?php
if ($_SESSION['language']=="rus") {echo "ДОБАВИТЬ КОММЕНТАРИЙ:";}
else {echo "ADD COMMENT:";}
?>
</td></tr>
<tr><td><input id="nick<?php echo $id; ?>" class="cm_form1" type="text" maxlength="32" name="nickname"> <b>
<?php
if ($_SESSION['language']=="rus") {echo "Ник";}
else {echo "Nickname";}
?>
</b> </td><td></td></tr>
<tr><td><input id="email<?php echo $id; ?>" class="cm_form1" type="text" maxlength="32" name="nickname"> <b>E-Mail</b> </td><td></td></tr>
<tr><td><textarea id="mess<?php echo $id; ?>" class="cm_form2" name="message"></textarea></td><td></td>
<td width="64" align="center">
<input class="cm_form3" type="button" value="OK" onclick="AddComment(<?php echo $id; ?>)"></td></tr>
</table>

</div>