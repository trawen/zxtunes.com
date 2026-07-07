<?php
require 'ini.php';
require_once __DIR__ . '/includes/auth.php';
zxtunes_require_admin();

error_reporting(E_ALL);

$id = (($_REQUEST['id'] ?? '') === 'create') ? 'create' : (int) $_REQUEST['id'];
$update_=$_REQUEST['update'];
$nickname_=$_REQUEST['nickname'];

$first_name_=$_REQUEST['first_name'];
$last_name_=$_REQUEST['last_name'];
$first_name_en_=$_REQUEST['first_name_en'];
$last_name_en_=$_REQUEST['last_name_en'];


$group_=$_REQUEST['group'];
$years_from_=$_REQUEST['years_from'];
$years_to_=$_REQUEST['years_to'];
$city_=$_REQUEST['city'];
$country_=$_REQUEST['country'];
$city_en_=$_REQUEST['city_en'];
$country_en_=$_REQUEST['country_en'];
$icq_=$_REQUEST['icq'];
$email1_=$_REQUEST['email1'];
$email2_=$_REQUEST['email2'];
$email_hidden1_=$_REQUEST['email_hidden1'];
$email_hidden2_=$_REQUEST['email_hidden2'];

$url_=$_REQUEST['url'];
$spec_=$_REQUEST['spec'];

$also1_=$_REQUEST['also1'];
$also2_=$_REQUEST['also2'];
$also3_=$_REQUEST['also3'];
$also4_=$_REQUEST['also4'];
$also5_=$_REQUEST['also5'];


$group1=$_REQUEST['group1'];
$group2=$_REQUEST['group2'];
$group3=$_REQUEST['group3'];
$group4=$_REQUEST['group4'];
$group5=$_REQUEST['group5'];
$association1=$_REQUEST['association1'];
$association2=$_REQUEST['association2'];
$association3=$_REQUEST['association3'];
$association4=$_REQUEST['association4'];
$association5=$_REQUEST['association5'];
$ex1=$_REQUEST['ex1'];
$ex2=$_REQUEST['ex2'];
$ex3=$_REQUEST['ex3'];
$ex4=$_REQUEST['ex4'];
$ex5=$_REQUEST['ex5'];
$id_gr1=$_REQUEST['id_gr1'];
$id_gr2=$_REQUEST['id_gr2'];
$id_gr3=$_REQUEST['id_gr3'];
$id_gr4=$_REQUEST['id_gr4'];
$id_gr5=$_REQUEST['id_gr5'];

$about_en_=$_REQUEST['about_en'];
$about_ru_=$_REQUEST['about_ru'];

$dead=$_REQUEST['dead'];

$similar1_=$_REQUEST['similar1'];
$similar2_=$_REQUEST['similar2'];
$similar3_=$_REQUEST['similar3'];
$similar4_=$_REQUEST['similar4'];
$similar5_=$_REQUEST['similar5'];

$delete=$_REQUEST['delete'];
$save=$_REQUEST['save'];
$upload=$_REQUEST['upload'];
$save_song=$_REQUEST['save_song'];
$md=$_REQUEST['md'];
$update_zip=$_REQUEST['update_zip'];

if (!$md) {$md="profile";}




$hidden=$_REQUEST['hidden'];
if ($hidden) {$hidden=1;}
if ($email_hidden1_) {$email_hidden1_=1;}
if ($email_hidden2_) {$email_hidden2_=1;}

$r_mes="";

$tm=time();











if ($delete=="DELETE") {
	csrf_verify();
	$id = (int) $id;
$r_mes.='<br>"'.h($nickname_).'" deleted OK!';
db_execute('DELETE FROM muzx_authors WHERE id=? LIMIT 1', 'i', [$id]);
db_execute(
	'INSERT INTO log (`update`, event, event_id, type, hidden, misc) VALUES (?, 0, ?, 0, ?, ?)',
	'iiis',
	[$tm, $id, (int) $hidden, $nickname_]
);
}





if ($save=="SAVE") { 

csrf_verify();

$profile_params = [
	$nickname_, $first_name_, $last_name_, $first_name_en_, $last_name_en_,
	$years_from_, $years_to_, $city_, $city_en_, $country_, $country_en_,
	$icq_, $url_, $email1_, $email2_,
	(int) $email_hidden1_, (int) $email_hidden2_,
	$spec_, $similar1_, $similar2_, $similar3_, $similar4_, $similar5_,
	$also1_, $also2_, $also3_, $also4_, $also5_,
];

if ($id=="create") {

db_execute(
	'INSERT INTO muzx_authors (nickname, first_name, last_name, first_name_en, last_name_en, years_from, years_to, city, city_en, country, country_en, icq, url, email1, email2, email_hidden1, email_hidden2, spec, similar1, similar2, similar3, similar4, similar5, also1, also2, also3, also4, also5, last_update, dead) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
	'sssssssssssssssiiissssssssssii',
	array_merge($profile_params, [$tm, $dead])
);
$id = db_insert_id();
}

else {
db_execute(
	'UPDATE muzx_authors SET nickname=?, first_name=?, last_name=?, first_name_en=?, last_name_en=?, years_from=?, years_to=?, city=?, city_en=?, country=?, country_en=?, icq=?, url=?, email1=?, email2=?, email_hidden1=?, email_hidden2=?, spec=?, similar1=?, similar2=?, similar3=?, similar4=?, similar5=?, also1=?, also2=?, also3=?, also4=?, also5=?, last_update=? WHERE id=? LIMIT 1',
	'sssssssssssssssiiissssssssssii',
	array_merge($profile_params, [$tm, (int) $id])
);
}


$r_mes.= "<br>Profile updated OK."; $lu=time();

if ($_FILES['uploadfile']['name']) {
$scr=getimagesize($_FILES['uploadfile']['tmp_name']);
if ($scr[2]!=2 or $scr[0]>350 or $scr[1]>350) {$r_mes.= "<br>Image file error!";}
elseif ($_FILES['uploadfile']['size']>50000) {$r_mes.= "<br>File size too big!";}
else {


if (is_file("photo/".$id.".jpg")) {$upi=3; $r_mes.= "<br>Photo update OK."; chmod("photo/".$id.".jpg", 0777 ); unlink("photo/".$id.".jpg"); ;}
else {$r_mes.= "<br>Photo upload OK."; $upi=1;}
move_uploaded_file($_FILES['uploadfile']['tmp_name'] , "photo/".$id.".jpg");
chmod("photo/".$id.".jpg", 0755 );



db_execute(
	'INSERT INTO log (`update`, event, event_id, type, hidden) VALUES (?, ?, ?, 1, ?)',
	'iiii',
	[$tm, (int) $upi, (int) $id, (int) $hidden]
);
db_execute('UPDATE muzx_authors SET photo=1 WHERE id=? LIMIT 1', 'i', [(int) $id]);
}
}




 
for ($i=1; $i<6; $i++) {${status.$i}=${association.$i} ? 1 : 0; ${status.$i}|= ${ex.$i} ? 2 : 0;} 

for ($i=1; $i<6; $i++) {
$gid = (int) (${'id_gr'.$i} ?? 0);
$gr = (int) (${'group'.$i} ?? 0);
$st = (int) (${'status'.$i} ?? 0);

if ($gid>0 and $gr>0) {
db_execute('UPDATE group_authors SET group_id=?, author_id=?, status=? WHERE id=? LIMIT 1', 'iiii', [$gr, (int) $id, $st, $gid]);
	}

elseif (!$gid and $gr>0) {
db_execute('INSERT INTO group_authors (group_id, author_id, status) VALUES (?, ?, ?)', 'iii', [$gr, (int) $id, $st]);
	}

elseif ($gid>0 and $gr==0) {
db_execute('DELETE FROM group_authors WHERE id=? LIMIT 1', 'i', [$gid]);
	}
}




if ($group1) {
$group1 = (int) $group1;
$grn = db_fetch_one('SELECT name FROM `groups` WHERE id=? LIMIT 1', 'i', [$group1]);
if ($grn) {
db_execute('UPDATE muzx_authors SET group_name=?, group_id=? WHERE id=? LIMIT 1', 'sii', [$grn['name'], $group1, (int) $id]);
}
}


if (!$upi) {db_execute('INSERT INTO log (`update`, event, event_id, type, hidden) VALUES (?, 0, ?, 1, ?)', 'iii', [$tm, (int) $id, (int) $hidden]);}


}

if ($save_song=="SAVE") {
csrf_verify();
require "rip.inc";



$n=0;
while ($_REQUEST['tune_id'.$n]) {
	$td=(int) $_REQUEST['tune_id'.$n];
	$fnm=$_REQUEST['filename'.$n]; 	
	$tl=$_REQUEST['title'.$n];
	$yr=(int) $_REQUEST['year'.$n];
	$dn=$_REQUEST['denied'.$n]; if ($dn) {$dn=1;} else {$dn=0;}
	$hd=$_REQUEST['hidden'.$n]; if ($hd) {$hd=1;} else {$hd=0;}
	db_execute(
		'UPDATE muzx_songs SET filename=?, name=?, year=?, denied=?, last_update=?, hidden=? WHERE id=? AND (filename!=? OR name!=? OR year!=? OR hidden!=? OR denied!=?) LIMIT 1',
		'ssiiiiissiii',
		[$fnm, $tl, $yr, $dn, $tm, $hd, $td, $fnm, $tl, $yr, $hd, $dn]
	);
	$n++;
}




for ($i=1; $i<4; $i++) {
	
	if ($_FILES['upload_tune'.$i]['name']) {
	  $ext=getext($_FILES['upload_tune'.$i]['name']);
	  if ($ext=="pt2" or $ext=="pt1" or $ext=="pt3" or $ext=="sqt" or $ext=="stc" or $ext=="stp" or $ext=="ftc"  or $ext=="asc" or $ext=="gtr" or $ext=="fls" or $ext=="ay" or $ext=="sna" or $ext=="ym" or $ext=="vtx" or $ext=="psc" or $ext=="psm") {
	  
      $title=parser($_FILES['upload_tune'.$i]['tmp_name'], $_FILES['upload_tune'.$i]['name'] );
	  
	  if (import($title, 0, $_FILES['upload_tune'.$i]['name'], $_FILES['upload_tune'.$i]['tmp_name'], $id)) 
	  {$r_mes.="<br>\"".$_FILES['upload_tune'.$i]['name']."\" upload OK.";
	   $_SESSION['author_update'][$id]++;
	  }
	  else {$r_mes.="<br>\"".$_FILES['upload_tune'.$i]['name']."\" upload ERROR!.";}
      
	  }
	  elseif ($ext=="zip") {
	  
	  include_once('pclzip.lib.php');
	  
	  $sid=session_id();
	  mkdir("temp/".$sid, 0777);
	  $folder="temp/".$sid."/";
	  $archive = new PclZip($_FILES['upload_tune'.$i]['tmp_name']);
	  $list = $archive->extract(PCLZIP_OPT_PATH, $folder);
	  if ($list == 0) {die("Error : ".$archive->errorInfo(true));}
	  
	  

	  
	  
	  
	 $f=0; 
	 $d=0;  
     $rip="temp";
	 $name1=$sid;
	 $handle2=opendir($rip."/".$name1);
	
	 while (false !== ($name2 = readdir($handle2))) {
	  $year=0;
	  if (is_file($rip."/".$name1."/".$name2) and $name2!=".." and $name2!=".") {
	      $title=parser($rip."/".$name1."/".$name2, $name2);
		  import($title, $year, $name2, $rip."/".$name1."/".$name2, $id);
	   //   echo "\\\\".$name2." - <b>".$title."</b><br>";
		  $f++; $d++;}
		  	  
	  elseif (is_dir($rip."/".$name1."/".$name2) and $name2!=".." and $name2!=".") {
	   $year=$name2;
	 //  echo "\\".$name2."<br>"; 
	   $handle3=opendir($rip."/".$name1."/".$name2);
	   while (false !== ($name3 = readdir($handle3))) {
	   if (is_file($rip."/".$name1."/".$name2."/".$name3) and $name3!=".." and $name3!=".") {
           $title=parser($rip."/".$name1."/".$name2."/".$name3, $name3);
		   import($title, $year, $name3, $rip."/".$name1."/".$name2."/".$name3, $id);
		   
	     //  echo "\\\\".$name3." - <b>".$title."</b><br>"; 
		   $f++; $d++;}
		  
	   }
	   closedir($handle3);
	   }
	  }
	//  echo " - ".$d."<br>";
	  closedir($handle2);
	 $_SESSION['author_update'][$id]+=$f;
	 removeDirRec("temp/".$sid);
	 }
	 else {$r_mes.="<br>\"".$_FILES['upload_tune'.$i]['name']."\" uknown file format.";}
  }
       	
}


$kt = db_fetch_one(
	'SELECT COUNT(*) AS cnt FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? AND muzx_songs.hidden!=1',
	'i',
	[(int) $id]
);
db_execute('UPDATE muzx_authors SET num_tracks=? WHERE id=? LIMIT 1', 'ii', [(int) ($kt['cnt'] ?? 0), (int) $id]);

}












if ($update_zip=="UPDATE ARCHIVE") {

csrf_verify();


include_once('pclzip.lib.php');
require('rip.inc');

function myPreAddCallBack($p_event, &$p_header)
{global $tname;
 $info = pathinfo($p_header['filename']);
if (!$info['extension']) {
if ($tname['t'.$p_header['stored_filename']][1]) {
$p_header['stored_filename']=  $tname['t'.$p_header['stored_filename']][1]."/".$tname['t'.$p_header['stored_filename']][0];}
else {$p_header['stored_filename'] = $tname['t'.$p_header['stored_filename']][0];}
}
else {$p_header['stored_filename']=$info['basename'];}
return 1;
}



  

  
  
  
  
$au = db_fetch_one('SELECT * FROM muzx_authors WHERE id=? LIMIT 1', 'i', [(int) $id]) ?? [];



$about="Nickname: ".$au['nickname'].chr(13).chr(10);

if (!$au['years_from'] and !$au['years_to']) {$y="n/a";}
elseif (!$au['years_to'] and $au['years_from']) {$y=$au['years_from'];}
elseif ($au['years_from'] != $au['years_to'] and $au['years_to'] and $au['years_from']) {$y=$au['years_from']."-".$au['years_to'];}
elseif ($au['years_from'] == $au['years_to']) {$y=$au['years_from'];}

$n=0; $m=0;
for ($i=1; $i<6; $i++) {

if ($au['also'.$i]) {$m++;
if (!$n) {$about.="also known as: ";}
if ($n) {$about.= ", ";} 
$about.= $au['also'.$i];}
$n++;
}
if ($m) {$about.= chr(13).chr(10);}


$about.= "Name: ";
if ($au['first_name_en'] or $au['last_name_en']) {$about.= $au['first_name_en']." ".$au['last_name_en'].chr(13).chr(10);}
else {$about.= "n/a".chr(13).chr(10);}



$about.= "Group: "; 

$group_rows = db_fetch_all('SELECT group_authors.*, `groups`.* FROM group_authors JOIN `groups` ON `groups`.id = group_authors.group_id WHERE group_authors.author_id=?', 'i', [(int) $id]);
$n=0; foreach ($group_rows as $group) {

	if ($n>0) {$about.= ", ";};
	if ($group['status']&2) {$about.= "ex ".$group['name'];}
	else {$about.= $group['name'];}
	$grid[$n]['id']=$group['group_id'];
	$grid[$n]['name']=$group['name'];
	$n++;
}
if ($n==0) {$about.= "-";}

$m=0; $n=0;
while ($grid[$m]['id']) {$idx=$grid[$m]['id'];
$others_rows = db_fetch_all('SELECT muzx_authors.id, muzx_authors.nickname FROM muzx_authors JOIN group_authors ON muzx_authors.id = group_authors.author_id WHERE group_authors.group_id=?', 'i', [(int) $idx]); $m++;
foreach ($others_rows as $others) {
  
  if ($others['id']!=$id) {  $oth_auth[$n]['nickname']=$others['nickname']; $oth_auth[$n]['id']=$others['id']; $n++;}
		

}
}
$z=0;
for ($i=0; $i<$n; $i++) {$f=0; for ($x=0; $x<=$i; $x++) {if ($oth_auth[$i]['id']==$oth_auth2[$x]['id']) {$f++;}}
if (!$f) { $oth_auth2[$z]['id']=$oth_auth[$i]['id']; $oth_auth2[$z]['nickname']=$oth_auth[$i]['nickname']; $z++;}
}

for ($i=0; $i<$z; $i++) {if ($i>0) {$about.= ", ";}
if ($i==0) {$about.= chr(13).chr(10)."others members: ";}
$about.= $oth_auth2[$i]['nickname'];}
$about.= chr(13).chr(10).chr(13).chr(10);





$about.= "Specialization: ".$au['spec'].chr(13).chr(10);
$about.= "Active years: ".$y.chr(13).chr(10).chr(13).chr(10);

$about.= "City: ";
if ($au['city']) {$about.= $au['city_en'].chr(13).chr(10);}
else {$about.= "n/a".chr(13).chr(10);;}

$about.= "Country: ";
if ($au['country']) {$about.= $au['country_en'].chr(13).chr(10);}
else {$about.= "n/a".chr(13).chr(10);}
$about.= chr(13).chr(10);

$about.= "E-Mail: "; 
if ($au['email1']) {$about.= $au['email1'].chr(13).chr(10);}
else {$about.= "n/a".chr(13).chr(10);}

$about.= "ICQ: "; if ($au['icq']) {$about.= $au['icq'].chr(13).chr(10);} else {$about.= "n/a".chr(13).chr(10);}
$about.= "Site: "; if ($au['url']) {$about.= "http://".$au['url']."/".chr(13).chr(10);} else {$about.= "n/a".chr(13).chr(10);}

$about.= chr(13).chr(10);

$about.= "Tunes: ".$au['num_tracks'].chr(13).chr(10);
$about.= "Last update: ".date("d.m.Y", $au['last_update']).chr(13).chr(10).chr(13).chr(10).chr(13).chr(10);

$about.= "Profile URL: /author_profile.php?id=".$id."/".chr(13).chr(10);

$fl=fopen("tunes_zip/".$au['nickname'].".txt", "w");
if ($fl) {if (!fwrite($fl, $about)) {$r_mes.="<br>Error write in profile file.";}; fclose($fl); 
		 chmod("tunes_zip/".$au['nickname'].".txt", 0755 );}
else {$r_mes.="<br>Error create profile file.";}














$plist="ZX Spectrum Sound Chip Emulator Play List File v1.5".chr(13).chr(10);
$tlist="tunes_zip/".$au['nickname'].".ayl,tunes_zip/".$au['nickname'].".txt,tunes_zip/readme.txt,";


$zip_songs = db_fetch_all('SELECT muzx_songs.*, muzx_songs_authors.song_id FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? AND muzx_songs.hidden=0 AND muzx_songs.denied=0 ORDER BY muzx_songs.year DESC', 'i', [(int) $id]);
foreach ($zip_songs as $tunes) {
$hex=sprintf("%08X", $tunes['song_id']);
$tlist.="tunes/".$hex.",";
$tname['t'.$hex][0]=$tunes['filename'];
$tname['t'.$hex][1]=$tunes['year'];

if ($tunes['year']) {$plist.=$tunes['year']."\\";}

$plist.=$tunes['filename'].chr(13).chr(10);

$tit=parser("tunes/".$hex, $tunes['filename']);
if (!$tit) {$tit=substr($tunes['filename'], 0, strlen($tunes['filename'])-strlen($ext)-1);}

$plist.="<".chr(13).chr(10)."Name=".$tit.chr(13).chr(10);
$plist.="Author=".$au['nickname'].chr(13).chr(10).">".chr(13).chr(10);

}
$tlist=substr($tlist, 0, strlen($tlist)-1);

$fl=fopen("tunes_zip/".$au['nickname'].".ayl", "w");
if ($fl) {if (!fwrite($fl, $plist)) {$r_mes.="<br>Error write in playlist file.";}; fclose($fl); 
		 chmod("tunes_zip/".$au['nickname'].".ayl", 0755 );}
else {$r_mes.="<br>Error create playlist file.";}


 
  $archive = new PclZip('tunes_zip/'.sprintf("%08X", $id));
  $v_list = $archive->create($tlist, PCLZIP_CB_PRE_ADD, 'myPreAddCallBack', PCLZIP_OPT_REMOVE_PATH, 'tunes');
  if ($v_list == 0) {die("Error : ".$archive->errorInfo(true));}
  else {$r_mes.="<br>Archive update OK.";}
  
  

db_execute('UPDATE muzx_authors SET zip_update=? WHERE id=? LIMIT 1', 'ii', [$tm, (int) $id]);
}








// REDIRECT
if ($delete=="DELETE" or $save=="SAVE" or $save_song=="SAVE" or $update_zip=="UPDATE ARCHIVE") {
  if ($r_mes) {$_SESSION['r_mes']="<b>".$r_mes."</b><br>";}
  if ($save_song=="SAVE" or $update_zip=="UPDATE ARCHIVE") {$ad="&md=tunes";} else {$ad="";}
  header("Location: /adminka_author_edit.php?id=".$id.$ad);
  exit;	
}



















require 'menu_top.php';
if (zxtunes_is_admin()) {echo "<br><a href='/adminka.php?'>Authors</a> : <a href='/adminka.php?admd=groups'>Groups</a> : <a href='/adminka_author_edit.php?id=create'>Create Author</a> : <a href='/adminka_group_edit.php?id=create'>Create Group</a><br>";}

if ($md=="tunes") {echo "<br><b><a href='/adminka_author_edit.php?id=".$id."'>profile</a> &#160&#160&#160 [tunes]</b>";}
else {echo "<br><b>[profile] &#160&#160&#160 <a href='/adminka_author_edit.php?id=".$id."&md=tunes'>tunes</a></b>";}

echo $_SESSION['r_mes']; $_SESSION['r_mes']="";
echo "<br>files: ".$_SESSION['author_update'][$id]."<br>";




	$author = db_fetch_one('SELECT * FROM muzx_authors WHERE id=? LIMIT 1', 'i', [(int) $id]);
	if ($author) {


if ($md=="profile") {

$sim="";
foreach (db_fetch_all('SELECT id, nickname FROM muzx_authors ORDER BY nickname ASC') as $auth)
	{$sim.='<option value="'.$auth['id'].'">'.h($auth['nickname']).'</option>';
	 if ($auth['id']==$author['similar1']) {$sm[1]=$auth['nickname'];}
	 if ($auth['id']==$author['similar2']) {$sm[2]=$auth['nickname'];}
	 if ($auth['id']==$author['similar3']) {$sm[3]=$auth['nickname'];}
	 if ($auth['id']==$author['similar4']) {$sm[4]=$auth['nickname'];}
	 if ($auth['id']==$author['similar5']) {$sm[5]=$auth['nickname'];}
	}
$sim.='<option value="0">---</option>';



$profile_groups = db_fetch_all(
	'SELECT group_authors.id AS ga_id, group_authors.group_id, group_authors.status, `groups`.name, `groups`.acronym, `groups`.site FROM group_authors JOIN `groups` ON `groups`.id = group_authors.group_id WHERE group_authors.author_id=?',
	'i',
	[(int) $id]
);
$kl_gr=1;
foreach ($profile_groups as $group1) {

$gr_auth[$kl_gr]['id']=$group1['ga_id'];
$gr_auth[$kl_gr]['id_gr']=$group1['group_id'];
$gr_auth[$kl_gr]['name']=$group1['name'];
$gr_auth[$kl_gr]['acronym']=$group1['acronym'];
$gr_auth[$kl_gr]['site']=$group1['site'];
$gr_auth[$kl_gr]['status']=$group1['status'];
$kl_gr++;
}
$kl_gr--;
$gr_op="";
foreach (db_fetch_all('SELECT id, name FROM `groups` ORDER BY name ASC') as $groups)
	{$gr_op.='<option value="'.$groups['id'].'">'.h($groups['name']).'</option>';
	}
$gr_op.='<option value="0">---</option>';

// echo "@".$sm[1]."@".$sm[2]."@".$sm[3]."@".$sm[4]."@".$sm[5];



echo "<br>";
echo "<form method='POST' enctype='multipart/form-data'><input type='hidden' name='_csrf' value='".h(csrf_token())."'>";
echo "<input type='hidden' name='id' value=$id>";
// if ($id=="create") {echo "create";}
// else {echo $author['id'];}
// echo ">";


$i=1;
while ($gr_auth[$i]['id']) {echo "<input type='hidden' name='id_gr".$i."' value='".$gr_auth[$i]['id']."'>"; $i++;}


echo "<table border=0><tr><td align=left valign=top>";
echo "<table border=0 cellspacing=8 cellpadding=0>";


if (zxtunes_is_admin()) {echo "<tr><td class='content_title'>id:</td><td>".$author['id']."</td></tr>
<tr><td class='content_title'>nickname:</td><td><input type='text' name='nickname' value=\"".$author['nickname']."\" maxlength='100' size='20'></td></tr>";}
else {echo "<tr><td><div class='big'>".$author['nickname']."</div></td></tr>
<input type='hidden' name='nickname' value=\"".$author['nickname']."\">";} 
?>



<tr><td class="content_title">specialization:</td><td>
<input type="text" name="spec" value="<?php echo $author['spec']?>" maxlength="64" size="64"></td></tr>

	
<tr><td class="content_title">first name</td>
<td>ru: <input type="text" name="first_name" value="<?php echo $author['first_name']?>" maxlength="30" size="35"> en: <input type="text" name="first_name_en" value="<?php echo $author['first_name_en']?>" maxlength="30" size="35"></td></tr>

	
<tr><td class="content_title">last name</td>
<td>ru: <input type="text" name="last_name" value="<?php echo $author['last_name']?>" maxlength="30" size="35"> en: <input type="text" name="last_name_en" value="<?php echo $author['last_name_en']?>" maxlength="30" size="35"></td></tr>
	
	

<tr><td class="content_title">years: </td><td>
<input type="text" name="years_from" value="<?php echo ($author['years_from'])?>" maxlength="4" size="4"> - <input type="text" name="years_to" value="<?php echo ($author['years_to'])?>" maxlength="4" size="4"></td></tr>

	
<tr><td class="content_title">city</td>
<td>ru: <input type="text" name="city" value="<?php echo $author['city']?>" maxlength="30" size="35"> en: <input type="text" name="city_en" value="<?php echo $author['city_en']?>" maxlength="30" size="35"></td></tr>

	
<tr><td class="content_title">country</td>
<td>ru: <input type="text" name="country" value="<?php echo $author['country']?>" maxlength="30" size="35"> en: <input type="text" name="country_en" value="<?php echo $author['country_en']?>" maxlength="30" size="35"></td></tr>


<tr><td class="content_title">group:</td><td valign=top>
<?php

for ($i=1; $i<=5; $i++) {
echo "<select name='group".$i."'>";

if ($gr_auth[$i]['id_gr'] and $gr_auth[$i]['id_gr']>0) {echo "<option value='".$gr_auth[$i]['id_gr']."'>".$gr_auth[$i]['name']."</option>";}
else {echo "<option selected value=''>---</option>";}

echo $gr_op."</select>";

echo ' association: <input type="checkbox" name="association'.$i.'"'; 
if ($gr_auth[$i]['status']&1) {echo "checked";}
echo '>';

echo ' ex: <input type="checkbox" name="ex'.$i.'"'; 
if ($gr_auth[$i]['status']&2) {echo "checked";}
echo '><br>';
}
echo "<td></tr>";
?>
</table>
</td>

<td>
<table><td class="content_title" align=right valign=top>
<?php
echo "<img src='";
if (is_file("photo/".$author['id'].".jpg")) {echo "/photo/".$author['id'].".jpg'>";} 
else {echo "/photo/nophoto.png'>";}
?>
<br>
photo: 
<input type="file" name="uploadfile"></td></table>
</td></tr></table>



<table cellspacing="8" cellpadding="0">
<tr><td class="content_title">also known as:</td><td>
<input type="text" name="also1" value="<?php echo $author['also1']?>" maxlength="16" size="20">
<input type="text" name="also2" value="<?php echo $author['also2']?>" maxlength="16" size="20">
<input type="text" name="also3" value="<?php echo $author['also3']?>" maxlength="16" size="20">
<input type="text" name="also4" value="<?php echo $author['also4']?>" maxlength="16" size="20">
<input type="text" name="also5" value="<?php echo $author['also5']?>" maxlength="16" size="20">
</td></tr>


<tr><td class="content_title">similar authors:</td><td>
<?php 
for ($i=1; $i<6; $i++) {
echo "<select name='similar".$i."'>";

if ($sm[$i]) {echo '<option value="'.$author['similar'.$i].'">'.$sm[$i].'</option>';}
else {echo "<option selected value='0'>---</option>";}

echo $sim."</select> ";
}
echo "</td></tr>";



echo "<tr><td class='content_title'>e-mail 1:</td><td>";
echo "<input type='text' name='email1' value='".$author['email1']."' maxlength='50' size='30'> hidden: <input type='checkbox' name='email_hidden1'"; if ($author['email_hidden1']) {echo "checked";}; echo " ></td></tr>";

echo "<tr><td class='content_title'>e-mail 2:</td><td>";
echo "<input type='text' name='email2' value='".$author['email2']."' maxlength='50' size='30'> hidden: <input type='checkbox' name='email_hidden2'"; if ($author['email_hidden2']) {echo "checked";}; echo " ></td></tr>"; ?>



<tr><td class="content_title">icq: </td><td>
<input type="text" name="icq" value="<?php echo $author['icq']?>" maxlength="13" size="10">

&#160&#160&#160&#160 <b> site: </b>
<input type="text" name="url" value="<?php echo $author['url']?>" maxlength="100" size="50"></td></tr>

	
<tr><td class="content_title">about</td>
<td>ru: <textarea type="text" name="about_en" cols="30" rows="3"><?php echo $author['about_ru']; ?></textarea>
	
en: <textarea type="text" name="about_ru" cols="30" rows="3"><?php echo $author['about_en']; ?></textarea></td></tr>

<?php if (zxtunes_is_admin()) {echo "<tr><td class='content_title'>deceased:</td><td>";
echo "<input type='text' name='dead' value='".$author['dead']."' maxlength='32' size='50'></td></tr>";} ?>

<tr><td><br></td></tr>

<tr><td class="content_title">last update:</td><td>
<?php echo date("d.m.Y", $author['last_update']); ?>

&#160&#160&#160&#160&#160&#160
 <b>hidden update:</b> <input type="checkbox" name="hidden" checked > 
<input type="submit" name="save" value="SAVE"></td><td>
<?php if (zxtunes_is_admin()) {echo "<input type='submit' name='delete' value='DELETE'></td></tr>";}?>


</table>
</td><td align=right valign=top>
</td></tr></table>
</form>






<?php



}

elseif ($md=="tunes") {



echo "<br><br><div class='n11a'><div class='big'>".$author['nickname']."</div><br><form method='POST' enctype='multipart/form-data'><input type='hidden' name='_csrf' value='".h(csrf_token())."'>";
echo "<table><tr><td colspan=2>upload tunes: ";

for ($i=1; $i<4; $i++) {echo "$i <input type='file' name='upload_tune".$i."'>&#160 ";}
echo "</td></tr><tr><td> &#160 </td></tr>";

echo "<tr><td><b>hidden update:</b> <input type='checkbox' name='hidden' checked > &#160 <input type='submit' name='save_song' value='SAVE'></td><td align='right'><input type='submit' name='update_zip' value='UPDATE ARCHIVE'> last update: ".date("d.m.y", $author['zip_update'])."</td></tr></table>";


$admin_songs = db_fetch_all('SELECT muzx_songs.* FROM muzx_songs JOIN muzx_songs_authors ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? ORDER BY last_update DESC', 'i', [(int) $id]);
$n=0; echo "<br><br><input type='hidden' name='id' value='".$author['id']."'>";
foreach ($admin_songs as $tunes) {
echo "<table cellpadding=0 cellspacing=5><tr><td><b>".$n."</b></td>";
echo "<td>file name: </td>";
echo "<td><textarea cols='80' rows='1' type='text' maxlength='80' name='filename".$n."'>".$tunes['filename']."</textarea>";
echo " year: <input type='text' maxsize='4' size='5' name='year".$n."' value='".$tunes['year']."'>";
echo " ".date("d.m.Y", $tunes['last_update'])."</td></tr>";

echo "<tr><td></td><td>title: </td><td><textarea cols='80' rows='1' type='text' name='title".$n."'>".$tunes['name']."</textarea>";

echo " denied: <input type='checkbox' name='denied".$n."'"; 
if ($tunes['denied']) {echo " checked ";}; echo ">";
echo " &#160&#160&#160&#160 hidden: <input type='checkbox' name='hidden".$n."'"; 
if ($tunes['hidden']) {echo " checked ";}; echo ">";



echo "</td></tr><input type='hidden' name='tune_id".$n."' value='".$tunes['id']."'></table>";
$n++;
}
echo "<input type='submit' name='save_song' value='SAVE'></form></div>";
}

}
closeDB();
require 'menu_end.php';
?>