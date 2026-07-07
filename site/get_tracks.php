<?php
require 'ini.php';

$id = (int) ($_REQUEST['id'] ?? 0);

echo "<option value=0>трек</option>";

if ($id <= 0) {
	exit;
}

$rows = db_fetch_all(
	'SELECT muzx_songs.id, muzx_songs.filename, muzx_songs.name FROM muzx_songs_authors JOIN muzx_songs ON muzx_songs.id = muzx_songs_authors.song_id WHERE muzx_songs_authors.author_id=? ORDER BY muzx_songs.year',
	'i',
	[$id]
);

foreach ($rows as $t) {
	$tid = (int) $t['id'];
	echo "<option value='" . $tid . "'>" . $tid . ' - ' . h($t['filename']) . ' - ' . h($t['name']) . '</option>';
}
