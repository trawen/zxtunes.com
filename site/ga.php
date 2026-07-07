<?php
require 'ini.php';

$id = $_GET['id'];
$md5 = $_GET['md5'];
$time = $_GET['time'];
$author = $_GET['author'];
$comment = mysql_escape_string($_GET['comment']);
$name = mysql_escape_string($_GET['name']);
$type = $_GET['type'];
$sub_id = $_GET['sub_id'];
$title = mysql_escape_string($_GET['title']);
$rename = $_GET['rename'];





	mysqli_query($db,"UPDATE muzx_songs SET name='$name',time='$time',comment='$comment',md5='$md5' WHERE id='$id' LIMIT 1");
	echo mysql_error();

exit;


$z = mysqli_query($db,"SELECT * FROM muzx_songs WHERE type='9'");    
while ($t = mysqli_fetch_array($z)) {

	$name = mysql_escape_string(trim(preg_replace ('/\([0-9]+ tunes\)/','',$t['name'])));
	echo $name."<br>";
	$id = $t['id'];
	mysqli_query($db,"UPDATE muzx_songs SET name='$name' WHERE id='$id' LIMIT 1");
	$n++;
	echo mysql_error();
	
}

echo $n;

exit;




if ($rename) {

	$z = mysql_query ("SELECT * FROM muzx_songs WHERE id ='$id' LIMIT 1" , $conn);
	$t = mysqli_fetch_array($z);

	
	$f = explode(".", $t['filename']);
	$filename = mysql_escape_string($f[0] . "_1.ay");
	
	//mysqli_query($db,"UPDATE muzx_songs SET filename='$filename', fym='$type' WHERE id=$id LIMIT 1");
		

}
elseif ($type) {

	$z = mysql_query ("SELECT * FROM muzx_songs WHERE id ='$id' LIMIT 1" , $conn);
	$t = mysqli_fetch_array($z);

	
	$f = explode(".", $t['filename']);
	$filename = mysql_escape_string($f[0] . "_".$sub_id.".ay");
	$year = $t['year'];
	$tm = time();
	
	mysqli_query($db,"INSERT INTO muzx_songs (`filename`, `year`, `last_update`, `type`, `fym`, `name`) VALUES ('$filename', '$year', '$tm', '9', '$type', '$title') ");
	echo mysql_error();
	
	$id = mysql_insert_id();

	mysqli_query($db,"INSERT INTO  muzx_songs_authors (`song_id`, `author_id`) VALUES ('$id', '$author') ");
	
	echo $id;
		
}
else {

	$z = mysql_query ("SELECT author_id FROM muzx_songs_authors WHERE song_id ='$id'" , $conn);
	$t = mysqli_fetch_array($z);

	echo $t[0];

}
	
?>