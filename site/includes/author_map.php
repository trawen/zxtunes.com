<?php

require_once __DIR__ . '/country_flags.php';

function zxtunes_normalize_map_city(string $city): string
{
    $city = trim($city);
    $city = preg_replace('/\s*\(\?\)\s*$/u', '', $city) ?? $city;
    $city = rtrim($city, '?');
    $city = trim($city);

    $key = mb_strtolower(preg_replace('/\s+/u', ' ', $city) ?? $city, 'UTF-8');
    static $aliases = [
        'saint-petersburg' => 'st.petersburg',
        'saint petersburg' => 'st.petersburg',
        'st petersburg' => 'st.petersburg',
        'st. petersburg' => 'st.petersburg',
        'spb' => 'st.petersburg',
        'ленинград' => 'st.petersburg',
        'kharkov' => 'kharkov',
        'kiev' => 'kiev',
        'dnepropetrovsk' => 'dnepropetrovsk',
        'ekaterinburg' => 'ekaterinburg',
        'ekaterenburg' => 'ekaterinburg',
        'rosto on don' => 'rostov-na-donu',
        'novosibirsk' => 'novosibirsk',
    ];

    return $aliases[$key] ?? $city;
}

function zxtunes_normalize_map_country(string $country_ru, string $country_en): string
{
    $country = trim($country_en) !== '' ? trim($country_en) : trim($country_ru);
    $key = mb_strtolower($country, 'UTF-8');
    static $aliases = [
        'england' => 'united kingdom',
        'scotland' => 'united kingdom',
        'northern ireland' => 'united kingdom',
    ];

    return $aliases[$key] ?? $country;
}

function zxtunes_city_map_key(string $city_ru, string $city_en, string $country_ru, string $country_en): string
{
    $city = trim($city_en) !== '' ? trim($city_en) : trim($city_ru);
    $city = zxtunes_normalize_map_city($city);
    $country = zxtunes_normalize_map_country($country_ru, $country_en);

    return mb_strtolower($city . '|' . $country, 'UTF-8');
}

function zxtunes_map_coord_key(float $lat, float $lng): string
{
    return round($lat, 4) . '|' . round($lng, 4);
}

function zxtunes_merge_map_point(array $existing, array $point): array
{
    if ($point['count'] > ($existing['_part_count'] ?? 0)) {
        $existing['city_ru'] = $point['city_ru'];
        $existing['city_en'] = $point['city_en'];
        $existing['country_ru'] = $point['country_ru'];
        $existing['country_en'] = $point['country_en'];
        $existing['_part_count'] = $point['count'];
    }

    $existing['count'] += $point['count'];

    return $existing;
}

function zxtunes_city_variant_key(array $row): string
{
    return implode("\0", [
        (string) ($row['city_ru'] ?? ''),
        (string) ($row['city_en'] ?? ''),
        (string) ($row['country_ru'] ?? ''),
        (string) ($row['country_en'] ?? ''),
    ]);
}

function zxtunes_fetch_top_city_authors(array $variants): array
{
    if ($variants === []) {
        return [];
    }

    $conds = [];
    $types = '';
    $params = [];

    foreach ($variants as $variant) {
        $conds[] = '(TRIM(COALESCE(city, "")) = ? '
            . 'AND TRIM(COALESCE(city_en, "")) = ? '
            . 'AND TRIM(COALESCE(country, "")) = ? '
            . 'AND TRIM(COALESCE(country_en, "")) = ?)';
        $types .= 'ssss';
        $params[] = (string) ($variant['city_ru'] ?? '');
        $params[] = (string) ($variant['city_en'] ?? '');
        $params[] = (string) ($variant['country_ru'] ?? '');
        $params[] = (string) ($variant['country_en'] ?? '');
    }

    return db_fetch_all(
        'SELECT id, nickname, num_tracks FROM muzx_authors '
        . 'WHERE (' . implode(' OR ', $conds) . ') '
        . 'AND num_tracks >= 2 '
        . 'ORDER BY num_tracks DESC, nickname ASC',
        $types,
        $params
    );
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
    $merged = [];

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
        $point = [
            'lat' => (float) $c['lat'],
            'lng' => (float) $c['lng'],
            'count' => (int) $row['cnt'],
            'city_ru' => (string) ($row['city_ru'] ?? ''),
            'city_en' => (string) ($row['city_en'] ?? ''),
            'country_ru' => (string) ($row['country_ru'] ?? ''),
            'country_en' => (string) ($row['country_en'] ?? ''),
        ];

        $coordKey = zxtunes_map_coord_key($point['lat'], $point['lng']);
        if (!isset($merged[$coordKey])) {
            $point['_part_count'] = $point['count'];
            $merged[$coordKey] = $point;
            continue;
        }

        $merged[$coordKey] = zxtunes_merge_map_point($merged[$coordKey], $point);
    }

    $points = [];
    foreach ($merged as $point) {
        unset($point['_part_count']);
        $points[] = $point;
    }

    usort($points, static function (array $a, array $b): int {
        return $b['count'] <=> $a['count'];
    });

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
        . 'ORDER BY cnt DESC'
    );

    $coords = zxtunes_load_city_coords();
    $mergedRows = [];

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
        $coordKey = zxtunes_map_coord_key((float) $c['lat'], (float) $c['lng']);
        $row['cnt'] = (int) $row['cnt'];
        $variant = [
            'city_ru' => (string) ($row['city_ru'] ?? ''),
            'city_en' => (string) ($row['city_en'] ?? ''),
            'country_ru' => (string) ($row['country_ru'] ?? ''),
            'country_en' => (string) ($row['country_en'] ?? ''),
        ];
        $variantKey = zxtunes_city_variant_key($variant);

        if (!isset($mergedRows[$coordKey])) {
            $mergedRows[$coordKey] = $row;
            $mergedRows[$coordKey]['_part_count'] = $row['cnt'];
            $mergedRows[$coordKey]['variants'] = [$variantKey => $variant];
            continue;
        }

        $existing = $mergedRows[$coordKey];
        if ($row['cnt'] > ($existing['_part_count'] ?? 0)) {
            $mergedRows[$coordKey]['city_ru'] = $row['city_ru'];
            $mergedRows[$coordKey]['city_en'] = $row['city_en'];
            $mergedRows[$coordKey]['country_ru'] = $row['country_ru'];
            $mergedRows[$coordKey]['country_en'] = $row['country_en'];
            $mergedRows[$coordKey]['_part_count'] = $row['cnt'];
        }
        $mergedRows[$coordKey]['cnt'] += $row['cnt'];
        $mergedRows[$coordKey]['variants'][$variantKey] = $variant;
    }

    $rows = array_values($mergedRows);
    usort($rows, static function (array $a, array $b): int {
        return $b['cnt'] <=> $a['cnt'];
    });
    $rows = array_slice($rows, 0, $limit);

    $cities = [];
    foreach ($rows as $row) {
        $variants = array_values($row['variants'] ?? []);
        unset($row['_part_count'], $row['variants']);
        $authors = zxtunes_fetch_top_city_authors($variants);

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
