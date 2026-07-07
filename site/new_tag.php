<?php
require 'ini.php';


$type = $_REQUEST['type'];
$id_song = intval( $_REQUEST['id_track'] );
$id_tag = intval( $_REQUEST['id_tag'] );

if ($type == "new") {

	$name = strtolower( my( 'name' ));

	mysql_query ("INSERT INTO tags SET name='$name'");

	$z = mysqli_query($db,"SELECT * FROM tags ORDER BY name");
	while ($t = mysqli_fetch_array($z)) { 
	
		echo "<span style='cursor: pointer' onclick=InsertTag('".$t['name']."','".$t['id']."')>".$t['name']."</span> &nbsp; ";
	
	}

}
elseif ($type == "add" and $id_song and $id_tag) {
	
	$s = qr("tags_songs", "id_song=$id_track AND id_tag=$id_tag");
	
	if (!$s) {
	
		mysqli_query($db,"INSERT INTO tags_songs SET id_song='$id_song', id_tag='$id_tag'");	
		mysqli_query($db,"UPDATE muzx_songs SET tags=CONCAT(tags,'$id_tag|') WHERE id='$id_song' LIMIT 1");	
	
	}
		
	
}
elseif ($type == "del" and $id_song and $id_tag) {
	
	mysqli_query($db,"DELETE FROM tags_songs WHERE id_song=$id_song AND id_tag=$id_tag LIMIT 1");	
	
	$t = qr("muzx_songs", "id=$id_song");
	
	$tags = explode("|", $t['tags']);
	
	foreach ($tags as $v) {

		if ($v != $id_tag and $v) {$new_tags .= "$v|";}
	
	}
	
	mysqli_query($db,"UPDATE muzx_songs SET tags='$new_tags' WHERE id='$id_song' LIMIT 1");	
		
	echo mysql_error();
	
}


?>
