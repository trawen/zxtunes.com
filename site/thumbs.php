<?php

function resize($width, $height, $src, $dst, $ext ) {

	if( $ext=="gif" ) {	$image = imagecreatefromgif( $src );}
	elseif( $ext=="png" ) {	$image = imagecreatefrompng( $src );}
	elseif( $ext=="jpg" OR $ext=="jpeg" ) {	$image = imagecreatefromjpeg( $src );}
	
	
	list($width_orig, $height_orig) = getimagesize( $src );
			
	$ratio_orig = $width_orig/$height_orig;
		

	if ($width/$height > $ratio_orig) {
		$width = $height*$ratio_orig;
	} else {
		$height = $width/$ratio_orig;
	}
		
	$image_p = imagecreatetruecolor($width, $height);
	imagecopyresampled($image_p, $image, 0, 0, 0, 0, $width, $height, $width_orig, $height_orig);
	
	return imagejpeg($image_p, $dst, 90);
		
} 


function thumb($width, $height, $name, $dst) {

$fn = pathinfo($_FILES[$name]['name']);
$ext = strtolower($fn['extension']);
	
	
	if ($_FILES[$name]['tmp_name'] and ($ext=="png" or $ext=="jpg" or $ext=="jpeg" or $ext == "gif")) {

		resize($width, $height, $_FILES[$name]['tmp_name'], $dst, $ext);	
		//resize(50, $_FILES['image']['tmp_name'], $ext, "/img_news_thumbs/", $id);
	
	}

}

?>