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


$src = new Source;
$src->open(SONG_SOURCE);

$f = fopen('n_parsed', 'r');
if (!$f)
	$nParsed = 0;
else
{
	fscanf($f, '%d', &$nParsed);
	fclose($f);
}

$i = 0;
while ($i < $nParsed && $src->readName()) $i++;

$mod = new Module;
$ok = true;
while ($ok && $src->readName())
{  
	if (!$mod->parse($src))
		if ($mod->lastError == UNKNOWN_EXT)
			warningMsg("$source->entryName: unknown extension '$mod->ext' - skipped");
		else
			$ok = false;
	else
	{
		@list($nick, $group) = explode(' of ', $mod->author);

		$ok = mysql_query(sprintf(
"INSERT INTO 
	muzx_songs2 (filename, name, year, type, last_update)
VALUES
	('%s', '%s', UNIX_TIMESTAMP('%d-01-01'), %d, UNIX_TIMESTAMP(NOW()))", 
			mysql_escape_string("$mod->name.$mod->ext"),
			mysql_escape_string($mod->title),
			$mod->year,
			0
		));
		if (!$ok)
			dbError;
		else
		{		
			$id = mysql_insert_id();
			$ok = mysql_query(sprintf(
"INSERT INTO
	muzx_songs_authors2 (song_id, author_id)
SELECT
	muzx_songs2.id,
	muzx_authors2.id
FROM
	muzx_songs2,
	muzx_authors2
WHERE
	muzx_songs2.id = %d AND (nickname = '%s' OR alt_nickname = '%s')%s",
				$id,
				mysql_escape_string($nick),
				mysql_escape_string($nick),
				$group !== NULL ? " AND group_name = '".mysql_escape_string($group)."'" : ''
			));
			if (!$ok)
				dbError();
			else
			{
				$t = sprintf("%s/%08X", SONG_STORAGE, $id);
				$ok = $mod->copyTo($t);
				if (!$ok)
					errorMsg("Unable to create file '$t'");
				
				$ok || mysql_query("DELETE FROM muzx_songs_authors2 WHERE song_id = $id");
			}
			$ok || mysql_query("DELETE FROM muzx_songs2 WHERE id = $id");
		}
	} // if ($mod->parse($src))

	if ($ok)
	{
		$f = fopen('n_parsed', 'w');
		if (!$f)	
		{
	   		errorMsg("Unable to update file 'n_parsed'");
	   		$ok = false;
		}
		else
		{
			fputs($f, sprintf("%d", ++$nParsed));
			fclose($f);
		}
	}
}              

$src->close();
closeDB();

echo "$nParsed entries parsed";

?>
</body>

</html>