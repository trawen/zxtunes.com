<?php
require 'ini.php';
require_once __DIR__ . '/includes/auth.php';

zxtunes_require_admin();

$rows = db_fetch_all('SELECT id FROM muzx_songs WHERE comments <> 1');
foreach ($rows as $row) {
	db_execute('UPDATE muzx_songs SET comments=0 WHERE id=? AND comments <> 1', 'i', [(int) $row['id']]);
}

echo 'OK';
