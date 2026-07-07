<?php

define('DB_HOST', 'localhost');
define('DB_USER', 'newart');
define('DB_PASS', 'zxfuckxackyou7765');
define('DB_NAME', 'newart');

$conn = mysql_connect (DB_HOST, DB_USER, DB_PASS);
@mysql_select_db (DB_NAME, $conn);

$id = intval($_REQUEST['id']);
$id_author = intval($_REQUEST['id_author']);
$type = intval($_REQUEST['type']);
$tm = time();
$true = strpos($_SERVER['HTTP_REFERER'], "zxtunes.com");



if ($type == 1 and $id > 0 and $true) {

   	mysqli_query($db,"UPDATE muzx_songs SET rating=rating+1 WHERE id='$id' LIMIT 1"); echo mysql_error();

	$z = mysqli_query($db,"SELECT * FROM last_rate WHERE id_song='$id' ");
	$t = mysqli_fetch_array($z);
	
	if ($t['id_song']) {
	
		mysqli_query($db,"UPDATE last_rate SET date='$tm' WHERE id_song='$id' LIMIT 1");
	
	}
	else {
	
		mysqli_query($db,"INSERT INTO `last_rate` ( `id_song` , `id_author` , `date` ) VALUES ( '$id' , '$id_author' , '$tm' )"); 
	
	}
	
	
	
}
elseif ($type == 2 and $id > 0  and $true) {
	
	mysqli_query($db,"UPDATE muzx_songs SET downloads=downloads+1 WHERE id='$id' LIMIT 1");
	
	
	$z = mysqli_query($db,"SELECT * FROM last_playing WHERE id_song = '$id' ");
	$t = mysqli_fetch_array($z);
	
	if ($t['id_song']) {
	
		mysqli_query($db,"UPDATE last_playing SET date='$tm' WHERE id_song='$id' LIMIT 1");
	
	}
	else {
	
		mysqli_query($db,"INSERT INTO `last_playing` ( `id_song` , `id_author` , `date` ) VALUES ( '$id' , '$id_author' , '$tm' )");
	
	}
		
	
}



?>