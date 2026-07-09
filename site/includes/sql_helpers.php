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

/** @return array<int, list<array{name: string, status: int}>> */
function zxtunes_author_groups_for_ids(array $author_ids): array
{
    $ids = array_values(array_filter(array_map('intval', $author_ids)));
    if (!$ids) {
        return [];
    }

    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $types = str_repeat('i', count($ids));
    $rows = db_fetch_all(
        'SELECT ga.author_id, g.name, ga.status
         FROM group_authors ga
         JOIN `groups` g ON g.id = ga.group_id
         WHERE ga.author_id IN (' . $placeholders . ')
         ORDER BY g.name ASC',
        $types,
        $ids
    );

    $map = [];
    foreach ($rows as $row) {
        $map[(int) $row['author_id']][] = [
            'name' => (string) $row['name'],
            'status' => (int) $row['status'],
        ];
    }

    return $map;
}

function zxtunes_authors_group_exists_clause(string $letter, ?string $sr, mysqli $db): string
{
    if ($sr !== null && $sr !== '') {
        $sr_esc = mysqli_real_escape_string($db, $sr);
        return "EXISTS (SELECT 1 FROM group_authors ga JOIN `groups` g ON g.id = ga.group_id WHERE ga.author_id = a.id AND g.name LIKE '" . $sr_esc . "')";
    }
    if ($letter === 'ALL') {
        return '';
    }
    if ($letter === '123') {
        return "EXISTS (SELECT 1 FROM group_authors ga JOIN `groups` g ON g.id = ga.group_id WHERE ga.author_id = a.id AND g.name REGEXP '^[0-9]')";
    }

    $letter_esc = mysqli_real_escape_string($db, $letter);
    return "EXISTS (SELECT 1 FROM group_authors ga JOIN `groups` g ON g.id = ga.group_id WHERE ga.author_id = a.id AND g.name LIKE '" . $letter_esc . "%')";
}

function zxtunes_authors_group_order_sql(string $up): string
{
    return '(SELECT MIN(g.name) FROM group_authors ga JOIN `groups` g ON g.id = ga.group_id WHERE ga.author_id = a.id) ' . $up . ', a.nickname ASC';
}

/** Smarty templates often expect mysqli_fetch_array numeric keys for COUNT(*). */
function db_count_compat(string $sql, string $types = '', array $params = []): array
{
    $row = db_fetch_one($sql, $types, $params);
    $cnt = (int) ($row['cnt'] ?? 0);
    return [0 => $cnt, 'cnt' => $cnt];
}
