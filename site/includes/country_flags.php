<?php

function zxtunes_country_flag_code(string $country_en, string $country_ru = ''): string
{
    $key = strtolower(trim($country_en));
    if ($key === '') {
        $key = strtolower(trim($country_ru));
    }

    static $map = [
        'russia' => 'ru',
        'россия' => 'ru',
        'belarus' => 'by',
        'беларусь' => 'by',
        'ukraine' => 'ua',
        'украина' => 'ua',
        'england' => 'en',
        'poland' => 'pl',
        'польша' => 'pl',
        'slovakia' => 'sk',
        'united kingdom' => 'uk',
        'великобритания' => 'uk',
        'czech' => 'cz',
        'чехия' => 'cz',
        'latvia' => 'lv',
        'латвия' => 'lv',
        'lithuania' => 'lt',
        'litva' => 'lt',
        'литва' => 'lt',
        'germany' => 'de',
        'германия' => 'de',
        'spain' => 'sp',
        'испания' => 'sp',
        'kazakhstan' => 'kz',
        'казахстан' => 'kz',
        'finland' => 'fn',
        'финляндия' => 'fn',
        'france' => 'fr',
        'франция' => 'fr',
        'usa' => 'us',
        'сша' => 'us',
        'northern ireland' => 'ne',
        'sweden' => 'se',
        'швеция' => 'se',
        'scotland' => 'sc',
        'estonia' => 'es',
        'эстония' => 'es',
    ];

    return $map[$key] ?? '';
}

function zxtunes_country_flag_url(string $country_en, string $country_ru = ''): ?string
{
    $code = zxtunes_country_flag_code($country_en, $country_ru);
    if ($code === '') {
        return null;
    }

    $path = __DIR__ . '/../images/' . $code . '.png';
    if (!is_readable($path)) {
        return null;
    }

    return '/images/' . $code . '.png';
}
