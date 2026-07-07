<?php

function h(?string $value): string
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

/** Highlight search term in escaped HTML. */
function highlight_search(string $text, string $term): string
{
    if ($term === '') {
        return h($text);
    }

    $pos = mb_stripos($text, $term, 0, 'UTF-8');
    if ($pos === false) {
        return h($text);
    }

    $len = mb_strlen($term, 'UTF-8');
    $before = h(mb_substr($text, 0, $pos, 'UTF-8'));
    $match = h(mb_substr($text, $pos, $len, 'UTF-8'));
    $after = h(mb_substr($text, $pos + $len, null, 'UTF-8'));

    return $before . '<b style="COLOR: #e08200">' . $match . '</b>' . $after;
}

function db_like_escape(string $value): string
{
    return str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], $value);
}
