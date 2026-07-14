<?php

/**
 * Author canonical URLs: /{ru|en}/authors/{slug}
 */

function zxtunes_lang_prefix(?string $language = null): string
{
    $language = $language ?? ($_SESSION['language'] ?? 'rus');
    return ($language === 'rus' || $language === 'ru') ? 'ru' : 'en';
}

function zxtunes_lang_from_prefix(string $prefix): string
{
    return ($prefix === 'ru') ? 'rus' : 'eng';
}

function zxtunes_slugify_part(string $text): string
{
    static $map = [
        'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e', 'ё' => 'e',
        'ж' => 'zh', 'з' => 'z', 'и' => 'i', 'й' => 'y', 'к' => 'k', 'л' => 'l', 'м' => 'm',
        'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't', 'у' => 'u',
        'ф' => 'f', 'х' => 'h', 'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'sch',
        'ъ' => '', 'ы' => 'y', 'ь' => '', 'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
    ];

    $text = trim($text);
    if ($text === '') {
        return '';
    }
    $text = mb_strtolower($text, 'UTF-8');
    $out = '';
    $len = mb_strlen($text, 'UTF-8');
    for ($i = 0; $i < $len; $i++) {
        $ch = mb_substr($text, $i, 1, 'UTF-8');
        $out .= $map[$ch] ?? $ch;
    }
    $out = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $out) ?: $out;
    $out = strtolower($out);
    $out = preg_replace('/[^a-z0-9]+/', '-', $out);
    $out = preg_replace('/-+/', '-', $out);
    return trim($out, '-');
}

function zxtunes_author_slug_column(string $lang_prefix): string
{
    return ($lang_prefix === 'ru') ? 'slug_ru' : 'slug_en';
}

function zxtunes_author_id_by_slug(string $slug, string $lang_prefix): ?int
{
    $slug = trim($slug, '/');
    if ($slug === '' || !preg_match('/^[a-z0-9][a-z0-9-]*$/', $slug)) {
        return null;
    }
    $col = zxtunes_author_slug_column($lang_prefix);
    $row = db_fetch_one("SELECT id FROM muzx_authors WHERE `$col`=? LIMIT 1", 's', [$slug]);
    return $row ? (int) $row['id'] : null;
}

function zxtunes_author_slug(array $author, ?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();
    $key = ($lang_prefix === 'ru') ? 'slug_ru' : 'slug_en';
    $slug = trim((string) ($author[$key] ?? ''));
    if ($slug !== '') {
        return $slug;
    }
    $id = (int) ($author['id'] ?? 0);
    return $id > 0 ? ('author-' . $id) : 'author';
}

/**
 * @param array<string, scalar|null> $params  md, play, sort, page, interview, ...
 */
function zxtunes_author_url(array $author, array $params = [], ?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();
    $slug = zxtunes_author_slug($author, $lang_prefix);
    $url = '/' . $lang_prefix . '/authors/' . rawurlencode($slug);

    $query = [];
    foreach ($params as $key => $value) {
        if ($value === null || $value === '' || $key === 'id' || $key === 'slug' || $key === 'ln') {
            continue;
        }
        $query[$key] = $value;
    }
    if ($query) {
        $url .= '?' . http_build_query($query);
    }
    return $url;
}

function zxtunes_author_photo_url(array $author, ?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();
    $slug = zxtunes_author_slug($author, $lang_prefix);

    return '/' . $lang_prefix . '/authors/' . rawurlencode($slug) . '/photo';
}

function zxtunes_author_photo_url_by_id(int $id, ?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();
    $row = zxtunes_author_slug_row($id);
    if (!$row) {
        return '/author_photo.php?id=' . $id;
    }

    return zxtunes_author_photo_url($row, $lang_prefix);
}

function zxtunes_author_url_by_id(int $id, array $params = [], ?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();
    $row = zxtunes_author_slug_row($id);
    if (!$row) {
        return '/author.php?id=' . $id;
    }
    return zxtunes_author_url($row, $params, $lang_prefix);
}

/**
 * Cached lookup of slug columns for a single author id.
 * Preloads the whole (small) slug table on first call to avoid N+1 queries.
 *
 * @return array{id:int,slug_ru:string,slug_en:string}|null
 */
function zxtunes_author_slug_row(int $id): ?array
{
    static $cache = null;
    if ($cache === null) {
        $cache = [];
        $rows = db_fetch_all('SELECT id, slug_ru, slug_en FROM muzx_authors', '', []);
        foreach ((array) $rows as $row) {
            $cache[(int) $row['id']] = [
                'id' => (int) $row['id'],
                'slug_ru' => (string) $row['slug_ru'],
                'slug_en' => (string) $row['slug_en'],
            ];
        }
    }
    return $cache[$id] ?? null;
}

/** Smarty modifier: author id -> canonical URL. */
function smarty_modifier_aurl($id): string
{
    $id = (int) $id;
    if ($id <= 0) {
        return '#';
    }
    return zxtunes_author_url_by_id($id);
}

function zxtunes_resolve_author_request(): void
{
    $slug = trim((string) ($_REQUEST['slug'] ?? ''), '/');
    $ln = trim((string) ($_REQUEST['ln'] ?? ''));

    if ($ln === 'ru' || $ln === 'en') {
        $_SESSION['language'] = zxtunes_lang_from_prefix($ln);
        $_REQUEST['ln'] = ($_SESSION['language'] === 'rus') ? 'rus' : 'eng';
    }

    if ($slug !== '') {
        $lang_prefix = ($ln === 'en') ? 'en' : 'ru';
        $author_id = zxtunes_author_id_by_slug($slug, $lang_prefix);
        if (!$author_id) {
            http_response_code(404);
            echo 'Author not found';
            exit;
        }
        $_REQUEST['id'] = $author_id;
        $_GET['id'] = $author_id;
    }
}

function zxtunes_redirect_legacy_author_url(): void
{
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
        return;
    }
    if (!empty($_REQUEST['slug'])) {
        return;
    }
    $id = (int) ($_REQUEST['id'] ?? 0);
    if ($id <= 0) {
        return;
    }
    if (($_SERVER['SCRIPT_NAME'] ?? '') !== '/author.php' && !str_ends_with((string) ($_SERVER['SCRIPT_NAME'] ?? ''), '/author.php')) {
        return;
    }

    $lang_prefix = zxtunes_lang_prefix();
    if (!empty($_REQUEST['ln'])) {
        $ln = (string) $_REQUEST['ln'];
        if ($ln === 'rus' || $ln === 'ru') {
            $lang_prefix = 'ru';
        } elseif ($ln === 'eng' || $ln === 'en') {
            $lang_prefix = 'en';
        }
    }

    $row = db_fetch_one('SELECT id, slug_ru, slug_en FROM muzx_authors WHERE id=? LIMIT 1', 'i', [$id]);
    if (!$row) {
        return;
    }

    $params = $_GET;
    unset($params['id'], $params['ln']);
    $target = zxtunes_author_url($row, $params, $lang_prefix);

    $current = (string) ($_SERVER['REQUEST_URI'] ?? '');
    if (str_starts_with($current, $target)) {
        return;
    }

    header('Location: ' . $target, true, 301);
    exit;
}

function zxtunes_authors_map_url(?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();

    return '/' . $lang_prefix . '/authors-map';
}

function zxtunes_redirect_authors_map_url(): void
{
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
        return;
    }
    if (basename((string) ($_SERVER['SCRIPT_NAME'] ?? '')) !== 'authors_map.php') {
        return;
    }

    $path = parse_url((string) ($_SERVER['REQUEST_URI'] ?? ''), PHP_URL_PATH) ?: '';
    $canonical = zxtunes_authors_map_url();

    if ($path === '/authors_map.php') {
        $qs = $_GET;
        unset($qs['ln']);
        $target = $canonical;
        if ($qs) {
            $target .= '?' . http_build_query($qs);
        }
        header('Location: ' . $target, true, 301);
        exit;
    }

    if (preg_match('#^/(ru|en)/authors-map/?$#', $path, $m)) {
        $lang_prefix = zxtunes_lang_prefix();
        if ($m[1] !== $lang_prefix) {
            $qs = $_GET;
            unset($qs['ln']);
            $target = zxtunes_authors_map_url($lang_prefix);
            if ($qs) {
                $target .= '?' . http_build_query($qs);
            }
            header('Location: ' . $target, true, 302);
            exit;
        }
    }
}

function zxtunes_search_url(?string $lang_prefix = null): string
{
    $lang_prefix = $lang_prefix ?? zxtunes_lang_prefix();

    return '/' . $lang_prefix . '/search';
}

function zxtunes_redirect_search_url(): void
{
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
        return;
    }
    if (basename((string) ($_SERVER['SCRIPT_NAME'] ?? '')) !== 'search.php') {
        return;
    }

    $path = parse_url((string) ($_SERVER['REQUEST_URI'] ?? ''), PHP_URL_PATH) ?: '';
    $canonical = zxtunes_search_url();

    if ($path === '/search.php') {
        $qs = $_GET;
        unset($qs['ln']);
        $target = $canonical;
        if ($qs) {
            $target .= '?' . http_build_query($qs);
        }
        header('Location: ' . $target, true, 301);
        exit;
    }

    if (preg_match('#^/(ru|en)/search/?$#', $path, $m)) {
        $lang_prefix = zxtunes_lang_prefix();
        if ($m[1] !== $lang_prefix) {
            $qs = $_GET;
            unset($qs['ln']);
            $target = zxtunes_search_url($lang_prefix);
            if ($qs) {
                $target .= '?' . http_build_query($qs);
            }
            header('Location: ' . $target, true, 302);
            exit;
        }
    }
}
