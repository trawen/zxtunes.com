<?php

header('Content-Type: text/plain');

rename('../song-source/authors/rus/AAA', '../song-source/authors/AAA')
	or die('failed 1');
rename('../song-source/authors/eur', '../song-source/eur')
	or die('failed 2');
rename('../song-source/authors', '../song-source/rus')
	or die('failed 3');
mkdir('../song-source/authors', 0755)
	or die('failed 4');
rename('../song-source/rus', '../song-source/authors/rus')
	or die('failed 5');
rename('../song-source/eur', '../song-source/authors/eur')
	or die('failed 6');

?>