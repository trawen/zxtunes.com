<?php

require 'ini.php';
require_once __DIR__ . '/includes/site_search.php';

zxtunes_redirect_search_url();

function geturl($i)
{
    return zxtunes_search_url() . '?';
}

$ip = $_SERVER['REMOTE_ADDR'];
$client = ' ' . ($_SERVER['HTTP_USER_AGENT'] ?? '');
if (strstr($client, 'Yandex') || strstr($client, 'Googlebot')) {
    $bot = 1;
} else {
    $bot = 0;
}

if ($bot) {
    header('Location: ' . $_SESSION['last_url']);
    exit;
}

$submit = $_REQUEST['submit'] ?? '';
$srtext_raw = trim((string) ($_REQUEST['srtext'] ?? ''));
$srtext = mb_strtolower($srtext_raw, 'UTF-8');

$smarty->assign('srtext', h($srtext_raw));
$smarty->assign('search_authors', []);
$smarty->assign('search_groups', []);
$smarty->assign('search_tunes', []);
$smarty->assign('search_software', []);
$smarty->assign('search_remixes', []);
$smarty->assign('search_total', 0);

if ($submit === 'submit' || $submit === 'OK' || $srtext_raw !== '') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        csrf_verify_if_post();
    }

    if (strlen($srtext) >= 2 && strlen($srtext) < 32) {
        $results = zxtunes_universal_search($srtext);

        $authors = $results['authors'];
        foreach ($authors as $i => $row) {
            $authors[$i]['nm'] = $i + 1;
        }

        $groups = $results['groups'];
        foreach ($groups as $i => $row) {
            $groups[$i]['nm'] = $i + 1;
        }

        $software = $results['software'];
        foreach ($software as $i => $row) {
            $software[$i]['nm'] = $i + 1;
        }

        $remixes = $results['remixes'];
        foreach ($remixes as $i => $row) {
            $remixes[$i]['nm'] = $i + 1;
        }

        $tunes = $results['tunes'];
        $srid = [];
        $srnk = [];
        foreach ($tunes as $i => $row) {
            $tunes[$i]['nm'] = $i + 1;
            $srid[$i] = (int) $row['id'];
            $srnk[$i] = (string) $row['nickname'];
        }

        $total = count($authors) + count($groups) + count($tunes) + count($software) + count($remixes);

        $smarty->assign('search_authors', $authors);
        $smarty->assign('search_groups', $groups);
        $smarty->assign('search_tunes', $tunes);
        $smarty->assign('search_software', $software);
        $smarty->assign('search_remixes', $remixes);
        $smarty->assign('search_total', $total);

        if ($tunes) {
            $_SESSION['srid'] = $srid;
            $_SESSION['srnk'] = $srnk;
            $_SESSION['srtx'] = zxtunes_search_clean_filename($srtext_raw);
            $smarty->assign('srtx', $_SESSION['srtx']);
            $smarty->assign('srsz', count($tunes) * 1.2);
        } else {
            unset($_SESSION['srid'], $_SESSION['srnk'], $_SESSION['srtx']);
        }
    }
}

if (($_SESSION['language'] ?? 'rus') === 'rus') {
    $smarty->assign('title', 'Поиск — «' . $srtext_raw . '»');
} else {
    $smarty->assign('title', 'Search — «' . $srtext_raw . '»');
}

if (!empty($_REQUEST['download'])) {
    $srid = $_SESSION['srid'] ?? [];
    $srnk = $_SESSION['srnk'] ?? [];

    include_once 'pclzip.lib.php';

    function myPreAddCallBack($p_event, &$p_header)
    {
        global $tname;
        $info = pathinfo($p_header['filename']);
        if (!$info['extension']) {
            $p_header['stored_filename'] = $tname['t' . $p_header['stored_filename']][1] . '_' . $tname['t' . $p_header['stored_filename']][0];
        } else {
            $p_header['stored_filename'] = $info['basename'];
        }

        return 1;
    }

    $nm = 0;
    $tlist = '';
    $tname = [];

    while (!empty($srid[$nm])) {
        $id = (int) $srid[$nm];
        $tunes = db_fetch_one(
            'SELECT filename FROM muzx_songs WHERE id=? AND hidden=0 AND denied=0 LIMIT 1',
            'i',
            [$id]
        );
        if ($tunes) {
            $hex = sprintf('%08X', $srid[$nm]);
            $tlist .= 'tunes/' . $hex . ',';
            $tname['t' . $hex][0] = $tunes['filename'];
            $tname['t' . $hex][1] = $srnk[$nm];
        }
        $nm++;
    }
    $tlist = substr($tlist, 0, -1);

    $sid = session_id();
    mkdir('temp/' . $sid, 0777);
    $fn = 'temp/' . $sid . '/' . time();
    $archive = new PclZip($fn);
    $v_list = $archive->create($tlist, PCLZIP_CB_PRE_ADD, 'myPreAddCallBack', PCLZIP_OPT_REMOVE_PATH, 'tunes');
    if ($v_list == 0) {
        echo 'Error : ' . $archive->errorInfo(true);
    }

    $fs = filesize($fn);
    ob_clean();

    header('Content-type: application/octet-stream');
    header('Content-Disposition: attachment; filename=zxtunes_search_' . $_SESSION['srtx'] . '.zip');
    header('Content-Length: ' . $fs);

    readfile($fn);
    unlink($fn);
    rmdir('temp/' . $sid);
    unset($_SESSION['srid'], $_SESSION['srnk']);
    exit;
}

include 'right_strip.php';

$smarty->display('search.tpl');
