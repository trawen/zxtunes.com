<br>
<table>
<tr>
<td>

<?php
$id=$_REQUEST['id'];
$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$up=$_REQUEST['up'];
$order=$_REQUEST['order'];

if (!$fr) {$fr=1;}
if (!$lm) {$lm=30;}
if (!$order) {$order="filename";}
if (!$up) {$up="ASC";}

$fr2=($fr-1)*30;

require 'common.inc.php';
require 'parser.inc.php';

initDB();

$zapros3 = mysql_query("UPDATE muzx_authors SET num_views=num_views+1 WHERE id=$id");
$zapros = mysql_query("SELECT * FROM muzx_authors WHERE id='$id' ");


if (!$zapros)
	echo mysql_error();
else
{ $row1 = mysql_fetch_array($zapros);

$grnm=$row1['group_name'];
$zapros4 = mysql_query("SELECT * FROM muzx_authors WHERE group_name='$grnm' ");


$y=date(Y,$row1['years_from'])."-".date(Y,$row1['years_to']);
if (!$row1['years_to'] and $row1['years_from']) {$y=date(Y,$row1['years_from']);}
elseif (!$row1['years_from']) {$y="&#160";}

echo "nick: ".$row1['nickname']."<br>";
echo "name: ".$row1['first_name']." ".$row1['last_name']."<br>";
echo "group: ".$row1['group_name']."<br>";


echo "others members: ";

if ($grnm) {
	$n=0;
	if (!$zapros4)
		echo mysql_error();
	else
		{ while ($row3 = mysql_fetch_array($zapros4))
			{if ($row3['nickname']!=$row1['nickname']) {
				if ($n>0) {echo ", ";};  echo "<a href='author_profile.php?id=".$row3['id']."'>".$row3['nickname']."</a>"; $n++;
				}
			 }
			 
		}
	}
else {echo "-";}	

echo "<br><br>";
mysql_free_result($zapros4);


echo "activity: ".$y."<br>";
echo "city: ".$row1['city']."<br>";
echo "country: ".$row1['country']."<br><br>";

echo "e-mail: ".$row1['email']."<br>";
echo "icq: ".$row1['icq']."<br>";
echo "url: ".$row1['url']."<br><br>";

echo "style: ".$row1['style']."<br>";
echo "tracks: ".$row1['num_tracks']."<br>";
echo "rating: "."<br>";
echo "Profile Views: ".$row1['num_views']."<br><br>";
echo "</td><td valign=top><img src='/photo/".$row1['id'].".jpg'></td></tr></table>";
//if (fopen("/photo/".$row1['id'].".jpg'")) {echo "/photo/".$row1['id'].".jpg'></td></tr></table>";} else {echo "/photo/nophoto.png'></td></tr></table>";}


}
	
	
mysql_free_result($zapros);



$zapros = mysql_query("SELECT * FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id" );
if (!$zapros)
	echo mysql_error();
else
{ $kl = mysql_num_rows($zapros);
  mysql_free_result($zapros);
}
  
$ord="muzx_songs.".$order;
  
  $zapros = mysql_query("SELECT * FROM muzx_songs, muzx_songs_authors WHERE muzx_songs_authors.author_id='$id' AND muzx_songs.id = song_id ORDER BY $ord $up LIMIT $fr2, $lm " );

$kl2=Ceil($kl/30);

echo "page: ";

for ($i = 1; $i <= $kl2; $i++) {
	if ($fr==$i and $lm==30) {echo "[".$i."] ";
	} else {echo "<a href='?id=".$id."&lm=30&fr=".$i."&order=".$order."&up=".$up."'>".$i."</a> ";}
}
if ($lm>30) {echo " [ALL]<br><br>";} else {echo "<a href='?id=".$id."&order=".$order."&lm=".$kl."&fr=1'>ALL</a><br><br>";}



echo "<table border=1><tr><td><b>#</b></td>";
echo "<td><a href='?id=".$id."&order=filename&lm=".$lm."&fr=".$fr."&up=";
if ($order=="filename" and $up=="ASC") {echo "DESC'>filename</a> &#62";} elseif ($order=="filename" and $up=="DESC") {echo "ASC'>filename</a> &#60";} else {echo "ASC'>filename</a>";}
echo "</td>";

echo "<td><a href='?id=".$id."&order=name&lm=".$lm."&fr=".$fr."&up=";
if ($order=="name" and $up=="ASC") {echo "DESC'>title</a> &#62";} elseif ($order=="name" and $up=="DESC") {echo "ASC'>title</a> &#60";} else {echo "ASC'>title</a>";}
echo "</td>";

echo "<td><a href='?id=".$id."&order=year&lm=".$lm."&fr=".$fr."&up=";
if ($order=="year" and $up=="ASC") {echo "DESC'>year</a> &#62";} elseif ($order=="year" and $up=="DESC") {echo "ASC'>year</a> &#60";} else {echo "ASC'>year</a>";}
echo "</td>";

echo "<td><a href='?id=".$id."&order=last_update&lm=".$lm."&fr=".$fr."&up=";
if ($order=="last_update" and $up=="ASC") {echo "DESC'>update</a> &#62";} elseif ($order=="last_update" and $up=="DESC") {echo "ASC'>update</a> &#60";} else {echo "ASC'>update</a>";}
echo "</td>";

echo "<td><a href='?id=".$id."&order=downloads&lm=".$lm."&fr=".$fr."&up=";
if ($order=="downloads" and $up=="ASC") {echo "DESC'>downloads</a> &#62";} elseif ($order=="downloads" and $up=="DESC") {echo "ASC'>downloads</a> &#60";} else {echo "ASC'>downloads</a>";}
echo "</td></tr>";







$n=$fr2+1;
if (!$zapros)
	echo mysql_error();
else
{ while ($row2 = mysql_fetch_array($zapros))
	{ 
	$y=date(Y, $row2['year']);
	if (!$y) {$y=" ";}
	echo "<tr><td>".$n."</td>";
	echo "<td><a href='/songs2.php?id=".$row2['id']."'>".$row2['filename']."</a></td>";
	echo "<td>".$row2['name']."</td>";
	echo "<td>".$y."</td>";
	echo "<td>".$row2['last_update']."</td>";
	echo "<td>".$row2['downloads']."</td></tr>";
	$n++;
}
echo "</table>";
mysql_free_result($zapros);
}

closeDB();
?>
