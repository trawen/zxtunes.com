<?php

require_once dirname(__DIR__) . '/includes/mysql_compat.php';
require 'config.inc.php';

function initDB()
{
	mysql_connect(DB_HOST, DB_USER, DB_PASS)
		or die(mysql_error());
	mysql_select_db(DB_NAME)
		or die(mysql_error());
}

function closeDB()
{
	mysql_close();
}

function errorMsg($text)
{
	echo '<div class="error">Error: ', htmlspecialchars($text), '</div>';
	return false;
}

function dbError()
{
	return errorMsg(mysql_error());
}

function forceDir($path)
{	
	$i = -1;
	while ($i = strpos("$path/", '/', $i + 1))
		@mkdir(substr($path, 0, $i), NEW_DIR_MODE);
	return true;
}

function warningMsg($text)
{
	echo '<div class="warning">Warning: ', htmlspecialchars($text), '</div>';
	return false;
}


function debugMsg($text)
{
	echo '<div class="debug">Debug: ', htmlspecialchars($text), '</div>';
	return true;
}

?>