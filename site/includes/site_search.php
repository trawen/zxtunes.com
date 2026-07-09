<?php

function zxtunes_search_authors(string $srtext): array
{
    $like = '%' . db_like_escape($srtext) . '%';
    $rows = db_fetch_all(
        'SELECT * FROM muzx_authors '
        . 'WHERE nickname LIKE ? OR also LIKE ? OR first_name LIKE ? OR last_name LIKE ? '
        . 'OR first_name_en LIKE ? OR last_name_en LIKE ? OR group_name LIKE ? '
        . 'ORDER BY nickname ASC LIMIT 100',
        'sssssss',
        array_fill(0, 7, $like)
    );

    $results = [];
    foreach ($rows as $src) {
        $src['nickname'] = highlight_search((string) $src['nickname'], $srtext);
        $src['group_name'] = highlight_search((string) $src['group_name'], $srtext);
        if (($_SESSION['language'] ?? 'rus') === 'rus') {
            $src['first_name'] = highlight_search((string) $src['first_name'], $srtext);
            $src['last_name'] = highlight_search((string) $src['last_name'], $srtext);
        } else {
            $src['first_name_en'] = highlight_search((string) $src['first_name_en'], $srtext);
            $src['last_name_en'] = highlight_search((string) $src['last_name_en'], $srtext);
        }
        for ($i = 1; $i <= 5; $i++) {
            $key = 'also' . $i;
            if (!empty($src[$key])) {
                $src[$key] = highlight_search((string) $src[$key], $srtext);
            }
        }
        $results[] = $src;
    }

    return $results;
}

function zxtunes_search_groups(string $srtext): array
{
    $like = '%' . db_like_escape($srtext) . '%';
    $rows = db_fetch_all(
        'SELECT id, name, acronym, site FROM `groups` '
        . 'WHERE name LIKE ? OR acronym LIKE ? '
        . 'ORDER BY name ASC LIMIT 50',
        'ss',
        [$like, $like]
    );

    $results = [];
    foreach ($rows as $row) {
        $results[] = [
            'id' => (int) $row['id'],
            'name' => highlight_search((string) $row['name'], $srtext),
            'name_plain' => (string) $row['name'],
            'acronym' => highlight_search((string) $row['acronym'], $srtext),
            'site' => (string) ($row['site'] ?? ''),
        ];
    }

    return $results;
}

function zxtunes_search_tunes(string $srtext): array
{
    $like = '%' . db_like_escape($srtext) . '%';
    $rows = db_fetch_all(
        'SELECT a.*, b.song_id, b.author_id, c.nickname '
        . 'FROM muzx_songs a '
        . 'JOIN muzx_songs_authors b ON a.id = b.song_id '
        . 'JOIN muzx_authors c ON c.id = b.author_id '
        . 'WHERE (a.filename LIKE ? OR a.name LIKE ?) AND a.hidden = 0 AND a.denied = 0 '
        . 'ORDER BY c.nickname, a.filename LIMIT 350',
        'ss',
        [$like, $like]
    );

    $results = [];
    foreach ($rows as $src) {
        $src['filename'] = highlight_search((string) $src['filename'], $srtext);
        $src['name'] = highlight_search((string) $src['name'], $srtext);
        $src['id'] = (int) $src['song_id'];
        $src['author_id'] = (int) $src['author_id'];
        $ri = (int) $src['id'];
        $src['rt'] = !empty($_REQUEST['rt' . $ri]) ? 'r_off' : 'rating';
        $results[] = $src;
    }

    $n = count($results);
    for ($x = 0; $x < $n; $x++) {
        $results[$x]['next_id'] = $results[$x + 1]['id'] ?? null;
        $results[$x]['prev_id'] = $results[$x - 1]['id'] ?? null;
    }
    if ($n > 0) {
        $results[0]['prev_id'] = $results[$n - 1]['id'];
        $results[$n - 1]['next_id'] = $results[0]['id'];
    }

    return $results;
}

function zxtunes_search_software(string $srtext): array
{
    $like = '%' . db_like_escape($srtext) . '%';
    $rows = db_fetch_all(
        'SELECT id, title, author, version FROM software '
        . 'WHERE title LIKE ? OR author LIKE ? '
        . 'ORDER BY title ASC LIMIT 100',
        'ss',
        [$like, $like]
    );

    $results = [];
    foreach ($rows as $src) {
        $results[] = [
            'id' => (int) $src['id'],
            'title' => highlight_search((string) $src['title'], $srtext),
            'author' => highlight_search((string) $src['author'], $srtext),
            'version' => (string) ($src['version'] ?? ''),
        ];
    }

    return $results;
}

function zxtunes_search_remixes(string $srtext): array
{
    $like = '%' . db_like_escape($srtext) . '%';
    $rows = db_fetch_all(
        'SELECT id, title, author, composer_name, composer_id, year, comment, original_id '
        . 'FROM remix_mp3 '
        . 'WHERE title LIKE ? OR author LIKE ? OR composer_name LIKE ? OR comment LIKE ? '
        . 'ORDER BY title ASC LIMIT 100',
        'ssss',
        [$like, $like, $like, $like]
    );

    $results = [];
    foreach ($rows as $src) {
        $results[] = [
            'id' => (int) $src['id'],
            'title' => highlight_search((string) $src['title'], $srtext),
            'author' => highlight_search((string) $src['author'], $srtext),
            'composer_name' => highlight_search((string) $src['composer_name'], $srtext),
            'composer_id' => (int) ($src['composer_id'] ?? 0),
            'year' => (string) ($src['year'] ?? ''),
            'comment' => highlight_search((string) $src['comment'], $srtext),
            'original_id' => (int) ($src['original_id'] ?? 0),
        ];
    }

    return $results;
}

function zxtunes_universal_search(string $srtext): array
{
    return [
        'authors' => zxtunes_search_authors($srtext),
        'groups' => zxtunes_search_groups($srtext),
        'tunes' => zxtunes_search_tunes($srtext),
        'software' => zxtunes_search_software($srtext),
        'remixes' => zxtunes_search_remixes($srtext),
    ];
}

function zxtunes_search_clean_filename(string $filename): string
{
    $reserved = preg_quote('\/:*?"<>|', '/');

    return preg_replace_callback(
        "/([\\x00-\\x40\\x7f-\\xff{$reserved}])/u",
        static fn () => '_',
        $filename
    );
}
