<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<link rel="stylesheet" type="text/css" href="common.css" />
<title></title>

</head>

<body>
<?php

require 'common.inc.php';
require 'parser.inc.php';
require '../include/classes/Zip.php';

$dir = opendir(SONG_STORAGE) or die();

while (($name = readdir($dir)) !== false)
{
	if ($name == '.' || $name == '..') continue;

	$idName = SONG_STORAGE."/$name";
	
	$zip = new Archive_Zip($idName);
	$listing = $zip->listContent();

    if (substr($listing[0]['filename'], 0, 5) != 'songs')
    	echo htmlspecialchars($listing[0]['filename']), ' - skipped<br />';
	else
	{
		$fileName = SONG_STORAGE.'/'.basename($listing[0]['filename']);

		$zip->extract(array('remove_all_path' => true, 'add_path' => SONG_STORAGE))
			or die('extract failed');
		$zip->add(array($fileName), array('remove_all_path' => true))
			or die('add failed');
		$zip->delete(array('by_name' => array($listing[0]['filename'])))
			or die('delete failed');
		unlink($fileName) or die();
	}
	unset($zip);
}

closedir($dir);

?>
</body>

</html>