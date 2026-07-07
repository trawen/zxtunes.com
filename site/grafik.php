<?php

for ($i=0; $i<25; $i++) {$yg[$i]=$_REQUEST['yg'.$i];}
for ($i=1984; $i<2009; $i++) {$ys[$i-1984]=$_REQUEST['ys'.$i];}

$im1 = imagecreate(652, 200);
$background_color = imagecolorallocate($im1, 255, 255, 255);
$text_color = imagecolorallocate($im1, 0, 0, 0);
$color1 = imagecolorallocate($im1, 240, 0, 0);
$color2 = imagecolorallocate($im1, 0, 0, 240);
$color3 = imagecolorallocate($im1, 240, 0, 240);

$n0=196; $n2=196;
for ($i=0; $i<25; $i++) {imagestring($im1, 1, 11+($i*25), 188, $i+1984, $text_color);
imageline ($im1, 22+($i*25), 182, 22+($i*25), 178, $text_color);
$n1=176-$yg[$i]/2;
$n3=176-$ys[$i]/11;
if ($i) {imageline ($im1, 20+(($i-1)*25), $n0, 20+($i*25), $n1, $text_color);
//imageline ($im1, 20+(($i-1)*25), $n2, 20+($i*25), $n3, $color3);
}
imagefilledrectangle($im1, 21+($i*25), $n1-1, 23+($i*25), $n1+1, $color2 );
//imagefilledrectangle($im1, 21+($i*25), $n3-1, 23+($i*25), $n3+1, $color2 );

imagestring($im1, 1, 17+($i*25), $n1-11, $yg[$i], $color1);
$n0=$n1; $n2=$n3;}

imageline ($im1, 10, 184, 10, 8, $text_color);
imageline ($im1, 7, 180, 640, 180, $text_color);

imageline ($im1, 640, 178, 644, 180, $text_color);
imageline ($im1, 640, 182, 644, 180, $text_color);

imageline ($im1, 8, 9, 10, 4, $text_color);
imageline ($im1, 12, 9, 10, 4, $text_color);

imagestring($im1, 1, 2, 171, "Y", $color2);
imagestring($im1, 1, 2, 188, "X", $color2);

imagestring($im1, 2, 20, 16, "Y", $color2);
imagestring($im1, 2, 20, 30, "X", $color2);

imagestring($im1, 2, 30, 16, "- Active authors", $text_color);
imagestring($im1, 2, 30, 30, "- Years", $text_color);

header ("Content-type: image/png");
imagepng($im1);
imagedestroy($im1);
?>