<?php

function zxtunes_auth_secret(): string
{
    return getenv('APP_SECRET') ?: 'zxtunes-local-dev-change-me';
}

function zxtunes_auth_token(int $user_id, string $login, string $password_hash): string
{
    return hash_hmac('sha256', $user_id . '|' . $login . '|' . $password_hash, zxtunes_auth_secret());
}

function zxtunes_set_session_user(array $user): void
{
    $_SESSION['user_id'] = (int) $user['id'];
    $_SESSION['user_login'] = $user['login'];
    $_SESSION['user_author_id'] = (int) ($user['author_id'] ?? 0);
    $_SESSION['user_acess'] = (int) ($user['acess'] ?? 0);
    $_SESSION['id'] = (int) $user['id'];
    $_SESSION['login'] = $user['login'];
    unset($_SESSION['user_password'], $_SESSION['password']);
}

function zxtunes_set_remember_cookie(array $user): void
{
    $token = zxtunes_auth_token((int) $user['id'], $user['login'], $user['password']);
    $expires = time() + 60 * 60 * 24 * 30;
    $opts = ['expires' => $expires, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax'];
    setcookie('user_id', (string) $user['id'], $opts);
    setcookie('user_token', $token, $opts);
}

function zxtunes_clear_auth_cookies(): void
{
    $opts = ['expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax'];
    setcookie('user_id', '', $opts);
    setcookie('user_token', '', $opts);
    setcookie('user_password', '', $opts);
    setcookie('user_login', '', $opts);
}

function zxtunes_logout(): void
{
    unset(
        $_SESSION['user_id'],
        $_SESSION['user_login'],
        $_SESSION['user_author_id'],
        $_SESSION['user_acess'],
        $_SESSION['user_password'],
        $_SESSION['id'],
        $_SESSION['login'],
        $_SESSION['password']
    );
    zxtunes_clear_auth_cookies();
}

function zxtunes_try_cookie_login(): void
{
    if (login()) {
        return;
    }

    if (!isset($_COOKIE['user_id'], $_COOKIE['user_token'])) {
        return;
    }

    $user_id = (int) $_COOKIE['user_id'];
    if ($user_id <= 0) {
        return;
    }

    $user = db_fetch_one(
        'SELECT * FROM users WHERE id=? AND activation=1 LIMIT 1',
        'i',
        [$user_id]
    );
    if (!$user) {
        return;
    }

    $expected = zxtunes_auth_token((int) $user['id'], $user['login'], $user['password']);
    if (!hash_equals($expected, (string) $_COOKIE['user_token'])) {
        return;
    }

    zxtunes_set_session_user($user);
}

function zxtunes_login_by_credentials(string $login, string $plain_password): ?array
{
    $user = db_fetch_one(
        'SELECT * FROM users WHERE login=? AND activation=1 LIMIT 1',
        's',
        [$login]
    );
    if (!$user || !zxtunes_verify_password($plain_password, $user['password'])) {
        return null;
    }
    zxtunes_upgrade_password_if_needed((int) $user['id'], $plain_password, $user['password']);
    $user = db_fetch_one('SELECT * FROM users WHERE id=? LIMIT 1', 'i', [(int) $user['id']]);
    return $user;
}
