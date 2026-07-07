#!/bin/bash
set -e

APP_ROOT="${APP_ROOT:-/home/zxtunes/web/zxtunes.com/public_html}"
DATA_ROOT="${ZXTUNES_DATA_ROOT:-/home/zxtunes/web/zxtunes.com/data}"

log_info() {
    echo "[zxtunes-runtime] INFO $*"
}

if [ ! -f "$APP_ROOT/authors_list.php" ]; then
    echo "[zxtunes-runtime] ERROR authors_list.php missing in $APP_ROOT" >&2
    exit 1
fi

mkdir -p "$DATA_ROOT/cache/smarty/templates_c" \
         "$DATA_ROOT/cache/smarty/cache" \
         "$DATA_ROOT/tmp" \
         /home/zxtunes/tmp
chown -R www-data:www-data "$DATA_ROOT" /home/zxtunes/tmp 2>/dev/null || true

wait_for_db() {
    local i=0
    while [ "$i" -lt 90 ]; do
        if php -r '
            $h = getenv("DB_HOST") ?: "db";
            $u = getenv("DB_USER") ?: "zxtunes_u";
            $p = getenv("DB_PASS") ?: "";
            $n = getenv("DB_NAME") ?: "zxtunes_db";
            if ($p === "" && getenv("ALLOW_EMPTY_DB_PASSWORD") !== "1") { exit(1); }
            $m = @mysqli_connect($h, $u, $p, $n);
            exit($m ? 0 : 1);
        ' 2>/dev/null; then
            log_info "mysql ready host=${DB_HOST:-db} name=${DB_NAME:-zxtunes_db}"
            return 0
        fi
        i=$((i + 1))
        sleep 1
    done
    log_info "WARN mysql not ready after ${i}s"
    return 1
}
wait_for_db || true

(while true; do
    sleep 600
    find /home/zxtunes/tmp -maxdepth 1 -name 'sess_*' -mmin +30 -delete 2>/dev/null || true
done) &

exec php-fpm
