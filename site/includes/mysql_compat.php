<?php
/**
 * mysql_* compatibility layer for legacy scripts on PHP 7.4+.
 * Uses global $db (mysqli) established in ini.php.
 */
if (!function_exists('mysql_connect')) {
    function mysql_connect($server = null, $username = null, $password = null, $new_link = false, $client_flags = 0)
    {
        global $db;
        $server = $server ?? (defined('DB_HOST') ? DB_HOST : 'localhost');
        $username = $username ?? (defined('DB_USER') ? DB_USER : '');
        $password = $password ?? (defined('DB_PASS') ? DB_PASS : '');
        $db = mysqli_connect($server, $username, $password);
        return $db;
    }

    function mysql_select_db($database_name, $link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_select_db($link, $database_name);
    }

    function mysql_query($query, $link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_query($link, $query);
    }

    function mysql_fetch_array($result, $result_type = MYSQLI_BOTH)
    {
        return mysqli_fetch_array($result, $result_type);
    }

    function mysql_fetch_assoc($result)
    {
        return mysqli_fetch_assoc($result);
    }

    function mysql_fetch_row($result)
    {
        return mysqli_fetch_row($result);
    }

    function mysql_num_rows($result)
    {
        return mysqli_num_rows($result);
    }

    function mysql_insert_id($link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_insert_id($link);
    }

    function mysql_affected_rows($link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_affected_rows($link);
    }

    function mysql_errno($link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_errno($link);
    }

    function mysql_error($link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_error($link);
    }

    function mysql_real_escape_string($string, $link = null)
    {
        global $db;
        $link = $link ?: $db;
        return mysqli_real_escape_string($link, $string);
    }

    function mysql_close($link = null)
    {
        global $db;
        $link = $link ?: $db;
        $result = mysqli_close($link);
        $db = null;
        return $result;
    }

    function mysql_num_fields($result)
    {
        return mysqli_num_fields($result);
    }

    function mysql_field_name($result, $field_offset)
    {
        $field = mysqli_fetch_field_direct($result, $field_offset);
        return $field ? $field->name : false;
    }
}
