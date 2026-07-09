#!/usr/bin/env python3
"""Generate slug_ru / slug_en for muzx_authors."""

from __future__ import annotations

import re
import subprocess
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CYRILLIC = {
    "а": "a", "б": "b", "в": "v", "г": "g", "д": "d", "е": "e", "ё": "e",
    "ж": "zh", "з": "z", "и": "i", "й": "y", "к": "k", "л": "l", "м": "m",
    "н": "n", "о": "o", "п": "p", "р": "r", "с": "s", "т": "t", "у": "u",
    "ф": "f", "х": "h", "ц": "ts", "ч": "ch", "ш": "sh", "щ": "sch",
    "ъ": "", "ы": "y", "ь": "", "э": "e", "ю": "yu", "я": "ya",
}


def load_env() -> dict[str, str]:
    env: dict[str, str] = {}
    for line in (ROOT / ".env").read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        env[key.strip()] = value.strip().strip("'\"")
    return env


def mysql_query(sql: str, env: dict[str, str], root: bool = False) -> str:
    user = "root" if root else env["MYSQL_USER"]
    password = env["MYSQL_ROOT_PASSWORD"] if root else env["MYSQL_PASSWORD"]
    cmd = [
        "docker", "exec", "-i", "zxtunes_db", "mysql",
        "--default-character-set=utf8mb4", "-u", user, f"-p{password}",
        env["MYSQL_DATABASE"], "-B", "-N", "-e", sql,
    ]
    return subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)


def mysql_exec(sql: str, env: dict[str, str], root: bool = True) -> None:
    user = "root" if root else env["MYSQL_USER"]
    password = env["MYSQL_ROOT_PASSWORD"] if root else env["MYSQL_PASSWORD"]
    cmd = [
        "docker", "exec", "-i", "zxtunes_db", "mysql",
        "--default-character-set=utf8mb4", "-u", user, f"-p{password}",
        env["MYSQL_DATABASE"], "-e", sql,
    ]
    subprocess.check_call(cmd, stderr=subprocess.DEVNULL)


def nullish(value: str | None) -> str:
    if value is None:
        return ""
    value = str(value).strip()
    return "" if value.upper() == "NULL" else value


def transliterate(text: str) -> str:
    out: list[str] = []
    for ch in text:
        low = ch.lower()
        if low in CYRILLIC:
            rep = CYRILLIC[low]
            if ch.isupper() and rep:
                rep = rep[0].upper() + rep[1:]
            out.append(rep)
        else:
            out.append(ch)
    return "".join(out)


def slugify(text: str) -> str:
    text = nullish(text)
    if not text:
        return ""
    text = transliterate(text)
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-{2,}", "-", text).strip("-")
    return text


def esc_sql(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", "''")


def fetch_authors(env: dict[str, str]) -> list[dict]:
    raw = mysql_query(
        """
SELECT id, nickname, group_name, city, city_en
FROM muzx_authors
ORDER BY id
""",
        env,
    )
    rows: list[dict] = []
    for line in raw.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        if len(parts) < 5:
            continue
        rows.append(
            {
                "id": int(parts[0]),
                "nickname": nullish(parts[1]),
                "group_name": nullish(parts[2]),
                "city": nullish(parts[3]),
                "city_en": nullish(parts[4]),
            }
        )
    return rows


def base_slug(author: dict, lang: str) -> str:
    nick = slugify(author["nickname"]) or f"author-{author['id']}"
    group = nullish(author["group_name"])
    if group and group != "0":
        group_slug = slugify(group)
        if group_slug:
            return f"{nick}-{group_slug}"
    return nick


def city_slug(author: dict, lang: str) -> str:
    city = author["city"] if lang == "ru" else (author["city_en"] or author["city"])
    return slugify(city)


def assign_slugs(authors: list[dict]) -> dict[int, dict[str, str]]:
    bases: dict[int, dict[str, str]] = {}
    for author in authors:
        bases[author["id"]] = {
            "ru": base_slug(author, "ru"),
            "en": base_slug(author, "en"),
        }

    assigned: dict[int, dict[str, str]] = {}
    for lang in ("ru", "en"):
        used: set[str] = set()
        base_counts: dict[str, int] = {}
        for author in authors:
            base_counts[bases[author["id"]][lang]] = base_counts.get(bases[author["id"]][lang], 0) + 1

        for author in authors:
            aid = author["id"]
            if aid not in assigned:
                assigned[aid] = {}
            slug = bases[aid][lang]
            if base_counts[slug] > 1:
                city_part = city_slug(author, lang)
                if city_part:
                    slug = f"{slug}-{city_part}"
            if slug in used:
                slug = f"{slug}-{aid}"
            assigned[aid][lang] = slug
            used.add(slug)
    return assigned


def main() -> int:
    env = load_env()
    for key in ("MYSQL_USER", "MYSQL_PASSWORD", "MYSQL_DATABASE", "MYSQL_ROOT_PASSWORD"):
        if key not in env:
            print(f"Missing {key}", file=sys.stderr)
            return 1

    authors = fetch_authors(env)
    slugs = assign_slugs(authors)

    updates = []
    for author in authors:
        aid = author["id"]
        ru = esc_sql(slugs[aid]["ru"])
        en = esc_sql(slugs[aid]["en"])
        updates.append(
            f"UPDATE muzx_authors SET slug_ru='{ru}', slug_en='{en}' WHERE id={aid};"
        )

    out = ROOT / "db" / "migrations" / "004_author_slugs_generated.sql"
    out.write_text(
        "-- Auto-generated author slugs\nSET NAMES utf8mb4;\n\n" + "\n".join(updates) + "\n",
        encoding="utf-8",
    )

    mysql_exec(out.read_text(encoding="utf-8"), env)

    # Add unique indexes if missing
    mysql_exec(
        """
SET @has := (SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name = 'muzx_authors' AND index_name = 'slug_ru');
SET @sql := IF(@has = 0, 'ALTER TABLE muzx_authors ADD UNIQUE KEY slug_ru (slug_ru)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @has := (SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name = 'muzx_authors' AND index_name = 'slug_en');
SET @sql := IF(@has = 0, 'ALTER TABLE muzx_authors ADD UNIQUE KEY slug_en (slug_en)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
""",
        env,
    )

    print(f"Generated slugs for {len(authors)} authors")
    for aid in (227, 478, 529):
        if aid in slugs:
            print(f"  id={aid}: ru={slugs[aid]['ru']} en={slugs[aid]['en']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
