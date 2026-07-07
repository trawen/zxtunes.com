<?php

function rt($off, $count, $fl) {
fseek($fl, $off);
return trim(fread($fl, $count));
}

function word($buf, $ofs)
{return ord($buf[$ofs]) << 8 | ord($buf[$ofs + 1]);}


function getext($name) {
$ext=strtolower(substr($name, strlen($name)-3, 3));
if (substr($ext, 0, 1)==".") {$ext=substr($ext, 1, 2);}
return $ext;
}


function parser($dir_name, $file_name) {
global $ext, $title;

      
		$file=fopen($dir_name, "r");
	    $ext=strtolower(substr($file_name, strlen($file_name)-3, 3));
		if (substr($ext, 0, 1)==".") {$ext=substr($ext, 1, 2);}
	
		$title="";
		$title2="";
		$title3="";
		switch ($ext)
		{
			case 'stp':
				$title = rt(0, 128, $file);
				$p = strpos($title, "KSA SOFTWARE COMPILATION OF ");
				if ($p === false) {$title="";}
				else {$title = rt(38, 25, $file);}
			   	break;
			case 'ftc':
				$title = rt(8, 42, $file);
				break;
			case 'psc':
				$title = rt(25, 20, $file);
				$title2 = rt(49, 20, $file);
				if ($title and $title2) {$title=$title." by ".$title2;}
				elseif ($title2 and !$title) {$title=$title2;}
				break;
		    case 'gtr':
			    $title = rt(7, 32, $file);
			    break;
			case 'pt1':
				$title = rt(69, 30, $file);
				break;
			case 'pt2':
				$title = rt(101, 30, $file);
				break;
			case 'pt3':
			    $title = rt(30, 32, $file);
				$title2 = rt(66, 32, $file);
				if ($title and $title2) {$title=$title." - ".$title2;}
				elseif ($title2 and !$title) {$title=$title2;}
				break;
		    case 'stc':
				$title = rt(7, 18, $file);
				break;
			case 'asc';
			    $title = rt(0, 512, $file);
				$p = strpos($title, "ASM COMPILATION OF ");
				if ($p === false) {$title="";}
				else {$title2=trim(substr($title, $p+19, 20)); $title3=trim(substr($title, $p+43, 20));
				if ($title2 and $title3) {$title=$title2." - ".$title3;}
				elseif ($title2 and !$title3) {$title=$title2;}
				else {$title=$title3;}
				}
			 break;
			case 'vtx';
			    $i=16;
			    fseek($file, $i);
				while ("0" != ord(fread($file, 1))) {fseek($file, $i); $title2.=fread($file, 1); $i++; fseek($file, $i); }
				$i++;
				while ("0" != ord(fread($file, 1))) {fseek($file, $i); $title3.=fread($file, 1); $i++; fseek($file, $i); }
				if ($title2 and $title3) {$title=$title3." - ".$title2;}
				elseif ($title2 and !$title3) {$title=$title2;}
				else {$title=$title3;}
		     break;	
			case 'ay';
			$title = rt(0, 128, $file);
			$s1=word($title,12);
			$s2=18+word($title,18);
			$s3=$s2+word($title,$s2);
			$s4=ord(substr($title, 16, 1));
			$i=$s1+12;
			fseek($file, $i);
			while ("0" != ord(fread($file, 1))) {fseek($file, $i); $title2.=fread($file, 1); $i++; fseek($file, $i); }
			$i=$s3;
			while ("0" != ord(fread($file, 1))) {fseek($file, $i); $title3.=fread($file, 1); $i++; fseek($file, $i); }
		//	if ($title2 and $title3) {$title=$title2." - ".$title3;}
		//	elseif ($title2 and !$title3) {$title=$title2;}
		//	else {$title=$title3;}
		    $title=$title3;
			$s4++;
			if ($s4>1) {$title.=" (".$s4." tunes)";}
		    break;
		 }
			
		 $title=trans($title);
	     $n=strlen($title); 
		 $f=0;
		 if ($ext!="pt3") {for ($i=0; $i<$n; $i++) {$a=ord(substr($title, $i, 1)); if ($a<32 or $a>127) {$f=1;};};}
		 if ($f) {$title="";}
//		 if ($title=="SONG BY ST COMPILE") {$title="";}
		 fclose($file); 
		 return $title;
}


function test($nick) {

$res = mysql_query("SELECT * FROM muzx_authors WHERE nickname LIKE mysql_escape_string($nick) "); 
if (!$res) {echo mysql_error();}
else {$dub=mysql_num_rows($res);}
mysql_free_result($res);
return $dub;
}





function trans ($char) {

$x=strlen($char)+1;
for ($i = 0; $i < $x; $i++) {

$c=substr($char, $i, 1);

if ($c=="à") {$c="a";}
elseif ($c=="á") {$c="b";}
elseif ($c=="â") {$c="v";}
elseif ($c=="ã") {$c="g";}
elseif ($c=="ä") {$c="d";}
elseif ($c=="å") {$c="e";}
elseif ($c=="¸") {$c="yo";}
elseif ($c=="æ") {$c="zh";}
elseif ($c=="ç") {$c="z";}
elseif ($c=="è") {$c="i";}
elseif ($c=="é") {$c="y";}
elseif ($c=="ê") {$c="k";}
elseif ($c=="ë") {$c="l";}
elseif ($c=="ì") {$c="m";}
elseif ($c=="í") {$c="n";}
elseif ($c=="î") {$c="o";}
elseif ($c=="ï") {$c="p";}
elseif ($c=="ð") {$c="r";}
elseif ($c=="ñ") {$c="s";}
elseif ($c=="ò") {$c="t";}
elseif ($c=="ó") {$c="u";}
elseif ($c=="ô") {$c="f";}
elseif ($c=="õ") {$c="kh";}
elseif ($c=="ö") {$c="ts";}
elseif ($c=="÷") {$c="ch";}
elseif ($c=="ø") {$c="sh";}
elseif ($c=="ù") {$c="sh";}
elseif ($c=="ú") {$c="'";}
elseif ($c=="û") {$c="y";}
elseif ($c=="ü") {$c="'";}
elseif ($c=="ý") {$c="e";}
elseif ($c=="þ") {$c="yu";}
elseif ($c=="ÿ") {$c="ya";}

ELSEIF ($c=="À") {$c="A";}
ELSEIF ($c=="Á") {$c="B";}
ELSEIF ($c=="Â") {$c="V";}
ELSEIF ($c=="Ã") {$c="G";}
ELSEIF ($c=="Ä") {$c="D";}
ELSEIF ($c=="Å") {$c="E";}
ELSEIF ($c=="¨") {$c="YO";}
ELSEIF ($c=="Æ") {$c="ZH";}
ELSEIF ($c=="Ç") {$c="Z";}
ELSEIF ($c=="È") {$c="I";}
ELSEIF ($c=="É") {$c="Y";}
ELSEIF ($c=="Ê") {$c="K";}
ELSEIF ($c=="Ë") {$c="L";}
ELSEIF ($c=="Ì") {$c="M";}
ELSEIF ($c=="Í") {$c="N";}
ELSEIF ($c=="Î") {$c="O";}
ELSEIF ($c=="Ï") {$c="P";}
ELSEIF ($c=="Ð") {$c="R";}
ELSEIF ($c=="Ñ") {$c="S";}
ELSEIF ($c=="Ò") {$c="T";}
ELSEIF ($c=="Ó") {$c="U";}
ELSEIF ($c=="Ô") {$c="F";}
ELSEIF ($c=="Õ") {$c="KH";}
ELSEIF ($c=="Ö") {$c="TS";}
ELSEIF ($c=="×") {$c="CH";}
ELSEIF ($c=="Ø") {$c="SH";}
ELSEIF ($c=="Ù") {$c="SH";}
ELSEIF ($c=="Ú") {$c="'";}
ELSEIF ($c=="Û") {$c="Y";}
ELSEIF ($c=="Ü") {$c="'";}
ELSEIF ($c=="Ý") {$c="E";}
ELSEIF ($c=="Þ") {$c="YU";}
ELSEIF ($c=="ß") {$c="YA";}

$char2.=$c;
}
    return $char2;
}






function import($title, $yearz, $file_name, $dir, $author_id) {
global $tm;

$ext=strtolower(substr($file_name, strlen($file_name)-3, 3));
if (substr($ext, 0, 1)==".") {$ext=substr($ext, 1, 2);}
$name=substr($file_name, 0, strlen($file_name)-strlen($ext));
$file_name = $name.$ext;

$title=mysql_escape_string($title);
$file_name=mysql_escape_string(trans($file_name));


mysql_query("INSERT INTO muzx_songs (`id`, `filename`, `name`, `year`, `last_update`) VALUES ('NULL', '$file_name', '$title', '$yearz', '$tm') ");
$id_song = mysql_insert_id();
echo mysql_error();

mysql_query("INSERT INTO muzx_songs_authors (`song_id`, `author_id`) VALUES ('$id_song', '$author_id') ");
echo mysql_error();



$sfm=sprintf("%s/%08X", "tunes/", $id_song);
if (copy($dir, $sfm)) {
//    mysql_query("INSERT INTO log (`id`, `update`, `event`, `event_id`, `type`, `hidden`) VALUES (NULL, '$tm', '8', '$author_id', '$id_song', '$hidden')"); 
   $er="ok"; 
//   if (mysql_error()) {echo mysql_error();}
;}
else {echo "<b>Error of copying file: $sfm<br></b>";} 

return $er;
}


function removeDirRec($dir) {
if ($objs = glob($dir."/*")) {foreach($objs as $obj) {is_dir($obj) ? removeDirRec($obj) : unlink($obj);}}
rmdir($dir);
}




?>