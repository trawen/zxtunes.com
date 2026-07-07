<?php

require 'ini.php';
require_once __DIR__ . '/includes/auth.php';

$app_root = getenv('APP_ROOT') ?: (__DIR__ . '/');
if (substr($app_root, -1) !== '/') {
	$app_root .= '/';
}

$interview=$_REQUEST['interview'];
$play=$_REQUEST['play'];
$id = (int) $_REQUEST['id'];
$md = $_REQUEST['md'];
$ip=$_SERVER["REMOTE_ADDR"];

if ($id) {
	zxtunes_require_author_edit($id);
}



if (!$md) {$md = "profile";}

function goodname($name) {

	return rawurlencode(strtolower($name));

}

function geturl($i){
  global $id,$md,$fr,$lm,$up,$order;
  $a="/author.php?id=".$id;
  if ($i) {$a.="&tnid=".$i;}
  if ($lm and $lm!=$nm) {$a.="&lm=".$lm;}
  if ($up and $up!='DESC') {$a.="&up=".$up;}
  if ($order and $order!='year') {$a.="&order=".$order;}
  return $a;
}







$nickname 	   = my('nickname');
$first_name    = my('first_name');
$last_name     = my('last_name');
$first_name_en = my('first_name_en');
$last_name_en  = my('last_name_en');
$also          = my('also');
$spec   	   = my('spec');
$city    	   = my('city');
$country 	   = my('country');
$years_from    = my('years_from');
$years_to      = my('years_to');
$email         = my('email');
$icq           = my('icq');
$site          = my('site');
$submit        = $_REQUEST['submit'];
$tm = time(); 



if ($id and $md=="profile" and ($submit=="Save" or $submit=="Сохранить")   ) {

	zxtunes_require_author_edit((int) $id);
	csrf_verify();

	$d = str_replace("/", ".", $_REQUEST['dead']);
	$d = explode(".", $d);
	$dead = mktime(0, 0, 0, $d[1], $d[0], $d[2]);

	if ($_REQUEST['locked' ] == "on") {$lock = $_SESSION['user_login'];} else {$lock = "";}
	
	require 'thumbs.php';	
		
	$photo = thumb(250, 300, "photo", $app_root . "photo/$id.jpg");
	thumb(48, 60, "photo", $app_root . "photo/60/$id.jpg");
		
	db_execute(
		'UPDATE muzx_authors SET nickname=?, first_name=?, last_name=?, first_name_en=?, last_name_en=?, years_from=?, years_to=?, city=?, country=?, icq=?, site=?, email=?, spec=?, also=?, last_update=?, dead=?, locked=? WHERE id=? LIMIT 1',
		'ssssssssssssssiisi',
		[$nickname, $first_name, $last_name, $first_name_en, $last_name_en, $years_from, $years_to, $city, $country, $icq, $site, $email, $spec, $also, $tm, $dead, $lock, $id]
	);
	
	
		for ($a=0; $a<6; $a++)	{
	
			$group = my('group_'.$a);
			$id_group = intval($group);
			$id_old_group = intval( $_REQUEST['old_group'.$a ] );
			if ($_REQUEST['ex_'.$a ] == "on") {$status = 1;} else {$status = 0;}
			  		
			//создана новая группа
			if ($group and $id_group == 0) {
					
				db_execute('INSERT INTO `groups` SET name=?', 's', [$group]);
				$id_group = db_insert_id();	
												
			}
			//выбрана другая группа
					
			if ($id_old_group and $id_group) {
			
				db_execute('UPDATE group_authors SET group_id=?, status=? WHERE id=?', 'iii', [$id_group, $status, $id_old_group]);	
				
			}
			elseif ($id_old_group and $group == 0) {
			
				db_execute('DELETE FROM group_authors WHERE id=? LIMIT 1', 'i', [$id_old_group]);	
							  
			}
			elseif ($id_group) {
			
				db_execute('INSERT INTO group_authors SET group_id=?, author_id=?, status=?', 'iii', [$id_group, $id, $status]);	
				
			}
		}	
	
	header("Location: /author_edit.php?id=$id&md=$md");
	exit;	
	
}
elseif ($id and $md=="music" and ($submit=="Save" or $submit=="Сохранить") ) {

	zxtunes_require_author_edit((int) $id);
	csrf_verify();


	$changes = array_unique(explode( "|", my('changes') ));
	
	foreach ($changes as $v) {
	
		$filename = my('filename_'.$v);
		$name = my('name_'.$v);
		$year = my('year_'.$v);
		$time = explode(":", my('time_'.$v));
		$wait = my('wait_'.$v);
		$format = my('format_'.$v);
		
		$time = $time[1]*50+($time[0]*(50*60));
		
		
		db_execute(
			'UPDATE muzx_songs SET filename=?, name=?, year=?, format=?, time=?, fym=? WHERE id=?',
			'ssisisi',
			[$filename, $name, (int) $year, $format, (int) $time, $wait, (int) $v]
		);
		
		//echo mysql_error();
		//echo $filename."<br>".$name."<br>".$year."<br>".$time."<br>".$wait."<br>".$format."<br>";
	
		//if (intval($v)) {echo "$v <br>";}
	}

	// $z = mysqli_query($db,"SELECT * FROM tags ORDER BY name");
	// while ($t = mysqli_fetch_array($z)) { 
		// $tags[ $t['id'] ] = $t['name'];
	// }
	

	// $cg = explode( "|", my('changes') );
	
	// foreach ($cg as $v) {
		// if (intval($v)) {$changes[ intval($v) ] = intval($v);}
	// }

	// foreach ($changes as $idt) {
		
		// $t = $_REQUEST['tgh_'.$idt]; 
		
		// if ($t) {
		
			// $tg = str_replace("><", "<", $t);
			// $tg = str_replace(">", "", $tg);
			// //unset($cg);					
			// $cgt = explode( "<", $tg );
		
			// echo $idt+" ";
		
			// foreach ($cgt as $v) {
				
				// if (intval($v)) {
					
					// echo $tags[$v] . " + ";
					
				// }
				
			// }
		
		// }
		
	// }
	
}



$smarty->compile_check = true;
$smarty->assign('active', array('authors' => 'class=active'));


$smarty->assign('id',$id);
$smarty->assign('mode',$md);
$smarty->assign('sel_link',"/author.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$ord);














$t = qr("muzx_authors", "id='$id'");

if ($t['dead']) {$t['dead'] = date("d.m.Y", $t['dead']);} else {$t['dead'] = "";}

$smarty->assign('author', $t);




























if ($md == "music") {


	$song_rows = db_fetch_all('SELECT muzx_songs.* FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? ORDER BY muzx_songs.year DESC, muzx_songs.filename ASC', 'i', [$id]);

	$n=0; 
	unset($a);
	foreach ($song_rows as $t) {
	
		$t['name'] = htmlentities($t['name']);
		$t['time'] = frame2time($t['time']);
		$t['nm'] = $n;
		$t['date'] = date("d.m.Y", $t['last_update']);
		$a[$n] = $t;
		$n++;
	
	}

	for($x=0; $x<$n; $x++) {

		$a[$x]['next_id'] = $a[$x+1]['id'];
		$a[$x]['prev_id'] = $a[$x-1]['id'];
	
	}
	$a[0]['prev_id'] = $a[$n-1]['id'];
	$a[$n-1]['next_id'] = $a[0]['id'];

	$smarty->assign('playlist', $a);

	
	
	if (is_file($app_root . "tunes_zip/".sprintf('%08X', $id))) {

		$szip = ceil(filesize($app_root . "tunes_zip/".sprintf('%08X', $id))/1000);
		$smarty->assign('szip', $szip);
	}
	
	

}
elseif ($md == "playlist") {

	$song_rows = db_fetch_all('SELECT muzx_songs.* FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? ORDER BY muzx_songs.year DESC, muzx_songs.filename ASC', 'i', [$id]);

	$n=0; 
	unset($a);
	foreach ($song_rows as $t) {
	
		$t['name'] = htmlentities($t['name']);
		$t['time'] = frame2time($t['time']);
		$t['nm'] = $n;
		
		$a[$n] = $t;
		$n++;
	
	}

	for($x=0; $x<$n; $x++) {

		$a[$x]['next_id'] = $a[$x+1]['id'];
		$a[$x]['prev_id'] = $a[$x-1]['id'];
	
	}
	$a[0]['prev_id'] = $a[$n-1]['id'];
	$a[$n-1]['next_id'] = $a[0]['id'];

	$smarty->assign('playlist', $a);

}
elseif ($md == "tags") {


	$tag_rows = db_fetch_all('SELECT * FROM tags ORDER BY name');
	foreach ($tag_rows as $t) { 
		$tg[] = $t;
		$tags[ $t['id'] ] = $t['name'];
	}
	$smarty->assign('tags', $tg);


	$song_rows = db_fetch_all('SELECT muzx_songs.* FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? ORDER BY muzx_songs.year DESC, muzx_songs.filename ASC', 'i', [$id]);

	$n=0; 
	unset($a);
	foreach ($song_rows as $t) {
	
		if ($last != $t['year']) {$t['print_year'] = $t['year']; $last = $t['year'];} else {$t['print_year'] = "";}
					
		unset($tg);			
		$tg = explode("|", $t['tags']);
		$new_tags = "";
		
		foreach ($tg as $v) {

			if ($v) {
			 
				$new_tags .= "<span onclick=DeleteTag(this,'$v','".$t['id']."')>".$tags[ $v ]." <span style='cursor: pointer;color:red'><sup>x</sup></span>&nbsp; &nbsp; </span>";
	
			}
		}
		
		
		$t['tags'] = $new_tags;
		$t['name'] = htmlentities($t['name']);
		$t['time'] = frame2time($t['time']);
		$t['nm'] = $n;
		
		$a[$n] = $t;
		$n++;
			
	}

	for($x=0; $x<$n; $x++) {

		$a[$x]['next_id'] = $a[$x+1]['id'];
		$a[$x]['prev_id'] = $a[$x-1]['id'];
	
	}
	$a[0]['prev_id'] = $a[$n-1]['id'];
	$a[$n-1]['next_id'] = $a[0]['id'];

	$smarty->assign('playlist', $a);
















}
elseif ($md==3) {


if ($interview) {
	$intv = db_fetch_one('SELECT * FROM interview WHERE int_id=? AND int_author_id=? LIMIT 1', 'ii', [(int) $interview, $id]);
} else {
	$intv = db_fetch_one('SELECT * FROM interview WHERE int_author_id=? LIMIT 1', 'i', [$id]);
}

	if ($intv) {
		$smarty->assign('interview', $intv);
		if (!$bot) {db_execute('UPDATE interview SET int_views=int_views+1 WHERE int_author_id=?', 'i', [$id]);}
	}
		
	
	if (($nm_interview[0] ?? 0) > 1) {

		$first = $intv['int_id'];
		$n = 0;
		$all_in = db_fetch_all('SELECT int_id, int_author_id, int_title FROM interview WHERE int_author_id=? AND int_id!=?', 'ii', [$id, (int) $first]);
		foreach ($all_in as $t) {
			$in[$n] = $t;
			$n++;
		}
		$smarty->assign('all_interview', $in);
	}
	
}
elseif ($md==4) {








$gb_rows = db_fetch_all('SELECT * FROM guestbook WHERE author_id=? ORDER BY `update` DESC', 'i', [$id]);
$gbk = db_fetch_one('SELECT COUNT(*) AS cnt FROM guestbook WHERE author_id=?', 'i', [$id]);
$gbk = ['cnt' => (int) ($gbk['cnt'] ?? 0), 0 => (int) ($gbk['cnt'] ?? 0)];
$n=0;
foreach ($gb_rows as $gb) {
$gb['nm']=$gbk[0];
if ($_SESSION['language']=="rus") {$m=$amdate[date("m", $gb['update'])];
$gb['update']=date("j $m Y", $gb['update']);}
else {$gb['update']=date("F j\\t\h Y", $gb['update']);}
$g[$n]=$gb;
$n++;
$gbk[0]--;
}



}

$smarty->assign('guestbook', $g);








foreach (db_fetch_all('SELECT DISTINCT city FROM muzx_authors ORDER BY city') as $t) { 
	$ct[] = $t;
}
$smarty->assign('cityes', $ct);


foreach (db_fetch_all('SELECT DISTINCT country FROM muzx_authors ORDER BY country') as $t) { 
	$cn[] = $t;
}
$smarty->assign('countries', $cn);


foreach (db_fetch_all('SELECT id, name FROM `groups` ORDER BY name') as $t) { 
	$gr[] = $t;
}
$smarty->assign('groups', $gr);


$n = 0;
foreach (db_fetch_all('SELECT * FROM group_authors WHERE author_id=?', 'i', [$id]) as $t) { 
	$t['nm'] = $n;
	$agr[] = $t;
	$n++;
}
$smarty->assign('author_groups', $agr);
if ($n) {$n -= 1;} else {$n = 0;}
$smarty->assign('nm_groups', $n);


foreach (db_fetch_all('SELECT id, nickname FROM muzx_authors ORDER BY nickname') as $t) { 
	$at[] = $t;
}
$smarty->assign('authors', $at);


foreach (db_fetch_all('SELECT * FROM similar_authors WHERE author1_id=? OR author2_id=?', 'ii', [$id, $id]) as $t) { 
	$si[] = $t;
}
$smarty->assign('similar_authors', $si);









$smarty->assign('autoplay', $_REQUEST['play']);

$smarty->assign('fym_hidden', $_REQUEST['fym_hidden']);

if ($kl < 20) {$nmtrpl = 150 + $kl * 22;}
else {$nmtrpl = 600;} 
$smarty->assign('nmtrpl', $nmtrpl);


$smarty->assign('id_fym', sprintf("%04d", $id));
$smarty->assign('md', $md);

include "right_strip.php";  

$smarty->display('author_edit.tpl');
?>