<?php

function db_stmt(string $sql, string $types = '', array $params = []): mysqli_stmt|false
{
    global $db;
    $stmt = mysqli_prepare($db, $sql);
    if (!$stmt) {
        return false;
    }
    if ($types !== '') {
        mysqli_stmt_bind_param($stmt, $types, ...$params);
    }
    return $stmt;
}

function db_execute(string $sql, string $types = '', array $params = []): bool
{
    $stmt = db_stmt($sql, $types, $params);
    if (!$stmt) {
        return false;
    }
    $ok = mysqli_stmt_execute($stmt);
    mysqli_stmt_close($stmt);
    return $ok;
}

function db_fetch_one(string $sql, string $types = '', array $params = []): ?array
{
    $stmt = db_stmt($sql, $types, $params);
    if (!$stmt || !mysqli_stmt_execute($stmt)) {
        if ($stmt) {
            mysqli_stmt_close($stmt);
        }
        return null;
    }
    $result = mysqli_stmt_get_result($stmt);
    $row = $result ? mysqli_fetch_assoc($result) : null;
    mysqli_stmt_close($stmt);
    return $row ?: null;
}

function db_fetch_all(string $sql, string $types = '', array $params = []): array
{
    $stmt = db_stmt($sql, $types, $params);
    if (!$stmt || !mysqli_stmt_execute($stmt)) {
        if ($stmt) {
            mysqli_stmt_close($stmt);
        }
        return [];
    }
    $result = mysqli_stmt_get_result($stmt);
    $rows = [];
    if ($result) {
        while ($row = mysqli_fetch_assoc($result)) {
            $rows[] = $row;
        }
    }
    mysqli_stmt_close($stmt);
    return $rows;
}

function db_insert_id(): int
{
    global $db;
    return (int) mysqli_insert_id($db);
}
