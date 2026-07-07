<?php
require 'online.inc';

if ($_REQUEST['delete_id']) {

	$id = intval($_REQUEST['delete_id']);
	mysqli_query($db,"DELETE FROM wait_fym WHERE wf_id='$id' LIMIT 1 "); echo mysql_error();

	echo "ok";
	exit;

}



//$z = mysqli_query($db,"SELECT * FROM wait_fym, muzx_songs WHERE muzx_songs.id=wf_id_song" ); echo mysql_error();
$z = mysqli_query($db,"SELECT id,type FROM muzx_songs" ); echo mysql_error();



$n=0;
while ($t = mysqli_fetch_array($z)) { 
	
	//$e = $e . $t['wf_id'].",".$t['wf_id_song'].",".$t['wf_id_author'].",".$t['type']."/";
	$e = $e . $t['id'].",".$t['type']."/";
					
}

header('Content-type: application/octet-stream');
header('Content-Disposition: attachment; filename=fuck');
header("Content-Length: ".strlen($e));

echo $e;

?>