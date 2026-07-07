<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<link rel="stylesheet" type="text/css" href="common.css" />
<title>ZXTunes database checker</title>

</head>

<body>
<?php

require 'common.inc.php';

initDB();

if (!mysql_query('CREATE TABLE muzx_check (id INT, linked BOOL DEFAULT FALSE)'))
	dbError();
else
{
	if (!mysql_query('INSERT INTO muzx_check SELECT id FROM muzx_songs'))
		dbError();
	{
	}
	mysql_query('DROP TABLE muzx_check')
		or dbError();
}
 
closeDB();

?>
</body>

<html>