<?php

require_once __DIR__ . '/country_flags.php';

function zxtunes_city_map_key(string $city_ru, string $city_en, string $country_ru, string $country_en): string
{
    $city = trim($city_en) !== '' ? trim($city_en) : trim($city_ru);
    $country = trim($country_en) !== '' ? trim($country_en) : trim($country_ru);
    return mb_strtolower($city . '|' . $country, 'UTF-8');
}

function zxtunes_load_city_coords(): array
{
    static $by_key = null;
    if ($by_key !== null) {
        return $by_key;
    }

    $by_key = [];
    $path = __DIR__ . '/../data/author_city_coords.json';
    if (!is_readable($path)) {
        return $by_key;
    }

    $data = json_decode((string) file_get_contents($path), true);
    if (!is_array($data) || !isset($data['points']) || !is_array($data['points'])) {
        return $by_key;
    }

    foreach ($data['points'] as $point) {
        if (!isset($point['key'])) {
            continue;
        }
        $by_key[$point['key']] = $point;
    }

    return $by_key;
}

function zxtunes_author_map_points(): array
{
    $rows = db_fetch_all(
        'SELECT TRIM(city) AS city_ru, TRIM(city_en) AS city_en, '
        . 'TRIM(country) AS country_ru, TRIM(country_en) AS country_en, COUNT(*) AS cnt '
        . 'FROM muzx_authors '
        . 'WHERE TRIM(COALESCE(city, "")) <> "" OR TRIM(COALESCE(city_en, "")) <> "" '
        . 'GROUP BY city_ru, city_en, country_ru, country_en '
        . 'ORDER BY cnt DESC'
    );

    $coords = zxtunes_load_city_coords();
    $points = [];

    foreach ($rows as $row) {
        $key = zxtunes_city_map_key(
            (string) ($row['city_ru'] ?? ''),
            (string) ($row['city_en'] ?? ''),
            (string) ($row['country_ru'] ?? ''),
            (string) ($row['country_en'] ?? '')
        );

        if (!isset($coords[$key])) {
            continue;
        }

        $c = $coords[$key];
        $points[] = [
            'lat' => (float) $c['lat'],
            'lng' => (float) $c['lng'],
            'count' => (int) $row['cnt'],
            'city_ru' => (string) ($row['city_ru'] ?? ''),
            'city_en' => (string) ($row['city_en'] ?? ''),
            'country_ru' => (string) ($row['country_ru'] ?? ''),
            'country_en' => (string) ($row['country_en'] ?? ''),
        ];
    }

    return $points;
}

function zxtunes_authors_count_label(int $n, ?string $language = null): string
{
    $language = $language ?? ($_SESSION['language'] ?? 'rus');
    if ($language === 'eng') {
        return $n === 1 ? 'author' : 'authors';
    }

    $mod10 = $n % 10;
    $mod100 = $n % 100;
    if ($mod10 === 1 && $mod100 !== 11) {
        return 'автор';
    }
    if ($mod10 >= 2 && $mod10 <= 4 && ($mod100 < 10 || $mod100 >= 20)) {
        return 'автора';
    }

    return 'авторов';
}

function zxtunes_author_map_font_size(int $tracks, int $minTracks, int $maxTracks): int
{
    if ($maxTracks <= $minTracks) {
        return 24;
    }

    $ratio = ($tracks - $minTracks) / ($maxTracks - $minTracks);

    return (int) round(12 + $ratio * 12);
}

function zxtunes_author_map_top_cities(int $limit = 10): array
{
    $limit = max(1, $limit);
    $rows = db_fetch_all(
        'SELECT TRIM(city) AS city_ru, TRIM(city_en) AS city_en, '
        . 'TRIM(country) AS country_ru, TRIM(country_en) AS country_en, COUNT(*) AS cnt '
        . 'FROM muzx_authors '
        . 'WHERE (TRIM(COALESCE(city, "")) <> "" OR TRIM(COALESCE(city_en, "")) <> "") '
        . 'AND num_tracks >= 2 '
        . 'GROUP BY city_ru, city_en, country_ru, country_en '
        . 'ORDER BY cnt DESC '
        . 'LIMIT ' . $limit
    );

    $cities = [];
    foreach ($rows as $row) {
        $authors = db_fetch_all(
            'SELECT id, nickname, num_tracks FROM muzx_authors '
            . 'WHERE TRIM(COALESCE(city, "")) = ? '
            . 'AND TRIM(COALESCE(city_en, "")) = ? '
            . 'AND TRIM(COALESCE(country, "")) = ? '
            . 'AND TRIM(COALESCE(country_en, "")) = ? '
            . 'AND num_tracks >= 2 '
            . 'ORDER BY num_tracks DESC, nickname ASC',
            'ssss',
            [
                (string) ($row['city_ru'] ?? ''),
                (string) ($row['city_en'] ?? ''),
                (string) ($row['country_ru'] ?? ''),
                (string) ($row['country_en'] ?? ''),
            ]
        );

        $cities[] = [
            'city_ru' => (string) ($row['city_ru'] ?? ''),
            'city_en' => (string) ($row['city_en'] ?? ''),
            'country_ru' => (string) ($row['country_ru'] ?? ''),
            'country_en' => (string) ($row['country_en'] ?? ''),
            'count' => (int) $row['cnt'],
            'count_label' => zxtunes_authors_count_label((int) $row['cnt']),
            'flag_url' => zxtunes_country_flag_url(
                (string) ($row['country_en'] ?? ''),
                (string) ($row['country_ru'] ?? '')
            ),
            'authors' => $authors,
        ];
    }

    $minTracks = PHP_INT_MAX;
    $maxTracks = 0;
    foreach ($cities as $city) {
        foreach ($city['authors'] as $author) {
            $tracks = (int) $author['num_tracks'];
            $minTracks = min($minTracks, $tracks);
            $maxTracks = max($maxTracks, $tracks);
        }
    }

    if ($minTracks === PHP_INT_MAX) {
        $minTracks = 2;
        $maxTracks = 2;
    }

    foreach ($cities as &$city) {
        $city['authors'] = array_map(static function (array $author) use ($minTracks, $maxTracks): array {
            $tracks = (int) $author['num_tracks'];

            return [
                'id' => (int) $author['id'],
                'nickname' => (string) $author['nickname'],
                'font_size' => zxtunes_author_map_font_size($tracks, $minTracks, $maxTracks),
            ];
        }, $city['authors']);
    }
    unset($city);

    return $cities;
}
