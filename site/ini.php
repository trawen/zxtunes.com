<?php

/**

 * zxtunes.com bootstrap — PHP 8.5 / Docker

 */

error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING);

ini_set('display_errors', '0');



require_once __DIR__ . '/includes/mysql_compat.php';

require_once __DIR__ . '/includes/escape.php';

require_once __DIR__ . '/includes/db.php';

require_once __DIR__ . '/includes/password.php';

require_once __DIR__ . '/includes/csrf.php';

require_once __DIR__ . '/includes/session_auth.php';

require_once __DIR__ . '/includes/sql_helpers.php';
require_once __DIR__ . '/includes/author_urls.php';
require_once __DIR__ . '/includes/tune_files.php';



if (session_status() === PHP_SESSION_NONE) {

    session_start();

}



define('DB_HOST', getenv('DB_HOST') ?: 'localhost');

define('DB_USER', getenv('DB_USER') ?: 'zxtunes_u');

define('DB_PASS', getenv('DB_PASS') !== false ? getenv('DB_PASS') : '');

define('DB_NAME', getenv('DB_NAME') ?: 'zxtunes_db');



$db = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if (!$db) {

    die('Database connection failed: ' . mysqli_connect_error());

}

mysqli_set_charset($db, 'utf8mb4');



$language = $_REQUEST['ln'] ?? null;
if ($language === 'ru') {
    $language = 'rus';
} elseif ($language === 'en') {
    $language = 'eng';
}
if (!$language) {
    $language = $_SESSION['language'] ?? 'rus';
}

$_SESSION['language'] = $language;



if ($language == 'eng') {

    $amdate = array(

        '01' => 'January', '02' => 'February', '03' => 'March', '04' => 'April',

        '05' => 'May', '06' => 'June', '07' => 'July', '08' => 'August',

        '09' => 'September', '10' => 'October', '11' => 'November', '12' => 'December',

    );

} else {

    $amdate = array(

        '01' => 'января', '02' => 'февраля', '03' => 'марта', '04' => 'апреля',

        '05' => 'мая', '06' => 'июня', '07' => 'июля', '08' => 'августа',

        '09' => 'сентября', '10' => 'октября', '11' => 'ноября', '12' => 'декабря',

    );

}



function my($var)

{

    global $db;

    return trim(mysqli_real_escape_string($db, $_REQUEST[$var] ?? ''));

}



function dt($var)

{

    global $amdate;

    return date('d', $var) . ' ' . $amdate[date('m', $var)] . ' ' . date('Y', $var);

}



function qr($from, $where)

{

    global $db;

    $z = mysqli_query($db, "SELECT * FROM $from WHERE $where LIMIT 1");

    return mysqli_fetch_array($z);

}



function frame2time($var)

{

    $s = ceil($var / 50);

    $sec = sprintf('%02d', $s - ((intval($s / 60)) * 60));

    $min = intval($s / 60);

    return $min . ':' . $sec;

}



function login()

{

    return !empty($_SESSION['user_id']) && !empty($_SESSION['user_login']);

}



zxtunes_try_cookie_login();



$dir = getenv('APP_ROOT') ?: (__DIR__ . '/');

if (substr($dir, -1) !== '/') {

    $dir .= '/';

}



$data_root = getenv('ZXTUNES_DATA_ROOT') ?: '/home/zxtunes/web/zxtunes.com/data';

if (substr($data_root, -1) !== '/') {

    $data_root .= '/';

}



define('SMARTY_DIR', $dir . 'smarty/libs/');

require_once SMARTY_DIR . 'Smarty.class.php';

$smarty = new Smarty;



$smarty->template_dir = $dir . 'smarty/zxtunes/templates/';

$smarty->compile_dir = $data_root . 'cache/smarty/templates_c/';

$smarty->cache_dir = $data_root . 'cache/smarty/cache/';

$smarty->config_dir = $dir . 'smarty/zxtunes/configs/';



function smarty_modifier_h($string)

{

    return h($string);

}

$smarty->register_modifier('h', 'smarty_modifier_h');
$smarty->register_modifier('aurl', 'smarty_modifier_aurl');

$smarty->assign('csrf_token', csrf_token());
$smarty->assign('css_v', (string) @filemtime(__DIR__ . '/css/zxtunes.css'));
$critical_css_path = __DIR__ . '/css/zxtunes-critical.css';
$smarty->assign('critical_css_v', (string) @filemtime($critical_css_path));
$smarty->assign('critical_css_inline', is_readable($critical_css_path) ? file_get_contents($critical_css_path) : '');
$smarty->assign('language', $_SESSION['language']);
$smarty->assign('authors_map_url', zxtunes_authors_map_url());
$smarty->assign('search_url', zxtunes_search_url());
$smarty->assign('search_query', trim((string) ($_REQUEST['srtext'] ?? '')));



$user = array(

    'login' => $_SESSION['user_login'] ?? null,

    'id' => $_SESSION['user_id'] ?? null,

    'author_id' => $_SESSION['user_author_id'] ?? null,

    'acess' => $_SESSION['user_acess'] ?? null,

);



$smarty->assign('user', $user);



$sape_hash = getenv('SAPE_USER_HASH') ?: 'df148749a7a956a4334286aea4e556e8';

if (!defined('_SAPE_USER')) {

    define('_SAPE_USER', $sape_hash);

}



$sape_path = $_SERVER['DOCUMENT_ROOT'] . '/' . _SAPE_USER . '/sape.php';

if (is_file($sape_path)) {

    require_once $sape_path;

    $sape = new SAPE_client();

} else {

    $sape = null;

}

