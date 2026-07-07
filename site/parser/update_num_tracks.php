<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"> <html>  <head>  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /> <link rel="stylesheet" type="text/css" href="common.css" /> <title></title>  </head>  <body> <?php  require 'common.inc.php'; require 'parser.inc.php';  
initDB();
 $res = mysql_query('SELECT muzx_authors.id, COUNT(muzx_songs.id), muzx_authors.flags FROM muzx_authors, muzx_songs, muzx_songs_authors WHERE muzx_authors.id = author_id AND muzx_songs.id = song_id GROUP BY muzx_authors.id') or die(mysql_error());
 while($row = mysql_fetch_row($res))      
  $numTracks[$row[0]] = array('num_tracks' => $row[1], 'flags' => $row[2]);
  mysql_free_result($res);
  $n = 0;
if(count($numTracks)<=0){
  mysql_query("UPDATE muzx_authors SET num_tracks = 0");
 } 
 foreach ($numTracks as $id=>$ent) {
    mysql_query(sprintf("UPDATE muzx_authors SET num_tracks = %d, flags = %d WHERE id = %d",$ent['num_tracks'],$ent['flags'] & ~1 | 2,$id))           or die(mysql_error());
  $n++;
  } 
  echo "$n author(s) processed";
 closeDB();   ?> </body>  </html>