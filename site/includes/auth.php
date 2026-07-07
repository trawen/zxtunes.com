<?php
/**
 * Authorization helpers for zxtunes.
 * Admin: users.acess >= 777 (e.g. newart).
 */

function zxtunes_is_admin(): bool
{
    return login() && (int) ($_SESSION['user_acess'] ?? 0) >= 777;
}

function zxtunes_can_edit_author(int $author_id): bool
{
    if (zxtunes_is_admin()) {
        return true;
    }
    return login() && (int) ($_SESSION['user_author_id'] ?? 0) === $author_id;
}

function zxtunes_require_admin(): void
{
    if (!zxtunes_is_admin()) {
        http_response_code(403);
        header('Content-Type: text/plain; charset=utf-8');
        exit('Access denied');
    }
}

function zxtunes_require_author_edit(int $author_id): void
{
    if (!zxtunes_can_edit_author($author_id)) {
        http_response_code(403);
        header('Content-Type: text/plain; charset=utf-8');
        exit('Access denied');
    }
}
