<?php

/**
 * Resolve on-disk tune storage and legacy multi-tune aliases (e.g. Kosmos_2.ay -> Kosmos.ay).
 */

function zxtunes_site_root(): string
{
	return dirname(__DIR__);
}

function zxtunes_tune_storage_path(int $id): string
{
	return zxtunes_site_root() . '/tunes/' . sprintf('%08X', $id);
}

/**
 * @return array{base:string,number:int,index:int}|null
 */
function zxtunes_parse_subsong_filename(string $filename): ?array
{
	if (!preg_match('/^(.+)_(\d+)\.([^.]+)$/u', $filename, $m)) {
		return null;
	}

	$number = (int) $m[2];
	if ($number <= 0) {
		return null;
	}

	return [
		'base' => $m[1] . '.' . $m[3],
		'number' => $number,
		// Wothke/spectreZX emu_set_subsong is 0-based; legacy rows use _1, _2, ...
		'index' => $number - 1,
	];
}

/**
 * @return array{source_id:int,path:string,subsong:int,missing?:bool,alias?:bool}
 */
function zxtunes_resolve_tune_source(int $id, string $filename, ?int $author_id = null): array
{
	$path = zxtunes_tune_storage_path($id);
	if (is_file($path)) {
		return [
			'source_id' => $id,
			'path' => $path,
			'subsong' => 0,
		];
	}

	$parsed = zxtunes_parse_subsong_filename($filename);
	if (!$parsed) {
		return [
			'source_id' => $id,
			'path' => $path,
			'subsong' => 0,
			'missing' => true,
		];
	}

	if ($author_id) {
		$parent = db_fetch_one(
			'SELECT s.id FROM muzx_songs s
			 JOIN muzx_songs_authors sa ON sa.song_id = s.id
			 WHERE sa.author_id = ? AND s.filename = ? AND s.hidden != 1
			 LIMIT 1',
			'is',
			[$author_id, $parsed['base']]
		);
	} else {
		$parent = db_fetch_one(
			'SELECT id FROM muzx_songs WHERE filename = ? AND hidden != 1 LIMIT 1',
			's',
			[$parsed['base']]
		);
	}

	if (!$parent) {
		return [
			'source_id' => $id,
			'path' => $path,
			'subsong' => 0,
			'missing' => true,
		];
	}

	$parent_id = (int) $parent['id'];
	$parent_path = zxtunes_tune_storage_path($parent_id);
	if (!is_file($parent_path)) {
		return [
			'source_id' => $id,
			'path' => $path,
			'subsong' => 0,
			'missing' => true,
		];
	}

	return [
		'source_id' => $parent_id,
		'path' => $parent_path,
		'subsong' => $parsed['index'],
		'alias' => true,
	];
}
