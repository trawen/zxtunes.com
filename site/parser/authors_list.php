<?php
$order=$_REQUEST['order'];
$mask=$_REQUEST['mask'];
$letter=$_REQUEST['letter'];
$up=$_REQUEST['up'];
$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];



require 'common.inc.php';
require 'parser.inc.php';

initDB();

if (!$order) {$order="nickname";}
if (!$mask) {$mask=2;}
if (!$letter) {$letter="A";}
if (!$up) {$up="ASC";}
if (!$fr) {$fr=1;}
if (!$lm or $lm<30) {$lm=30;}
if ($order<>"nickname") {$letter="";}

$fr2=($fr-1)*30;


echo "Authors:<br><br>";




for ($i = 65; $i <= 90; $i++) {
	if (ord($letter)==$i and $order=="nickname" and $letter!="ALL") {echo "[".chr($i)."] ";
	} else {echo "<a href='?mask=".$mask."&letter=".chr($i)."&order=nickname'>".chr($i)."</a> ";}
}
if ($order!="nickname" or $letter=="ALL") {echo "[ALL]<br><br>";}
else {echo "<a href='?mask=".$mask."&order=nickname&letter=ALL'>ALL</a>"."<br><br>";}



$zapros2 = mysql_query("SELECT * FROM muzx_authors ");
if (!$zapros2) {echo mysql_error();}
else {$kl2 = mysql_num_rows($zapros2);}
mysql_free_result($zapros2);



if ($order=="nickname" and $letter!="ALL") {$like="WHERE nickname LIKE '".$letter."%'";} else {$like="";}
$ord="muzx_authors.".$order;

//echo "fr2=".$fr2." lm=".$lm;


$zapros = mysql_query("SELECT * FROM muzx_authors $like ORDER BY $ord $up ");
	
if (!$zapros)
	echo mysql_error();
else
{ $kl = mysql_num_rows($zapros);
  mysql_free_result($zapros);
}

$kl2=Ceil($kl/30);

//echo "[".$kl1."/".$kl2."]<br><br>";
echo "page: ";

for ($i = 1; $i <= $kl2; $i++) {
	if ($fr==$i and $lm==30) {echo "[".$i."] ";
	} else {echo "<a href='?id=".$id."&lm=30&fr=".$i."&order=".$order."&up=".$up."&letter=".$letter."'>".$i."</a> ";}
}
if ($lm>30) {echo " [ALL]<br><br>";} else {echo "<a href='?id=".$id."&lm=".$kl."&fr=1&order=".$order."&up=".$up."&letter=".$letter."'>ALL</a><br><br>";}

$zapros = mysql_query("SELECT * FROM muzx_authors $like ORDER BY $ord $up LIMIT $fr2, $lm");






echo "<table border=1><tr>";
echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=nickname&up=";
if ($order=="nickname" and $up=="ASC") {echo "DESC'>nickname</a> &#62";} elseif ($order=="nickname" and $up=="DESC") {echo "ASC'>nickname</a> &#60";} else {echo "ASC'>nickname</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=first_name&up=";
if ($order=="first_name" and $up=="ASC") {echo "DESC'>first_name</a> &#62";} elseif ($order=="first_name" and $up=="DESC") {echo "ASC'>first_name</a> &#60";} else {echo "ASC'>first_name</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=last_name&up=";
if ($order=="last_name" and $up=="ASC") {echo "DESC'>last name</a> &#62";} elseif ($order=="last_name" and $up=="DESC") {echo "ASC'>last name</a> &#60";} else {echo "ASC'>last name</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=group_name&up=";
if ($order=="group_name" and $up=="ASC") {echo "DESC'>group</a> &#62";} elseif ($order=="group_name" and $up=="DESC") {echo "ASC'>group</a> &#60";} else {echo "ASC'>group</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=num_tracks&up=";
if ($order=="num_tracks" and $up=="ASC") {echo "DESC'>tracks</a> &#62";} elseif ($order=="num_tracks" and $up=="DESC") {echo "ASC'>tracks</a> &#60";} else {echo "ASC'>tracks</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=years_from&up=";
if ($order=="years_from" and $up=="ASC") {echo "DESC'>years</a> &#62";} elseif ($order=="years_from" and $up=="DESC") {echo "ASC'>years</a> &#60";} else {echo "ASC'>years</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=city&up=";
if ($order=="city" and $up=="ASC") {echo "DESC'>city</a> &#62";} elseif ($order=="city" and $up=="DESC") {echo "ASC'>city</a> &#60";} else {echo "ASC'>city</a>";}
echo "</td>";

echo "<td><a href='?mask=".$mask."&letter=".$letter."&order=country&up=";
if ($order=="country" and $up=="ASC") {echo "DESC'>country</a> &#62";} elseif ($order=="country" and $up=="DESC") {echo "ASC'>country</a> &#60";} else {echo "ASC'>country</a>";}
echo "</td>";








if (!$zapros)
	echo mysql_error();
else
{
	while ($row1 = mysql_fetch_array($zapros))
	{
	    
		$y=date(Y,$row1['years_from'])."-".date(Y,$row1['years_to']);
		if (!$row1['years_to'] and $row1['years_from']) {$y=date(Y,$row1['years_from']);}
		elseif (!$row1['years_from']) {$y="&#160";}
		
		for ($i = 0; $i < 9; $i++) {
		if (!$row1[$i]) {$row1[$i]="&#160";}
		}
		if (!$row1['first_name']) {$row1['first_name']="&#160";}
		if (!$row1['last_name']) {$row1['last_name']="&#160";}
		if (!$row1['group_name']) {$row1['group_name']="&#160";}
		if (!$row1['num_tracks']) {$row1['num_tracks']="&#160";}
		if (!$row1['city']) {$row1['city']="&#160";}
		if (!$row1['country']) {$row1['country']="&#160";}
		
		$gr=$row1['group_name'];
		$ct=$row1['city'];
		if (strlen($gr)>32) {$gr=substr($gr, 0, 32)."...";} 
		if (strlen($ct)>16) {$ct=substr($ct, 0, 16)."...";} 
		echo "<tr>";
		echo "<td NOWRAP><a href='author_profile.php?id=".$row1['id']."'>".$row1['nickname']."</a></td>";
		echo "<td NOWRAP>".$row1['first_name']."</td>";
		echo "<td NOWRAP>".$row1['last_name']."</td>";
		echo "<td NOWRAP>".$gr."</td>";
		echo "<td NOWRAP>".$row1['num_tracks']."</td>";
		echo "<td NOWRAP>".$y."</td>";
		echo "<td NOWRAP>".$ct."</td>";
		echo "<td NOWRAP>".$row1['country']."</td>";
		echo "</tr>";
	}

mysql_free_result($zapros);

}

closeDB();
?>
</table>