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

mysql_connect(DB_HOST, DB_USER, DB_PASS)
	or die(mysql_error());
mysql_select_db(DB_NAME)
	or die(mysql_error());

$src = new Source;
$src->open(SONG_SOURCE);

$mod = new Module;
$errCount = 0;
$authCount = 0;
$author = '';
$ok = true;
while ($ok && $src->readName())
{
	if (!$mod->parse($src))
	{
		if ($mod->lastError == UNKNOWN_EXT)
			warningMsg("$src->entryName: unknown extension '$mod->ext' - skipped");
		else
		{			
			$ok = false;
			$errCount++;
			errorMsg("$src->entryName: read error");
		}
		continue;
	}

	if ($mod->author != $author)		
	{
		$author = $mod->author;

		@list($nick, $group) = explode(' $ ', $author);
		
		$r = mysql_query(sprintf(
			"SELECT COUNT(*) FROM muzx_authors WHERE (nickname = '%s')",
			mysql_escape_string($nick), 
			mysql_escape_string($nick),				
			$group !== NULL ? " AND group_name = '".mysql_escape_string($group)."'" : ''
		));

		$ok = (boolean)$r;
		if (!$ok)
			dbError();
		else
		{
			$row = mysql_fetch_row($r);
			mysql_free_result($r);
			if ($row[0] != 1)
			{
				if ($errCount == 0)
				{
					echo '<table>';
					echo '<tr><td>Nickname</td><td>Group</td><td>Problem</td></tr>';
				}
				$errCount++;
				echo "<tr><td>$nick</td><td>".($group ? $group : '&nbsp;').'</td>';
			    if ($row[0] > 1)
			  		echo "<td>$row[0] duplicates</td>";
				else
				    echo '<td>author is not registered</td>';
				echo '</tr>';
			}
			$authCount++;
		}
	}
}

if ($errCount == 0)
	echo '0:1 OK';
else
{
	echo '</table>';
	echo "<p>$authCount author(s), $errCount error(s)</p>";
}

mysql_close();
$src->close();

?>
</body>

</html>