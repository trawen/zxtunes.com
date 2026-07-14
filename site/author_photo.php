<?php

require 'ini.php';
zxtunes_resolve_author_request();

$id = (int) ($_REQUEST['id'] ?? 0);
if ($id <= 0) {
    http_response_code(404);
    echo 'Author not found';
    exit;
}

$row1 = db_fetch_one('SELECT * FROM muzx_authors WHERE id=? LIMIT 1', 'i', [$id]);
if (!$row1 || empty($row1['photo'])) {
    http_response_code(404);
    echo 'Photo not found';
    exit;
}

$author_url = zxtunes_author_url($row1);

if ($_SESSION['language'] === 'rus') {
    $smarty->assign('title', $row1['nickname'] . ' — фото');
    $smarty->assign('back_label', 'к профилю');
} else {
    $smarty->assign('title', $row1['nickname'] . ' — photo');
    $smarty->assign('back_label', 'back to profile');
}

$smarty->assign('author', $row1);
$smarty->assign('author_url', $author_url);
$smarty->assign('photo_url', '/photo/' . $id . '.jpg');
$smarty->assign('body_class', 'page-author-photo');
$smarty->assign('active', []);

include 'right_strip.php';

$smarty->display('author_photo.tpl');
