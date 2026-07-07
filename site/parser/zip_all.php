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

initDB();

$res = mysql_query('SELECT id, filename FROM muzx_songs')
	or die(mysql_error());
while ($row = mysql_fetch_row($res))
{
	$idName = SONG_STORAGE.sprintf('/%08X', $row[0]);

	$f = fopen($idName, 'rb')
		or die();
	$buf = fread($f, 4);
	fclose($f);
	if ($buf == "PK\3\4") continue;

	$fileName = SONG_STORAGE."/$row[1]";
	rename($idName, $fileName) 
		or die();
	$zip = new Archive_Zip($idName);
	$zip->create(array($fileName))
		or die('zip failed');
	unset($zip);	
	unlink($fileName)
		or die('unlink failed');
}
mysql_free_result($res);

doneDB();

?>
</body>

</html>