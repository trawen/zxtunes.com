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

$res1 = mysql_query('SELECT id, nickname, group_name FROM muzx_authors');
if (!$res1)
	echo mysql_error();
else
{
	while ($row1 = mysql_fetch_row($res1))
	{
		printf(
			'<div class="author">%s%s</div>',
			$row1[1],
			$row1[2] ? ' of '.$row1[2] : ''
		);
		$res2 = mysql_query(sprintf(
			'SELECT filename, name, type, YEAR(FROM_UNIXTIME(year)) FROM muzx_songs, muzx_songs_authors WHERE author_id = %d AND id = song_id',
			$row1[0]
		));
		if (!$res2)
			echo mysql_error();
		else
		{
			while ($row2 = mysql_fetch_row($res2))
				printf(
					'<div class="song"><a href="%s">%s</a> (%d)</div>',
					SONG_STORAGE.'/'.$row2[0],
					htmlspecialchars($row2[1]), 
					$row2[3]
				);
			mysql_free_result($res2);
		}
	}
	mysql_free_result($res1);
}

closeDB();

?>
</body>

</html>