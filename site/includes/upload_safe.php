<?php
/**
 * Safe file upload — extension whitelist + reject PHP/script content.
 */

function zxtunes_upload_allowed_ext(): array
{
    return [
        'zip', 'rar', '7z', 'lha', 'lzh',
        'ay', 'ym', 'pt1', 'pt2', 'pt3', 'sqt', 'mod', 'sid', 'mp3', 'ogg', 'wav',
        'jpg', 'jpeg', 'png', 'gif',
        'txt', 'doc', 'pdf', 'rtf',
    ];
}

function zxtunes_safe_upload(array $file, string $dest_path, ?array $allowed_ext = null): bool
{
    if (empty($file['tmp_name']) || !is_uploaded_file($file['tmp_name'])) {
        return false;
    }

    $allowed_ext = $allowed_ext ?? zxtunes_upload_allowed_ext();
    $ext = strtolower(pathinfo($file['name'] ?? '', PATHINFO_EXTENSION));
    if ($ext === '' || !in_array($ext, $allowed_ext, true)) {
        return false;
    }

    $blocked = ['php', 'phtml', 'php3', 'php4', 'php5', 'php7', 'php8', 'phar', 'cgi', 'pl', 'asp', 'aspx', 'jsp', 'htaccess', 'shtml'];
    if (in_array($ext, $blocked, true)) {
        return false;
    }

    $head = @file_get_contents($file['tmp_name'], false, null, 0, 512);
    if ($head !== false) {
        $snippet = strtolower($head);
        if (str_contains($snippet, '<?php') || str_contains($snippet, '<?=') || str_contains($snippet, '<script')) {
            return false;
        }
    }

    $dir = dirname($dest_path);
    if (!is_dir($dir) && !mkdir($dir, 0755, true)) {
        return false;
    }

    return move_uploaded_file($file['tmp_name'], $dest_path);
}
