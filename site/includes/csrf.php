<?php

function csrf_token(): string
{
    if (empty($_SESSION['_csrf'])) {
        $_SESSION['_csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['_csrf'];
}

function csrf_verify(): void
{
    $token = $_POST['_csrf'] ?? $_REQUEST['_csrf'] ?? '';
    if ($token === '' || !hash_equals(csrf_token(), $token)) {
        http_response_code(403);
        header('Content-Type: text/plain; charset=utf-8');
        exit('Invalid CSRF token');
    }
}

function csrf_verify_if_post(): void
{
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        csrf_verify();
    }
}
