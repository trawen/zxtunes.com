<?php

require 'ini.php';

$id = intval($_REQUEST['id'] ?? 0);
$id_author = intval($_REQUEST['id_author'] ?? 0);
$type = intval($_REQUEST['type'] ?? 0);
$tm = time();
$referer = $_SERVER['HTTP_REFERER'] ?? '';
$true = (strpos($referer, 'zxtunes.com') !== false) || $referer === '' ? 1 : strpos($referer, 'zxtunes.com');

if ($type == 1 && $id > 0 && $true) {

    db_execute('UPDATE muzx_songs SET rating=rating+1 WHERE id=? LIMIT 1', 'i', [$id]);

    $t = db_fetch_one('SELECT id_song FROM last_rate WHERE id_song=? LIMIT 1', 'i', [$id]);
    if ($t && !empty($t['id_song'])) {
        db_execute('UPDATE last_rate SET date=? WHERE id_song=? LIMIT 1', 'ii', [$tm, $id]);
    } else {
        db_execute(
            'INSERT INTO last_rate (id_song, id_author, date) VALUES (?, ?, ?)',
            'iii',
            [$id, $id_author, $tm]
        );
    }

} elseif ($type == 2 && $id > 0 && $true) {

    db_execute('UPDATE muzx_songs SET downloads=downloads+1 WHERE id=? LIMIT 1', 'i', [$id]);

    $t = db_fetch_one('SELECT id_song FROM last_playing WHERE id_song=? LIMIT 1', 'i', [$id]);
    if ($t && !empty($t['id_song'])) {
        db_execute('UPDATE last_playing SET date=? WHERE id_song=? LIMIT 1', 'ii', [$tm, $id]);
    } else {
        db_execute(
            'INSERT INTO last_playing (id_song, id_author, date) VALUES (?, ?, ?)',
            'iii',
            [$id, $id_author, $tm]
        );
    }
}
