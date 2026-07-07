<?php

function zxtunes_whitelist(string $value, array $allowed, string $default): string
{
    return in_array($value, $allowed, true) ? $value : $default;
}

function zxtunes_sort_dir(string $value): string
{
    return ($value === 'ASC') ? 'ASC' : 'DESC';
}

function zxtunes_author_list_order(string $order, string $lang_suffix = ''): string
{
    $order = zxtunes_whitelist($order, [
        'nickname', 'first_name', 'last_name', 'group_name',
        'num_tracks', 'years_from', 'city', 'country',
    ], 'nickname');

    if (in_array($order, ['city', 'country', 'first_name', 'last_name'], true)) {
        return $order . $lang_suffix;
    }

    return $order;
}

function zxtunes_song_order(string $order): string
{
    return zxtunes_whitelist($order, [
        'year', 'filename', 'downloads', 'rating', 'time', 'last_update',
    ], 'year');
}

function zxtunes_lang_suffix(): string
{
    return (($_SESSION['language'] ?? '') === 'rus') ? '' : '_en';
}

/** Smarty templates often expect mysqli_fetch_array numeric keys for COUNT(*). */
function db_count_compat(string $sql, string $types = '', array $params = []): array
{
    $row = db_fetch_one($sql, $types, $params);
    $cnt = (int) ($row['cnt'] ?? 0);
    return [0 => $cnt, 'cnt' => $cnt];
}
