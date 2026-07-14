<?php

http_response_code(404);

require 'ini.php';

$smarty->assign('title', $_SESSION['language'] === 'rus' ? 'Страница не найдена' : 'Page not found');
$smarty->assign('body_class', 'page-404');

include 'right_strip.php';

$smarty->display('404.tpl');
