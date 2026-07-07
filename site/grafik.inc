<?php

$im1 = imagecreate(605, 220);
$background_color = imagecolorallocate($im1, 240, 240, 240);
$text_color = imagecolorallocate($im1, 0, 0, 0);




for ($i=1984; $i<2008; $i++) {
imagestring($im1, 1, ($i-1984)*26, 200, $i, $text_color);

}

header ("Content-type: image/png");
imagepng($im1);
imagedestroy($im1);
?>