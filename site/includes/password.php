<?php

function zxtunes_legacy_hash(string $plain): string
{
    return strrev(md5($plain)) . 'b3p6f';
}

function zxtunes_hash_password(string $plain): string
{
    return password_hash($plain, PASSWORD_DEFAULT);
}

function zxtunes_is_legacy_hash(string $stored): bool
{
    return str_ends_with($stored, 'b3p6f');
}

function zxtunes_verify_password(string $plain, string $stored): bool
{
    if (zxtunes_is_legacy_hash($stored)) {
        return hash_equals($stored, zxtunes_legacy_hash($plain));
    }
    return password_verify($plain, $stored);
}

function zxtunes_upgrade_password_if_needed(int $user_id, string $plain, string $stored): void
{
    if (!zxtunes_is_legacy_hash($stored) && !password_needs_rehash($stored, PASSWORD_DEFAULT)) {
        return;
    }
    $new_hash = zxtunes_hash_password($plain);
    db_execute('UPDATE users SET password=? WHERE id=? LIMIT 1', 'si', [$new_hash, $user_id]);
}
