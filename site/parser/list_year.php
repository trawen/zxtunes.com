<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<link rel="stylesheet" type="text/css" href="common.css" />
<title>Song collection parser</title>

</head>

<body>
<?php

require 'common.inc.php';
require 'parser.inc.php';

initDB();

$num=0;

$res1 = mysql_query('SELECT YEAR(FROM_UNIXTIME(years_from)), YEAR(FROM_UNIXTIME(years_to)) FROM muzx_authors');
if (!$res1)
	echo mysql_error();
else
{
	while ($row1 = mysql_fetch_row($res1))
		{   
	        
		if ($row1[0] and $row1[1]) {
			for ($i = $row1[0]; $i < $row1[1]+1; $i++) {$ym[$i-1980]++;}
			$num++;
		} 
		elseif ($row1[0]) {
		$ym[$row[0]-1980]++; 
		$num++;
		}
		
		
	}
	mysql_free_result($res1);
for ($i = 0; $i < 28; $i++) {$a=$i+1980; echo "$a = $ym[$i] <br>";}

}

closeDB();


$im = imagecreate(400, 300);
$background_color = imagecolorallocate($im, 255, 255, 255);
$text_color = imagecolorallocate($im, 233, 14, 91);
imagestring($im, 1, 5, 5,  "A Simple Text String", $text_color);
echo "<img src=";
//header ("Content-type: image/png");
imagepng($im);
imagedestroy($im);


?>
</body>

</html>