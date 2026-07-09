#!/usr/bin/env python3
"""Build city coordinates for the authors map from DB + Nominatim."""

from __future__ import annotations

import json
import re
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "site" / "data" / "author_city_coords.json"
CACHE = ROOT / "site" / "data" / "city_geocode_cache.json"

USER_AGENT = "zxtunes.com city-map-builder/1.0 (contact: admin@zxtunes.com)"

# Manual fixes for names that confuse geocoders.
CITY_ALIASES = {
    "st.petersburg": "Saint Petersburg",
    "st petersburg": "Saint Petersburg",
    "kharkov": "Kharkiv",
    "kiev": "Kyiv",
    "dnepropetrovsk": "Dnipro",
    "zaporozhye": "Zaporizhzhia",
    "nizhniy novgorod": "Nizhny Novgorod",
    "ekaterinburg": "Yekaterinburg",
    "velikiy novgorod": "Veliky Novgorod",
    "ufa": "Ufa",
    "odessa": "Odesa",
    "lvov": "Lviv",
    "lugansk": "Luhansk",
    "donetsk": "Donetsk",
    "simferopol": "Simferopol",
    "sevastopol": "Sevastopol",
    "nizhny tagil": "Nizhny Tagil",
    "nizhniy tagil": "Nizhny Tagil",
}

MANUAL_COORDS: dict[str, dict[str, float]] = {
    "korkino, chelyab.obl.|russia": {"lat": 54.8944, "lng": 61.4031},
    "uherský brod|czech": {"lat": 49.0253, "lng": 17.6472},
    "kaplice|czech": {"lat": 48.7386, "lng": 14.4944},
    "novaya kohovka, hers.obl|ukraine": {"lat": 46.7547, "lng": 33.3672},
    "revda, sverd.obl|russia": {"lat": 56.8006, "lng": 59.9089},
    "p.chuchkovo, ryaz.obl.|russia": {"lat": 54.2717, "lng": 41.7817},
    "evpatoria|russia": {"lat": 45.1906, "lng": 33.3678},
    "neftekamensk|russia": {"lat": 56.088, "lng": 54.248},
    "astrahan (yaroslavl)|russia": {"lat": 57.6261, "lng": 39.8845},
    "novoya vodolaga, hark. obl.|russia": {"lat": 49.9869, "lng": 35.8322},
    "kamunary|russia": {"lat": 59.621, "lng": 30.392},
    "moriupyl|russia": {"lat": 47.0971, "lng": 37.5431},
    "gukovo, rost.obl.|russia": {"lat": 48.0622, "lng": 39.935},
    "zdar nad sazavou|czech": {"lat": 49.5625, "lng": 15.9392},
    "todz|poland": {"lat": 51.7592, "lng": 19.456},
    "rožnov pod radhoštěm|czech": {"lat": 49.4584, "lng": 18.1431},
    "chotebor|czech": {"lat": 49.7206, "lng": 15.6703},
    "st helens, merseyside|england": {"lat": 53.4536, "lng": -2.7369},
    "moriupol|ukraine": {"lat": 47.0971, "lng": 37.5431},
    "pyatkaranta|russia": {"lat": 61.5731, "lng": 31.4797},
    "igorievsk|russia": {"lat": 55.3831, "lng": 39.0358},
}

COUNTRY_ALIASES = {
    "россия": "Russia",
    "украина": "Ukraine",
    "беларусь": "Belarus",
    "казахстан": "Kazakhstan",
    "латвия": "Latvia",
    "литва": "Lithuania",
    "эстония": "Estonia",
    "германия": "Germany",
    "сша": "United States",
    "великобритания": "United Kingdom",
    "чехия": "Czech Republic",
    "польша": "Poland",
    "финляндия": "Finland",
    "нидерланды": "Netherlands",
    "израиль": "Israel",
    "австралия": "Australia",
    "канада": "Canada",
    "франция": "France",
    "италия": "Italy",
    "испания": "Spain",
    "швеция": "Sweden",
    "норвегия": "Norway",
    "австрия": "Austria",
    "швейцария": "Switzerland",
    "болгария": "Bulgaria",
    "венгрия": "Hungary",
    "сербия": "Serbia",
    "молдова": "Moldova",
    "грузия": "Georgia",
    "армения": "Armenia",
    "азербайджан": "Azerbaijan",
    "узбекистан": "Uzbekistan",
    "китай": "China",
    "япония": "Japan",
}


def map_key(city_ru: str, city_en: str, country_ru: str, country_en: str) -> str:
    city = (city_en or city_ru or "").strip()
    country = (country_en or country_ru or "").strip()
    return f"{city.lower()}|{country.lower()}"


def normalize_city(name: str) -> str:
    key = re.sub(r"[^\w\s\-'.]", "", name.strip().lower())
    key = re.sub(r"\s+", " ", key)
    return CITY_ALIASES.get(key, name.strip())


def normalize_country(name_ru: str, name_en: str) -> str:
    if name_en and name_en.strip():
        return name_en.strip()
    ru = (name_ru or "").strip().lower()
    return COUNTRY_ALIASES.get(ru, name_ru.strip())


def geocode(query: str, cache: dict[str, dict]) -> dict | None:
    if query in cache:
        return cache[query]

    params = urllib.parse.urlencode(
        {"q": query, "format": "json", "limit": 1, "addressdetails": 0}
    )
    url = f"https://nominatim.openstreetmap.org/search?{params}"
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except Exception as exc:
        print(f"  geocode error for {query!r}: {exc}", file=sys.stderr)
        return None

    time.sleep(1.1)

    if not data:
        cache[query] = None
        return None

    point = {"lat": float(data[0]["lat"]), "lng": float(data[0]["lon"])}
    cache[query] = point
    return point


def fetch_cities_from_db() -> list[dict]:
    cmd = (
        'docker exec zxtunes_php php -r '
        "'require \"/home/zxtunes/web/zxtunes.com/public_html/ini.php\"; "
        "$rows = db_fetch_all("
        "\"SELECT TRIM(city) AS city_ru, TRIM(city_en) AS city_en, "
        "TRIM(country) AS country_ru, TRIM(country_en) AS country_en, COUNT(*) AS cnt "
        "FROM muzx_authors "
        "WHERE TRIM(COALESCE(city, \\\"\\\")) <> \\\"\\\" OR TRIM(COALESCE(city_en, \\\"\\\")) <> \\\"\\\" "
        "GROUP BY city_ru, city_en, country_ru, country_en "
        "ORDER BY cnt DESC\"); "
        "echo json_encode($rows, JSON_UNESCAPED_UNICODE);'"
    )
    import subprocess

    out = subprocess.check_output(cmd, shell=True, text=True)
    return json.loads(out)


def main() -> int:
    cities = fetch_cities_from_db()
    cache: dict = {}
    if CACHE.exists():
        cache = json.loads(CACHE.read_text(encoding="utf-8"))

    points: list[dict] = []
    missing: list[str] = []

    for row in cities:
        city_ru = row.get("city_ru") or ""
        city_en = row.get("city_en") or ""
        country_ru = row.get("country_ru") or ""
        country_en = row.get("country_en") or ""
        cnt = int(row["cnt"])

        city = normalize_city(city_en or city_ru)
        country = normalize_country(country_ru, country_en)
        query = f"{city}, {country}"
        key = map_key(city_ru, city_en, country_ru, country_en)

        if key in MANUAL_COORDS:
            coords = MANUAL_COORDS[key]
        else:
            coords = geocode(query, cache)
            if coords is None and city_en and city_ru and city_en != city_ru:
                coords = geocode(f"{normalize_city(city_ru)}, {country}", cache)

        if coords is None:
            missing.append(query)
            continue

        points.append(
            {
                "key": key,
                "city_ru": city_ru,
                "city_en": city_en,
                "country_ru": country_ru,
                "country_en": country_en,
                "count": cnt,
                "lat": coords["lat"],
                "lng": coords["lng"],
            }
        )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(
        json.dumps({"generated_at": time.strftime("%Y-%m-%d"), "points": points}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    CACHE.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Wrote {len(points)} points to {OUT}")
    if missing:
        print(f"Missing coords for {len(missing)} cities:", file=sys.stderr)
        for name in missing:
            print(f"  - {name}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
