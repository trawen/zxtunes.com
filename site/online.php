<?php
require_once __DIR__ . '/ini.php';

$language = $_REQUEST['ln'] ?? null;
if ($language == 'rus' || $language == 'eng') {
    $_SESSION['language'] = $language;
}
if (empty($_SESSION['language'])) {
    $_SESSION['language'] = 'rus';
}

$client = ' ' . ($_SERVER['HTTP_USER_AGENT'] ?? '');
$bot = (strstr($client, 'Yandex') || strstr($client, 'Googlebot')) ? 1 : 0;
