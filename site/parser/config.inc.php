<?php

define('SONG_SOURCE', '../song-source');
define('SONG_STORAGE', '../songs');
define('NEW_DIR_MODE', 0755);
define('CATEGORY', 'authors/rus');

define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_USER', getenv('DB_USER') ?: 'zxtunes_u');
define('DB_PASS', getenv('DB_PASS') !== false ? getenv('DB_PASS') : '');
define('DB_NAME', getenv('DB_NAME') ?: 'zxtunes_db');
