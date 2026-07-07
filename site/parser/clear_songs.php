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

if
(
	!mysql_query('DELETE FROM muzx_songs') 
	|| !mysql_query('DELETE FROM muzx_songs_authors')    
)
	dbError();
else
{
	if (!unlink('n_parsed'))
		errorMsg("Unable to delete file 'n_parsed'");
	else
		echo 'Song list cleared';
}

closeDB();

?>
</body>

</html>