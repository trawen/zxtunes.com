#!/usr/bin/env python3
"""Generate meta_description_ru/en for all muzx_authors."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MIN_LEN = 120
MAX_LEN = 160

CITY_GENITIVE_RU = {
    "Москва": "Москвы",
    "Санкт-Петербург": "Санкт-Петербурга",
    "Киев": "Киева",
    "Минск": "Минска",
    "Котлас": "Котласа",
    "Воронеж": "Воронежа",
    "Тирасполь": "Тирасполя",
    "Нижний Новгород": "Нижнего Новгорода",
    "Ростов-на-Дону": "Ростова-на-Дону",
    "Уфа": "Уфы",
    "Самара": "Самары",
    "Тольятти": "Тольятти",
    "Пермь": "Перми",
    "Казань": "Казани",
    "Омск": "Омска",
    "Тюмень": "Тюмени",
    "Томск": "Томска",
    "Курган": "Кургана",
    "Ижевск": "Ижевска",
    "Гродно": "Гродно",
    "Брно": "Брно",
    "Bratislava": "Братиславы",
}


def load_env() -> dict[str, str]:
    env: dict[str, str] = {}
    env_path = ROOT / ".env"
    if not env_path.exists():
        return env
    for line in env_path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        env[key.strip()] = value.strip().strip("'\"")
    return env


def mysql_query(sql: str, env: dict[str, str]) -> str:
    cmd = [
        "docker",
        "exec",
        "-i",
        "zxtunes_db",
        "mysql",
        "--default-character-set=utf8mb4",
        "-u",
        env["MYSQL_USER"],
        f"-p{env['MYSQL_PASSWORD']}",
        env["MYSQL_DATABASE"],
        "-B",
        "-N",
        "-e",
        sql,
    ]
    return subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)


def esc_sql(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", "''")


def nullish(value: str | None) -> str:
    if value is None:
        return ""
    value = str(value).strip()
    if value.upper() == "NULL":
        return ""
    return value


def city_genitive_ru(city: str) -> str:
    city = city.strip()
    if not city:
        return ""
    if city in CITY_GENITIVE_RU:
        return CITY_GENITIVE_RU[city]
    if city.endswith("ск"):
        return city + "а"
    if city.endswith("ас"):
        return city + "а"
    if city.endswith("ец"):
        return city[:-2] + "ца"
    if city.endswith("нь"):
        return city[:-1] + "и"
    if city.endswith("ль"):
        return city[:-1] + "и"
    if city.endswith("а"):
        return city[:-1] + "ы"
    if city.endswith("й"):
        return city[:-1] + "я"
    if city.endswith("о"):
        return city[:-1] + "а"
    return city + "а"


def is_good_title(title: str) -> bool:
    if len(title) < 4:
        return False
    if re.fullmatch(r"[\d\W_]+", title):
        return False
    if re.fullmatch(r"\d{2,4}", title):
        return False
    alpha = sum(ch.isalpha() for ch in title)
    if alpha < 4:
        return False
    lower = title.lower()
    if lower.startswith("by ") or lower.startswith("music by"):
        return False
    return True


def clean_track_name(name: str, filename: str = "") -> str:
    name = nullish(name)
    filename = nullish(filename)
    name = re.sub(r"\s+", " ", name).strip("'\"").strip()
    name = re.sub(r"\(C\)", "", name, flags=re.I)
    name = re.sub(r"\bBY\s+.+$", "", name, flags=re.I)
    name = re.sub(r"^[^\-—]+[\-—]\s*", "", name)
    name = re.sub(r"^[^']*'\s*", "", name)
    name = re.sub(r"[!]+", "", name)
    name = re.sub(r"\s+", " ", name).strip(" -—,.")
    if not is_good_title(name) and filename:
        stem = re.sub(r"\.[^.]+$", "", filename)
        stem = re.sub(r"[_]+", " ", stem).strip()
        if is_good_title(stem):
            name = stem
    if not is_good_title(name):
        return ""
    # Prefer human-readable fragment before comma.
    if "," in name:
        head = name.split(",", 1)[0].strip()
        if is_good_title(head):
            name = head
    if len(name) > 28:
        name = name[:25].rstrip() + "..."
    return name


def real_name(author: dict, lang: str) -> str:
    if lang == "ru":
        first, last = nullish(author["first_name"]), nullish(author["last_name"])
    else:
        first, last = nullish(author["first_name_en"]), nullish(author["last_name_en"])
    return " ".join(p for p in (first, last) if p)


def city_label(author: dict, lang: str) -> str:
    if lang == "ru":
        city = nullish(author["city"])
        if not city:
            return ""
        return city_genitive_ru(city)
    city = nullish(author["city_en"]) or nullish(author["city"])
    country = nullish(author["country_en"]) or nullish(author["country"])
    if city and country and country not in city:
        return f"{city}, {country}"
    return city or country


def years_text(author: dict) -> str:
    yf = int(author["years_from"] or 0)
    yt = int(author["years_to"] or 0)
    if yf <= 0 and yt <= 0:
        return ""
    if yf > 0 and yt > 0 and yf != yt:
        return f"{yf}—{yt}"
    return str(yf or yt)


def also_inline(also: str, lang: str) -> str:
    also = nullish(also)
    if not also:
        return ""
    aliases = [a.strip() for a in re.split(r"[,;/]", also) if a.strip()]
    if not aliases:
        return ""
    shown = ", ".join(aliases[:2])
    return f", также {shown}" if lang == "ru" else f", also {shown}"


def group_name(author: dict) -> str:
    group = nullish(author["group_name"])
    if not group or group == "0":
        return ""
    return group


def hits_phrase(tracks: list[str], lang: str) -> str:
    if not tracks:
        return ""
    if len(tracks) == 1:
        return (
            f"Чаще всего слушают {tracks[0]}."
            if lang == "ru"
            else f"Most played: {tracks[0]}."
        )
    return (
        f"Популярные треки: {tracks[0]} и {tracks[1]}."
        if lang == "ru"
        else f"Most played: {tracks[0]} and {tracks[1]}."
    )


def compose_templates(author: dict, lang: str, hits: list[str]) -> list[str]:
    nick = nullish(author["nickname"]) or f"id {author['id']}"
    name = real_name(author, lang)
    also = also_inline(author["also"], lang)
    city = city_label(author, lang)
    years = years_text(author)
    tracks_n = int(author["num_tracks"] or 0)
    group = group_name(author)
    hits_text = hits_phrase(hits, lang)
    seed = int(author["id"]) % 5

    if lang == "ru":
        who = f"{nick} ({name}){also}" if name else f"{nick}{also}"
        city_from = f"из {city}" if city else ""
        years_in = f"в {years} годах" if years else ""
        years_comma = f", {years}" if years else ""
        count = (
            f"На странице собрано {tracks_n} трека на чипе AY/YM."
            if tracks_n > 0
            else "Страница автора с биографией и дискографией на ZXTunes."
        )
        count_short = (
            f"Собрано {tracks_n} AY/YM chiptune-треков."
            if tracks_n > 0
            else "Материалы автора на ZXTunes."
        )
        pool = [
            f"{who} — музыкант {city_from}, писавший chiptune для ZX Spectrum {years_in}. {count} {hits_text}",
            f"{who} — композитор {city_from}, создававший AY/YM-музыку для ZX Spectrum {years_in}. {count_short} {hits_text}",
            f"{who}, {city_from} — автор chiptune для ZX Spectrum{years_comma}. {count} {hits_text}",
            f"{who} — музыкант ZX Spectrum {city_from}{years_comma}, {tracks_n} треков AY/YM. {hits_text}",
            f"{who} — музыкант {city_from}, работавший на ZX Spectrum {years_in}. {count} {hits_text}",
        ]
        if group:
            pool.append(
                f"{who} из {group}, {city_from} — музыкант ZX Spectrum {years_in}. {count_short} {hits_text}"
            )
    else:
        who = f"{nick} ({name}){also}" if name else f"{nick}{also}"
        city_from = f"from {city}" if city else ""
        years_in = f"in {years}" if years else ""
        years_comma = f", {years}" if years else ""
        count = (
            f"This page features {tracks_n} AY/YM chiptune tracks."
            if tracks_n > 0
            else "Author page with biography and discography on ZXTunes."
        )
        count_short = (
            f"{tracks_n} AY/YM chiptune tracks collected here."
            if tracks_n > 0
            else "Author materials on ZXTunes."
        )
        pool = [
            f"{who} — musician {city_from}, writing ZX Spectrum chiptune {years_in}. {count} {hits_text}",
            f"{who} — composer {city_from}, creating AY/YM music for ZX Spectrum {years_in}. {count_short} {hits_text}",
            f"{who}, {city_from} — ZX Spectrum chiptune author{years_comma}. {count} {hits_text}",
            f"{who} — ZX Spectrum musician {city_from}{years_comma}, {tracks_n} AY/YM tracks. {hits_text}",
            f"{who} — musician {city_from}, active on ZX Spectrum {years_in}. {count} {hits_text}",
        ]
        if group:
            pool.append(
                f"{who} of {group}, {city_from} — ZX Spectrum musician {years_in}. {count_short} {hits_text}"
            )

    if not pool:
        return []
    ordered = [pool[(seed + i) % len(pool)] for i in range(len(pool))]
    return ordered


def fit_length(text: str, lang: str, allow_trim: bool = False) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    text = re.sub(r"\s+\.", ".", text)
    if MIN_LEN <= len(text) <= MAX_LEN:
        return text
    if len(text) > MAX_LEN and allow_trim:
        return text[: MAX_LEN - 3].rstrip(" ,.;—-") + "..."
    if len(text) < MIN_LEN:
        extra = (
            " AY/YM chiptune for ZX Spectrum."
            if lang == "en"
            else " Музыка AY/YM chiptune для ZX Spectrum."
        )
        if len(text) + len(extra) <= MAX_LEN:
            text += extra
    return text


def generate_description(author: dict, lang: str, hit_candidates: list[str]) -> str:
    short_hits = [h[:22].rstrip() + "..." if len(h) > 25 else h for h in hit_candidates]
    hit_sets: list[list[str]] = []
    if len(hit_candidates) >= 2:
        hit_sets.append(hit_candidates[:2])
        hit_sets.append(short_hits[:2])
    if len(hit_candidates) >= 1:
        hit_sets.append(hit_candidates[:1])
        hit_sets.append(short_hits[:1])
    hit_sets.append([])

    for hits in hit_sets:
        for template in compose_templates(author, lang, hits):
            text = fit_length(template, lang)
            if MIN_LEN <= len(text) <= MAX_LEN:
                return text

    return fit_length(compose_templates(author, lang, short_hits[:1])[0], lang, allow_trim=True)


def parse_tsv(raw: str, columns: list[str]) -> list[dict]:
    rows: list[dict] = []
    for line in raw.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        row = {}
        for i, col in enumerate(columns):
            row[col] = nullish(parts[i]) if i < len(parts) else ""
        rows.append(row)
    return rows


def fetch_authors(env: dict[str, str]) -> list[dict]:
    sql = """
SELECT id, nickname, also, group_name, first_name, last_name, first_name_en, last_name_en,
       city, country, city_en, country_en, years_from, years_to, num_tracks, spec
FROM muzx_authors
ORDER BY id
"""
    raw = mysql_query(sql, env)
    return parse_tsv(
        raw,
        [
            "id",
            "nickname",
            "also",
            "group_name",
            "first_name",
            "last_name",
            "first_name_en",
            "last_name_en",
            "city",
            "country",
            "city_en",
            "country_en",
            "years_from",
            "years_to",
            "num_tracks",
            "spec",
        ],
    )


def fetch_top_tracks(env: dict[str, str]) -> dict[str, list[str]]:
    sql = """
SELECT author_id, name, filename FROM (
  SELECT sa.author_id,
         REPLACE(REPLACE(s.name, CHAR(10), ' '), CHAR(9), ' ') AS name,
         s.filename,
         ROW_NUMBER() OVER (
           PARTITION BY sa.author_id
           ORDER BY s.downloads DESC, s.rating DESC, s.id ASC
         ) AS rn
  FROM muzx_songs_authors sa
  JOIN muzx_songs s ON s.id = sa.song_id
  WHERE s.hidden = 0
) ranked
WHERE rn <= 6
ORDER BY author_id, rn
"""
    raw = mysql_query(sql, env)
    tracks: dict[str, list[str]] = {}
    for line in raw.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        if len(parts) < 3:
            continue
        author_id, name, filename = parts[0], parts[1], parts[2]
        cleaned = clean_track_name(name, filename)
        if not cleaned:
            continue
        tracks.setdefault(author_id, [])
        if cleaned not in tracks[author_id] and len(tracks[author_id]) < 2:
            tracks[author_id].append(cleaned)
    return tracks


def main() -> int:
    env = load_env()
    required = ["MYSQL_USER", "MYSQL_PASSWORD", "MYSQL_DATABASE", "MYSQL_ROOT_PASSWORD"]
    missing = [k for k in required if k not in env]
    if missing:
        print("Missing env keys:", ", ".join(missing), file=sys.stderr)
        return 1

    authors = fetch_authors(env)
    top_tracks = fetch_top_tracks(env)

    updates: list[str] = []
    lengths: list[tuple[int, int, int]] = []

    for author in authors:
        aid = author["id"]
        hits = top_tracks.get(aid, [])
        ru = generate_description(author, "ru", hits)
        en = generate_description(author, "en", hits)
        lengths.append((int(aid), len(ru), len(en)))
        updates.append(
            "UPDATE muzx_authors SET "
            f"meta_description_ru='{esc_sql(ru)}', "
            f"meta_description_en='{esc_sql(en)}' "
            f"WHERE id={aid};"
        )

    out_sql = ROOT / "db" / "migrations" / "003_meta_descriptions_generated.sql"
    out_sql.write_text(
        "-- Auto-generated meta descriptions for muzx_authors\n"
        "SET NAMES utf8mb4;\n\n"
        + "\n".join(updates)
        + "\n",
        encoding="utf-8",
    )

    preview = ROOT / "db" / "migrations" / "003_meta_descriptions_preview.json"
    preview_rows = []
    for author in authors[:25]:
        aid = author["id"]
        preview_rows.append(
            {
                "id": int(aid),
                "nickname": author["nickname"],
                "also": author["also"],
                "city": author["city"],
                "hits": top_tracks.get(aid, []),
                "ru": generate_description(author, "ru", top_tracks.get(aid, [])),
                "en": generate_description(author, "en", top_tracks.get(aid, [])),
            }
        )
    preview.write_text(json.dumps(preview_rows, ensure_ascii=False, indent=2), encoding="utf-8")

    bad = [x for x in lengths if not (MIN_LEN <= x[1] <= MAX_LEN and MIN_LEN <= x[2] <= MAX_LEN)]
    missing_city = 0
    for author in authors:
        city = nullish(author["city"])
        if not city:
            continue
        ru = generate_description(author, "ru", top_tracks.get(author["id"], []))
        if city not in ru and city_genitive_ru(city) not in ru:
            missing_city += 1

    print(f"Generated {len(authors)} descriptions")
    print(f"Out of range: {len(bad)}")
    print(f"Missing city when city set: {missing_city}")
    if bad[:5]:
        print("Examples:", bad[:5])

    apply_cmd = [
        "docker",
        "exec",
        "-i",
        "zxtunes_db",
        "mysql",
        "--default-character-set=utf8mb4",
        "-u",
        "root",
        f"-p{env['MYSQL_ROOT_PASSWORD']}",
        env["MYSQL_DATABASE"],
    ]
    subprocess.run(
        apply_cmd,
        input=out_sql.read_text(encoding="utf-8"),
        text=True,
        check=True,
        stderr=subprocess.DEVNULL,
    )

    print(f"Applied updates from {out_sql}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
