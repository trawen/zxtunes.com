<?php
/**
 * Legacy board/read bootstrap — delegates to ini.php
 */
require_once __DIR__ . '/ini.php';

define('nm_post_in_page', 7);
define('nm_news_in_page', 8);
define('nm_pages_list', 15);

$link_1_name = 'board';
$link_1_id = 'id';
$link_2_name = 'read';
$link_2_id = 'id';

$smarty->assign('rnd_image', rand(1, 5));
$smarty->assign('link_1_id', $link_1_id);
$smarty->assign('link_1_name', $link_1_name);
$smarty->assign('link_2_id', $link_2_id);
$smarty->assign('link_2_name', $link_2_name);
