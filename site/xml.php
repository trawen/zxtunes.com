<?php

require 'ini.php';

error_reporting(true);


$id = intval($_REQUEST['id']);
$author_id = intval($_REQUEST['author_id']);
$scope = $_REQUEST['scope'];
$fields = explode(",",$_REQUEST['fields']);
$science = intval($_REQUEST['science']);

$version = 1;

function q($q) {

	GLOBAL $fields;

	foreach ($fields as $key => $value) {
		if ($q == $value) {return TRUE;}
	}
	
	return FALSE;

}

function add_field($field, $val) {

	GLOBAL $dom, $author;

	$val = trim($val);
	
	if ($val and q($field) ) {
	
		$nickname = $dom->createElement($field);
		$text = $dom->createTextNode($val); //$t['nickname']
		$nickname->appendChild($text);
		$author->appendChild($nickname);
		
	}

}



if (!$scope) {

	$z = mysqli_query($db,"SELECT COUNT(*) FROM muzx_authors");
	$authors = mysqli_fetch_array($z);
	$z = mysqli_query($db,"SELECT COUNT(*) FROM muzx_songs");
	$songs = mysqli_fetch_array($z);
	
	$dom = new DOMDocument('1.0', 'utf-8');

	$root = $dom->createElement('zxtunes');
	$root->setAttribute('version',$version);

	$info = $dom->createElement('info');
	$root->appendChild($info);

	$node = $dom->createElement('minVersion');
	$text = $dom->createTextNode('1');
	$node->appendChild($text);
	$info->appendChild($node);

	$node = $dom->createElement('authors');
	$text = $dom->createTextNode($authors[0]);
	$node->appendChild($text);
	$info->appendChild($node);

	$node = $dom->createElement('tracks');
	$text = $dom->createTextNode($songs[0]);
	$node->appendChild($text);
	$info->appendChild($node);
	
	$dom->appendChild($root);

	echo $dom->saveXML();

}
elseif ($scope == "authors" and $id) {

	$z = mysqli_query($db,"SELECT * FROM muzx_authors WHERE id='$id'");
	$t = mysqli_fetch_array($z);
	$z = mysqli_query($db,"SELECT * FROM group_authors, `groups` WHERE group_authors.author_id='$id' AND `groups`.id = group_authors.group_id"); 
	while ($x = mysqli_fetch_array($z)) {

		if ($f) {$f = $f." OR ";}
		$f = $f."group_authors.group_id='".$x['id']."'";
		if ($g) {$g = $g.", ";}
		$g = $g.$x['name'];

	}
	$t['group_name'] = $g;

	$dom = new DOMDocument('1.0', 'utf-8');

	$zxtunes = $dom->createElement('zxtunes');
	$zxtunes->setAttribute('version',$version);

	$authors = $dom->createElement('authors');
	$zxtunes->appendChild($authors);

	$author = $dom->createElement('author');// создаем элемент, добавляем его и уже потом создаем вложенные другие
	$author->setAttribute('id',$id);
	$authors->appendChild($author);
	
	add_field("nickname", $t['nickname']);
	add_field("name", $t['first_name_en']." ".$t['last_name_en']);
	add_field("group", $t['group_name']);
	add_field("tracks",$t["num_tracks"]);
	add_field("also", $t['also']);
	add_field("spec", $t['spec']);
	add_field("city", $t['city_en']);
	add_field("country", $t['country_en']);
	add_field("activity_from", $t['years_from']);
	add_field("activity_to", $t['years_to']);
	add_field("site", $t['site']);
	add_field("icq", $t['icq']);
	add_field("email", $t['email']);
	add_field("photo", $t['photo']);
	add_field("interview", $t['interview']);
	add_field("views", $t['views']);
	add_field("update", $t['update_date']);
	add_field("dead_date", $t['dead']);
		
	$dom->appendChild($zxtunes);

	echo $dom->saveXML();
}
else if ($scope == "authors") {

	$dom = new DOMDocument('1.0', 'utf-8');

	$zxtunes = $dom->createElement('zxtunes');
	$zxtunes->setAttribute('version',$version);

	$authors = $dom->createElement('authors');
	$zxtunes->appendChild($authors);

	$z = mysqli_query($db,"SELECT * FROM muzx_authors" );
	while ($t = mysqli_fetch_array($z)) {
		
		$author = $dom->createElement('author');
		$author->setAttribute('id',$t['id']);
		$authors->appendChild($author);
		
		add_field("nickname", $t['nickname']);
		add_field("name", $t['first_name_en']." ".$t['last_name_en']);
		add_field("group", $t['group_name']);
		add_field("tracks",$t["num_tracks"]);
		add_field("also", $t['also']);
		add_field("spec", $t['spec']);
		add_field("city", $t['city_en']);
		add_field("country", $t['country_en']);
		add_field("activity_from", $t['years_from']);
		add_field("activity_to", $t['years_to']);
		add_field("site", $t['site']);
		add_field("icq", $t['icq']);
		add_field("email", $t['email']);
		add_field("photo", $t['photo']);
		add_field("interview", $t['interview']);
		add_field("views", $t['views']);
		add_field("update", $t['update_date']);
		add_field("dead_date", $t['dead']);
		//get("so_members", $so);
		
					
	}
	
	$dom->appendChild($zxtunes);

	echo $dom->saveXML();

}
else if ($scope == "tracks" and $author_id) {

	$dom = new DOMDocument('1.0', 'utf-8');

	$zxtunes = $dom->createElement('zxtunes');
	$zxtunes->setAttribute('version', $version);

	$authors = $dom->createElement('tracks');
	$zxtunes->appendChild($authors);
	
	if ($science) {$science = "AND last_update>'$science'";}

	$z = mysqli_query($db,"SELECT * FROM muzx_songs_authors, muzx_songs WHERE author_id='$author_id' AND id=song_id" );
	while ($t = mysqli_fetch_array($z)) {
	
		$author = $dom->createElement('track');// создаем элемент, добавляем его и уже потом создаем вложенные другие
		$author->setAttribute('id',$t['id']);
		$authors->appendChild($author);
	
		add_field("filename", $t["filename"]);	
		add_field("date", $t["year"]);
		add_field("title", $t["name"]);
		add_field("downloads", $t["downloads"]);
		add_field("update", $t["last_update"]);
		add_field("duration", $t["time"]);
		add_field("type", $t["type"]);
		
	}

	$dom->appendChild($zxtunes);

	echo $dom->saveXML();
	
}
else if ($scope = "tracks" and $id) {

	$dom = new DOMDocument('1.0', 'utf-8');

	$zxtunes = $dom->createElement('zxtunes');
	$zxtunes->setAttribute('version', $version);

	$authors = $dom->createElement('tracks');
	$zxtunes->appendChild($authors);
	
	if ($science) {$science = "AND last_update>'$science'";}

	$z = mysqli_query($db,"SELECT * FROM muzx_songs WHERE id='$id'" );
	$t = mysqli_fetch_array($z);

	$author = $dom->createElement('track');// создаем элемент, добавляем его и уже потом создаем вложенные другие
	$author->setAttribute('id',$t['id']);
	$authors->appendChild($author);
	
		add_field("filename", $t["filename"]);	
		add_field("date", $t["year"]);
		add_field("title", $t["name"]);
		add_field("downloads", $t["downloads"]);
		add_field("update", $t["last_update"]);
		add_field("duration", $t["time"]);
		add_field("type", $t["type"]);
		
	

	$dom->appendChild($zxtunes);

	echo $dom->saveXML();

}
else if ($scope == "tracks" and $science) {

	$au = q("author");
	
	$dom = new DOMDocument('1.0', 'utf-8');

	$zxtunes = $dom->createElement('zxtunes');
	$zxtunes->setAttribute('version', $version);

	$authors = $dom->createElement('tracks');
	$zxtunes->appendChild($authors);
	
	$z = mysqli_query($db,"SELECT * FROM muzx_songs WHERE last_update>'$science'" );
	while ($t = mysqli_fetch_array($z)) {
	
		$author = $dom->createElement('track');// создаем элемент, добавляем его и уже потом создаем вложенные другие
		$author->setAttribute('id',$t['id']);
		$authors->appendChild($author);
	
		add_field("filename", $t["filename"]);	
		add_field("date", $t["year"]);
		add_field("title", $t["name"]);
		add_field("downloads", $t["downloads"]);
		add_field("update", $t["last_update"]);
		add_field("duration", $t["time"]);
		add_field("type", $t["type"]);
		
		if ($au) {
		
			$x = mysqli_query($db,"SELECT * FROM muzx_songs_authors WHERE song_id='".$t['id']."'" );
			while ($s = mysqli_fetch_array($x)) {
		
				$nickname = $dom->createElement("author");
				$text = $dom->createTextNode($s['author_id']); //$t['nickname']
				$nickname->appendChild($text);
				$author->appendChild($nickname);
		
			}	
		}
			
	}

	echo mysql_error();
	$dom->appendChild($zxtunes);

	echo $dom->saveXML();
	
}

?>