<?php
$cc = $_REQUEST['cc'];
$im1 = imagecreate(60, 16);

$background_color = imagecolorallocate($im1, 255, 255, 255);


$a=1;
$x=0;
for ($i=1; $i<7; $i++) {
$text_color = imagecolorallocate($im1, rand(0,160), rand(0,160), rand(0,160));
imagestring($im1, 20, $x, -3+rand(0,6), substr($cc, $a, 1), $text_color);
$x=$x+10;
$a=$a+2;}


header ("Content-type: image/png");
imagepng($im1);
imagedestroy($im1);
?>