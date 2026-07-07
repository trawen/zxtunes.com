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
require '../include/classes/Zip.php';

define('SRC_ZIP', "authors_rus2.zip");
define('DEST_DIR', '../song-source/authors/rus');
define('BUF_SIZE', 8192);

echo "file: ".filesize("authors_rus2.zip");

$zip = zip_open(SRC_ZIP);
$ok = $zip != false;
if (!$ok)
	errorMsg("Unable to open file '".SRC_ZIP."'");
else
{
	while ($ok and $ent = zip_read($zip))
	{
		$name = zip_entry_name($ent);
		/*
		if (strstr($name, 'Zoom') !== false)
			echo "$name<br />";
		continue;
		*/	
		$destName = DEST_DIR."/$name";
		if ($name[strlen($name) - 1] == '/')
			forceDir($destName);
		else
		{
			$ok = zip_entry_open($zip, $ent);
			if (!$ok)
				errorMsg("Unable to access '$name'");
			else
			{
			
				$f = fopen($destName, 'w');
				$ok = $f != false;
				if (!$ok)
				{
					errorMsg("Unable to create file '$destName'");
					$ok = false;
				}
				else
				{
					do {
						$buf = zip_entry_read($ent, BUF_SIZE);
						if (fwrite($f, $buf) != strlen($buf))
						{
							errorMsg("$destName: write error");
							$ok = false;
						}
					} while ($ok && strlen($buf) == BUF_SIZE);
					fclose($f);
				}
				zip_entry_close($ent);
			}
		}
	}
	zip_close($zip);
}
if ($ok) echo 'OK';


?>
</body>

</html>