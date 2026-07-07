<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<link rel="stylesheet" type="text/css" href="common.css" />
<title>Song collection parser</title>

</head>

<body>
<table>
<?php

require 'common.inc.php';

initDB();

$res = mysql_query('SELECT id, name FROM muzx_authors')
	or die(mysql_error());
while ($row = mysql_fetch_row($res))
{
	list($lastName, $firstName) = preg_split('/ +/', $row[1]);
	echo "<tr><td>$row[0]</td><td>$firstName</td><td>$lastName</td></tr>";
}

mysql_free_result($res);

closeDB();

?>
</table>
</body>

</html>