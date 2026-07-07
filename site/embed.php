<?php

require 'ini.php';

$id=intval($_REQUEST['id']);
$play=intval($_REQUEST['play']);

$smarty->assign('author_id', $id);



$smarty->compile_check = true;
$smarty->assign('active', array('authors' => 'class=active'));




  
$sort = "rating";

// if ($sort == "rating" ) {$ord = "muzx_songs.rating";} 
// elseif ($sort == "playing") {$ord = "muzx_songs.downloads";}   
// else {$ord = "muzx_songs.year";}   

// $zapros = mysqli_query($db,"SELECT * FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id AND muzx_songs.hidden!=1 ORDER BY $ord DESC, filename ASC" );


if ($sort == "rating" ) {$ord = "muzx_songs.rating";} 
elseif ($sort == "playing") {$ord = "muzx_songs.downloads";}   
else {$ord = "muzx_songs.year";}   




$zapros = mysqli_query($db,"SELECT * FROM muzx_songs WHERE id = '$play' LIMIT 1" );





$i=$fr2+1;
$n=0; 
unset($a);
$last = 0;
while ($t = mysqli_fetch_array($zapros)) { 

	
	if ($last != $t['year']) {$t['print_year'] = 1; $last = $t['year'];}
	
	$t['name'] = htmlentities($t['name']);
	$s = ceil($t['time']/50);
	$sec = sprintf("%02d", $s - ((intval($s/60)) * 60));
	$min = intval($s/60);
	$t['time'] = $min.":".$sec;
	$t['nm'] = $i;
	$t['last_update'] = date('d.m.Y', $t['last_update']);
	$ri = $t['id'];
	if ($_REQUEST['rt'.$ri]) {$t['rt'] = "r_off";} else {$t['rt'] = "rating";}
	
	$a[$n] = $t;

	if ($t['id'] == $_REQUEST['play']) {

		$autoplay_title = $row1['nickname']." - ".$t['filename'];
		if ($t['name']) { $autoplay_title.= " - ".$t['name'];}
		$smarty->assign('autoplay_title', $autoplay_title);
		
	}
	
	$i++;
	$n++;
	
}

for($x=0; $x<$n; $x++) {

    $a[$x]['next_id'] = $a[$x+1]['id'];
	$a[$x]['prev_id'] = $a[$x-1]['id'];
	
}
$a[0]['prev_id'] = $a[$n-1]['id'];
$a[$n-1]['next_id'] = $a[0]['id'];

$smarty->assign('playlist', $a);



$smarty->display('embed.tpl');
?>