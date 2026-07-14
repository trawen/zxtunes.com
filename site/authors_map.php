<?php

require 'ini.php';
require_once __DIR__ . '/includes/author_map.php';

zxtunes_redirect_authors_map_url();

function geturl($i)
{
    return zxtunes_authors_map_url() . '?';
}

$smarty->assign('active', ['authors_map' => 'class=active']);

if ($_SESSION['language'] === 'rus') {
    $smarty->assign('title', 'Карта музыкантов');
} else {
    $smarty->assign('title', 'Musicians map');
}

$points = zxtunes_author_map_points();
$total = 0;
foreach ($points as $p) {
    $total += $p['count'];
}

$smarty->assign('body_class', 'page-authors-map');
$smarty->assign('load_leaflet', true);
$smarty->assign('map_points_json', json_encode($points, JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT));
$smarty->assign('map_cities', count($points));
$smarty->assign('map_musicians', $total);
$smarty->assign('top_cities', zxtunes_author_map_top_cities(50));

include 'right_strip.php';

$smarty->display('authors_map.tpl');
