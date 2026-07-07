<?php
require 'ini.php';

error_reporting(0);

$id = (int) ($_GET['id'] ?? 0);
$md = (string) ($_GET['md'] ?? '');

function download_filename(string $name): string
{
	$name = preg_replace('/[^\w.\-]+/u', '_', $name) ?? 'download';
	return $name !== '' ? $name : 'download';
}

function send_file(string $filepath, string $filename): void
{
	if (!is_file($filepath)) {
		header('HTTP/1.0 404 Not Found');
		return;
	}

	$songSize = filesize($filepath);
	ob_clean();
	header('Content-type: application/octet-stream');
	header('Content-Disposition: attachment; filename="' . download_filename($filename) . '"');
	header('Content-Length: ' . $songSize);
	readfile($filepath);
}

if ($id <= 0) {
	header('HTTP/1.0 404 Not Found');
	exit;
}

if ($md === 'author') {

	$row = db_fetch_one('SELECT nickname FROM muzx_authors WHERE id=? LIMIT 1', 'i', [$id]);
	db_execute('UPDATE muzx_authors SET downloads=downloads+1 WHERE id=? LIMIT 1', 'i', [$id]);
	send_file(sprintf('tunes_zip/%08X', $id), ($row['nickname'] ?? 'archive') . '.zip');
}
elseif ($md === 'software') {

	db_execute('UPDATE software_file SET downloads=downloads+1 WHERE id_file=? LIMIT 1', 'i', [$id]);
	$row1 = db_fetch_one('SELECT id_software, feature FROM software_file WHERE id_file=? LIMIT 1', 'i', [$id]);
	if (!$row1) {
		header('HTTP/1.0 404 Not Found');
		exit;
	}

	$row = db_fetch_one('SELECT title, version FROM software WHERE id=? LIMIT 1', 'i', [(int) $row1['id_software']]);
	if (!$row) {
		header('HTTP/1.0 404 Not Found');
		exit;
	}

	$file_name = $row['title'] . '_' . $row['version'];
	if ($row1['feature']) {
		$file_name .= ' ' . $row1['feature'];
	}
	$file_name = str_replace(' ', '_', $file_name) . '.zip';
	send_file('software/files/' . $id, $file_name);
}
elseif ($md === 'remix_mp3') {

	$row = db_fetch_one('SELECT file_name, year FROM remix_mp3 WHERE id=? LIMIT 1', 'i', [$id]);
	if (!$row) {
		header('HTTP/1.0 404 Not Found');
		exit;
	}

	db_execute('UPDATE remix_mp3 SET downloads=downloads+1 WHERE id=? LIMIT 1', 'i', [$id]);
	$year = $row['year'] ? $row['year'] . '/' : '';
	header('Location: /remix_mp3/' . $year . rawurlencode($row['file_name']));
	exit;
}
elseif ($md === 'podcast') {

	$row = db_fetch_one('SELECT file_name FROM podcast WHERE id=? LIMIT 1', 'i', [$id]);
	if (!$row) {
		header('HTTP/1.0 404 Not Found');
		exit;
	}

	db_execute('UPDATE podcast SET downloads=downloads+1 WHERE id=? LIMIT 1', 'i', [$id]);
	header('Location: /podcast/' . rawurlencode($row['file_name']));
	exit;
}
else {

	$row = db_fetch_one('SELECT filename FROM muzx_songs WHERE id=? LIMIT 1', 'i', [$id]);
	db_execute('UPDATE muzx_songs SET downloads=downloads+1 WHERE id=? LIMIT 1', 'i', [$id]);
	send_file(sprintf('tunes/%08X', $id), $row['filename'] ?? 'tune');
}
