<?php
require 'common.inc.php';
require 'parser.inc.php';

initDB();

$num=0;

$mysql_resource = mysql_query('SELECT YEAR(FROM_UNIXTIME(years_from)) as year_from, YEAR(FROM_UNIXTIME(years_to)) as year_to FROM muzx_authors');
if (!$mysql_resource)
{
	break;
}
else
{
	$result_array = array();
	while ($result_row = mysql_fetch_array($mysql_resource))
	{   		
		if ($result_row['year_from'] and $result_row['year_from']) 
		{
			for ($i = $result_row['year_from']; $i < $result_row[1]+1; $i++) 
			{
				$ym[$i-1980]++;
			}
			$num++;
		} 
		elseif ($result_row['year_from'])
		{
			$ym[$row['year_from']-1980]++; 
			$num++;
		}
		
	}
	mysql_free_result($mysql_resource);
	/*
	for ($i = 0; $i < 28; $i++) 
	{
		$a=$i+1980; 
		echo "$a = $ym[$i] <br>";
	}
	*/
}

closeDB();

$im = imagecreate(650, 300);
$background_color = imagecolorallocate($im, 240, 240, 240);
$text_color = imagecolorallocate($im, 0, 0, 0);
$line_color = imagecolorallocate($im, 10, 10, 250);
imageline($im, 16, 16, 16, 280, $line_color);
imageline($im, 16, 280, 380, 280, $line_color);
$nm=1984;

$a = 4;
for ($i = 20; $i <620; $i+=25) 
{
	//imageline($im, $i, 280, $i, 282, $line_color);
	$row = imagecolorallocate($im, 220, 220, 220);
	ImageFilledRectangle($im, $i-1, abs(270-$ym[$a]), $i+20, 277, $row);
	imagestring($im, 1, $i, 270, $nm, $text_color);
	$nm++;
	$a++;
}

header ("Content-type: image/png");
imagepng($im);
imagedestroy($im);
?>