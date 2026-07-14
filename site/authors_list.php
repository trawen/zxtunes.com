<?php
require 'ini.php';





$nml = 50;
//$smarty->debugging = true;

$order=$_REQUEST['order'];
$letter=$_REQUEST['letter'];
$up=$_REQUEST['up'];
$fr=$_REQUEST['fr'];
$lm=$_REQUEST['lm'];
$sr=$_REQUEST['sr'];
$search=$_REQUEST['search'];
$srtype=$_REQUEST['srtype'];
$srtext=strtolower($_REQUEST['srtext']);


if (!$order) {$order="nickname";}
if (!$up) {$up="ASC";}
if (!$letter) {$letter="ALL";}
if (!$fr) {$fr=1;}
if (!$lm or $lm < $nml) {$lm = $nml;}
$order = zxtunes_whitelist($order, [
    'nickname', 'first_name', 'last_name', 'group_name',
    'num_tracks', 'years_from', 'city', 'country',
], 'nickname');
$up = zxtunes_sort_dir((string) $up);
if ($letter !== 'ALL' && $letter !== '123' && !preg_match('/^[A-Za-zА-Яа-яЁё]$/u', (string) $letter)) {$letter = 'ALL';}
$fr = max(1, (int) $fr);
$lm = max($nml, (int) $lm);
if ($order=="num_tracks" or $order=="years_from") {$letter="ALL";}
if (!$mask) {$mask=2;}
if ($sr) {$letter="ALL";}


function geturl($i){
  global $id,$fr,$lm,$up,$order,$letter,$sr;
  $a="/authors_list.php?";
  if ($fr and $fr!=1) {$a.="&fr=".$fr;}
  if ($lm and $lm!=$nml) {$a.="&lm=".$lm;}
  if ($up and $up!='ASC') {$a.="&up=".$up;}
  if ($sr) {$a.="&sr=".$sr;}
  if ($letter and $letter!="ALL") {$a.="&letter=".$letter;}
  if ($order and $order!="nickname") {$a.="&order=".$order;}
  return $a;
}


$fr2=($fr-1)*$nml;



$mode[$md]="class=selected";
$smarty->assign('mode',$mode);
$smarty->assign('sel_link',"/authors_list.php?fr=".$fr."&lm=".$lm."&up=".$up."&ord=".$ord);



$lang = '';
if ($_SESSION['language']=="rus") {


$smarty->assign('mmenu',
    array('news' => 'новости',
          'soft' => 'софт',
          'hard' => 'железо',
		  'articles' => 'статьи',
          'stats' => 'статистика',
          'forum' => 'форум',
          'music' => 'музыка',
          'authors' => 'авторская',
		  'games' => 'игровая',
          'demos' => 'демошная',
          'press' => 'из прессы',
          'party' => 'с патей',
          'remixes' => 'ремиксы'
		  )
         );

$tb[0]="ник";
$tb[1]="группа";
$tb[2]="страна";
$tb[3]="город";
$tb[4]="активность ";
$tb[5]="треки";
$tb[6]="интервью";
$tb[7]="фото";
$tb[8]="контакты";
$tb[9]="просмотры";

$au['nickname']="никам";
$au['first_name']="именам";
$au['last_name']="фамилиям";
$au['group_name']="группам";
$au['num_tracks']="количеству треков";
$au['years_from']="годам активности";
$au['city']="городам";
$au['country']="странам";
$au['interview']="интервью";
$au['photo']="фото";
$au['contact']="контактами";
$au['views']="количеству просмотров";

$smarty->assign('au', "Музыканты");
$smarty->assign('per', "по");
if ($order=="interview" or $order=="photo" or $order=="contact" ) {$smarty->assign('per', "с");}

$smarty->assign('kl1', "показано");
$smarty->assign('kl3', "из");
$all="ВСЕ";

$smarty->assign('title', "Музыканты по ".$au[$order]);
}
else {

$lang="_en";
$smarty->assign('mmenu',
    array('news' => 'news',
          'soft' => 'software',
          'hard' => 'hardware',
		  'articles' => 'articles',
          'stats' => 'statistics',
          'forum' => 'forum',
          'music' => 'music',
          'authors' => 'authors',
		  'games' => 'games',
          'demos' => 'demos',
          'press' => 'press',
          'party' => 'parties',
          'remixes' => 'remixes'
		  )
         );
		 
$tb[0]="nickname";
$tb[1]="group";
$tb[2]="country";
$tb[3]="city";
$tb[4]="activity";
$tb[5]="tunes";
$tb[6]="interview";
$tb[7]="photo";
$tb[8]="contacts";
$tb[9]="views";

$au['nickname']="nicknames";
$au['first_name']="first names";
$au['last_name']="last names";
$au['group_name']="groups";
$au['num_tracks']="tunes";
$au['years_from']="activities";
$au['city']="cities";
$au['country']="countries";
$au['interview']="inteviews";
$au['photo']="photos";
$au['contact']="contacts";
$au['views']="views";
		 
$smarty->assign('au', "Musicians");
$smarty->assign('per', "by");

$smarty->assign('kl1', "musicians");
$smarty->assign('kl3', "from");
$all="ALL";

$smarty->assign('title', "Musicians by ".$au[$order]);
}
		 
$smarty->assign('srt', $au[$order]);

		 
$smarty->assign('active', array('authors' => 'class=active'));
		 
$smarty->compile_check = true;






// if ($search=="search" and strlen($srtext)>=2 and strlen($srtext)<20) {

	 // $v = mysqli_query($db,"SELECT * FROM muzx_authors WHERE nickname LIKE '%$srtext%' OR also1 LIKE '%$srtext%' OR also2 LIKE '%$srtext%' OR also3 LIKE '%$srtext%' OR also4 LIKE '%$srtext%' OR also5 LIKE '%$srtext%'" );
	 
// if (!$v) {echo mysql_error();}
// else { $klp=0; $n=0;
// while ($src = mysqli_fetch_array($v)) {
// $srsr[0]=$src['id'];
// if ($srtext==strtolower($src['nickname']) or $srtext==strtolower($src['also1']) or $srtext==strtolower($src['also2']) or $srtext==strtolower($src['also3']) or $srtext==strtolower($src['also4']) or $srtext==strtolower($src['also5'])) {$klp++; $idsr=$src['id'];}
// }
// }
// if ($klp==1) {   header("Location: http://".$_SERVER['SERVER_NAME']."/author_profile.php?id=".$idsr."?ln=".$ln);
// exit;	


// } 


// }








$ord = zxtunes_author_list_order($order, $lang);

if ($order === 'group_name') {
    $zapros0 = mysqli_query($db, 'SELECT DISTINCT UPPER(LEFT(g.name, 1)) AS letter FROM group_authors ga JOIN `groups` g ON g.id = ga.group_id ORDER BY letter');
} else {
    $zapros0 = mysqli_query($db, "SELECT DISTINCT LEFT($ord, 1) AS letter FROM muzx_authors ORDER BY letter");
}
if (!$zapros0) {echo mysql_error();}
else { $n=0; $l=0;


$alfavit="<div class='authors-page__alpha-nav' id='Navigator2'>";

if ($letter=="ALL" and !$sr) {$alfavit.= "<span class='Page'>$all</span> ";}
else {$alfavit.= "<a class='Page' href='?order=".$order."&letter=ALL'>$all</a> ";}

while ($alf = mysqli_fetch_array($zapros0)) {
if ($alf[0]<="9" and !$n) {if ($letter=="123" and !$sr) {$alfavit.= "<span class='Page'>0..9</span> "; $n++;}
	elseif ($alf[0]<="9") {$alfavit.= "<a class='Page' href='?letter=123&order=".$order."'>0..9</a> "; $n++;}}

elseif ($alf[0]>"9") {if ($alf[0]>"Z" and !$l) 
{$alfavit.= "<span class='authors-page__alpha-break' aria-hidden='true'></span>"; $l++;}

if ($letter=="$alf[0]" and !$sr) {$alfavit.= "<span class='Page'>".$alf[0]."</span>";}
else {$alfavit.= "<a class='Page' href='?letter=".$alf[0]."&order=".$order."'>".$alf[0]."</a>";}}
}
}

$smarty->assign('alfavit', $alfavit."</div>");





$zapros2 = mysqli_query($db,"SELECT * FROM muzx_authors ");
if (!$zapros2) {echo mysql_error();}
else {$kl2 = mysqli_num_rows($zapros2);}
mysqli_free_result($zapros2);



if ($order === 'group_name') {
    $group_clause = zxtunes_authors_group_exists_clause($letter, $sr ?: null, $db);
    $like = $group_clause ? 'WHERE ' . $group_clause : '';
    $from_table = 'muzx_authors a';
    $order_by = zxtunes_authors_group_order_sql($up);
} elseif (!$sr and $letter=="ALL" or $order=="years_from" or $order=="num_tracks") {$like=""; $from_table = 'muzx_authors'; $order_by = "$ord $up";}
elseif ($letter=="123") {$like="WHERE ".$order." REGEXP '^[0-9]'"; $from_table = 'muzx_authors'; $order_by = "$ord $up";}
elseif (!$sr) {
	$letter_esc = mysqli_real_escape_string($db, $letter);
	$like="WHERE ".$ord." LIKE '".$letter_esc."%'"; $from_table = 'muzx_authors'; $order_by = "$ord $up";
}
else {
	$sr_esc = mysqli_real_escape_string($db, $sr);
	$like="WHERE ".$ord." LIKE '".$sr_esc."'";
	$ord.=", nickname";
	$from_table = 'muzx_authors';
	$order_by = "$ord $up";
}




$zapros = mysqli_query($db,"SELECT * FROM $from_table $like ORDER BY $order_by ");
if (!$zapros) {echo mysql_error();}
else { $kl = mysqli_num_rows($zapros);  mysqli_free_result($zapros);}

$zapros = mysqli_query($db,"SELECT * FROM $from_table $like ORDER BY $order_by LIMIT $fr2, $lm ");
if (!$zapros) {echo mysql_error();}
else { $kl5 = mysqli_num_rows($zapros);  mysqli_free_result($zapros);}

$zapros = mysqli_query($db,"SELECT * FROM muzx_authors");
if (!$zapros) {echo mysql_error();}
else { $kl6 = mysqli_num_rows($zapros);  mysqli_free_result($zapros);}

$kl2=Ceil($kl/40);

function authors_list_page_href(int $page): string
{
    global $id, $order, $up, $letter, $sr;

    return '?id=' . $id . '&lm=40&fr=' . $page . '&order=' . $order . '&up=' . $up . '&letter=' . $letter . '&sr=' . $sr;
}

for ($i = 1; $i <= $kl2; $i++) {
	if ($fr==$i and $lm == $nml) {$pages.= "<span class='Page'>".$i."</span>";
	} else {$pages.= "<a class='Page' href='?id=".$id."&lm=40&fr=".$i."&order=".$order."&up=".$up."&letter=".$letter."&sr=".$sr."'>".$i."</a>";}
}
if ($lm > $nml) {$pages.= " <span class='Page'>$all</span>";} else {$pages.= "<a class='Page'href='?id=".$id."&lm=".$kl."&fr=1&order=".$order."&up=".$up."&letter=".$letter."&sr=".$sr."'>$all</a>";}

$totalPages = (int) $kl2;
$currentPage = (int) $fr;
$windowSize = 7;
$pagesMobile = '';

if ($lm > $nml) {
    for ($i = 1; $i <= $kl2; $i++) {
        $pagesMobile .= "<a class='Page' href='" . authors_list_page_href($i) . "'>" . $i . "</a> ";
    }
    $pagesMobile .= "<span class='Page'>$all</span>";
} elseif ($totalPages <= 1) {
    $pagesMobile = "<span class='Page'>1</span>";
} else {
    $prevLabel = $_SESSION['language'] === 'rus' ? 'Предыдущая страница' : 'Previous page';
    $nextLabel = $_SESSION['language'] === 'rus' ? 'Следующая страница' : 'Next page';

    if ($currentPage > 1) {
        $pagesMobile .= "<a class='Page authors-toolbar__arrow' href='" . authors_list_page_href($currentPage - 1) . "' aria-label='" . $prevLabel . "'>&larr;</a> ";
    }

    if ($totalPages <= $windowSize) {
        $start = 1;
        $end = $totalPages;
    } else {
        $start = max(1, $currentPage - (int) floor($windowSize / 2));
        $end = $start + $windowSize - 1;
        if ($end > $totalPages) {
            $end = $totalPages;
            $start = $end - $windowSize + 1;
        }
    }

    for ($i = $start; $i <= $end; $i++) {
        if ($currentPage === $i && $lm == $nml) {
            $pagesMobile .= "<span class='Page'>" . $i . "</span> ";
        } else {
            $pagesMobile .= "<a class='Page' href='" . authors_list_page_href($i) . "'>" . $i . "</a> ";
        }
    }

    if ($currentPage < $totalPages) {
        $pagesMobile .= "<a class='Page authors-toolbar__arrow' href='" . authors_list_page_href($currentPage + 1) . "' aria-label='" . $nextLabel . "'>&rarr;</a>";
    } else {
        $pagesMobile .= "<span class='Page authors-toolbar__arrow authors-toolbar__arrow--disabled' aria-hidden='true'>&rarr;</span>";
    }

    $pagesMobile .= " <a class='Page' href='?id=" . $id . "&lm=" . $kl . "&fr=1&order=" . $order . "&up=" . $up . "&letter=" . $letter . "&sr=" . $sr . "'>$all</a>";
}

//echo "&nbsp&nbsp&nbsp&nbsp(".$kl5."/".$kl."/".$kl6.")<br><br>";

$smarty->assign('kl2', $kl5);
$smarty->assign('kl4', $kl);
$smarty->assign('pages', $pages);
$smarty->assign('pages_mobile', $pagesMobile);





$zapros = mysqli_query($db,"SELECT * FROM $from_table $like ORDER BY $order_by LIMIT $fr2, $lm");



$tb_title[0]['link']="<a class='mb' href='?letter=".$letter."&order=nickname&lm=".$lm."&fr=1&up=";
if ($order=="nickname" and $up=="ASC") {$tb_title[0]['link'].= "DESC'>$tb[0]</a> <b>&#62</b>";} elseif ($order=="nickname" and $up=="DESC") {$tb_title[0]['link'].= "ASC'>$tb[0]</a> <b>&#60</b>";} else {$tb_title[0]['link'].= "ASC'>$tb[0]</a>";}


$tb_title[1]['link']= '';
if ($order=="group_name" and $up=="ASC" and !$sr) {$tb_title[1]['link']= "<a class='mb' href='?letter=".$letter."&order=group_name&lm=".$lm."&fr=1&up=DESC'>$tb[1]</a> <b>&#62</b>";} 
elseif ($order=="group_name" and $up=="DESC" and !$sr) {$tb_title[1]['link']= "<a class='mb' href='?letter=".$letter."&order=group_name&lm=".$lm."&fr=1&up=ASC'>$tb[1]</a> <b>&#60</b>";} 
elseif ($order=="group_name" and $sr) {$tb_title[1]['link']= "<b>$tb[1]</b>: ".$sr." ";} 
else {$tb_title[1]['link']= "<a class='mb' href='?letter=".$letter."&order=group_name&lm=".$lm."&fr=1&up=ASC'>$tb[1]</a>";}


if ($order=="country" and $up=="ASC" and !$sr) {$tb_title[2]['link']= "<a class='mb' href='?letter=".$letter."&order=country&lm=".$lm."&fr=1&up=DESC'>$tb[2]</a> <b>&#62</b>";} 
elseif ($order=="country" and $up=="DESC" and !$sr) {$tb_title[2]['link']= "<a class='mb' href='?letter=".$letter."&order=country&lm=".$lm."&fr=1&up=ASC'>$tb[2]</a> <b>&#60</b>";} 
elseif ($order=="country" and $sr) {$tb_title[2]['link']= "<b>$tb[2]</b>: ".$sr." ";} 
else {$tb_title[2]['link']= "<a class='mb' href='?letter=".$letter."&order=country&lm=".$lm."&fr=1&up=ASC'>$tb[2]</a>";}


if ($order=="city" and $up=="ASC" and !$sr) {$tb_title[3]['link']= "<a class='mb' href='?letter=".$letter."&order=city&lm=".$lm."&fr=1&up=DESC'>$tb[3]</a> <b>&#62</b>";} 
elseif ($order=="city" and $up=="DESC" and !$sr) {$tb_title[3]['link']= "<a class='mb' href='?letter=".$letter."&order=city&lm=".$lm."&fr=1&up=ASC'>$tb[3]</a> <b>&#60</b>";} 
elseif ($order=="city" and $sr) {$tb_title[3]['link']= "<b>$tb[3]</b>: ".$sr." ";} 
else {$tb_title[3]['link']= "<a class='mb' href='?letter=".$letter."&order=city&lm=".$lm."&fr=1&up=ASC'>$tb[3]</a>";}


$tb_title[4]['link']= "<a class='mb' href='?letter=".$letter."&order=years_from&lm=".$lm."&fr=1&up=";
if ($order=="years_from" and $up=="ASC") {$tb_title[4]['link'].= "DESC'>$tb[4]</a> <b>&#62</b>";} elseif ($order=="years_from" and $up=="DESC") {$tb_title[4]['link'].= "ASC'>$tb[4]</a> <b>&#60</b>";} else {$tb_title[4]['link'].= "ASC'>$tb[4]</a>";}


$tb_title[5]['link']= "<a class='mb' href='?letter=".$letter."&order=num_tracks&lm=".$lm."&fr=1&up=";
if ($order=="num_tracks" and $up=="ASC") {$tb_title[5]['link'].= "DESC'>$tb[5]</a> <b>&#62</b>";} elseif ($order=="num_tracks" and $up=="DESC") {$tb_title[5]['link'].= "ASC'>$tb[5]</a> <b>&#60</b>";} else {$tb_title[5]['link'].= "ASC'>$tb[5]</a>";}


if ($order=="interview" and $up=="ASC" and !$sr) {$tb_title[6]['link']= "<a class='mb' href='?order=interview&lm=".$lm."&fr=1&up=DESC'>$tb[6]</a> <b>&#62</b>";} 
elseif ($order=="interview" and $up=="DESC" and !$sr) {$tb_title[6]['link']= "<a class='mb' href='?order=interview&lm=".$lm."&fr=1&up=ASC'>$tb[6]</a> <b>&#60</b>";} 
elseif ($order=="interview" and $sr) {$tb_title[6]['link']= "<b>$tb[6]</b>: ".$sr." ";} 
else {$tb_title[6]['link']="<a class='mb' href='?order=interview&lm=".$lm."&fr=1&up=DESC'>$tb[6]</a>";}


if ($order=="photo" and $up=="ASC" and !$sr) {$tb_title[7]['link']= "<a class='mb' href='?order=photo&lm=".$lm."&fr=1&up=DESC'>$tb[7]</a> <b>&#62</b>";} 
elseif ($order=="photo" and $up=="DESC" and !$sr) {$tb_title[7]['link']= "<a class='mb' href='?order=photo&lm=".$lm."&fr=1&up=ASC'>$tb[7]</a> <b>&#60</b>";} 
elseif ($order=="photo" and $sr) {$tb_title[7]['link']= "<b>$tb[7]</b>: ".$sr." ";} 
else {$tb_title[7]['link']= "<a class='mb' href='?order=photo&lm=".$lm."&fr=1&up=DESC'>$tb[7]</a>";}


if ($order=="contact" and $up=="ASC" and !$sr) {$tb_title[8]['link']= "<a class='mb' href='?order=contact&lm=".$lm."&fr=1&up=DESC'>$tb[8]</a> <b>&#62</b>";} 
elseif ($order=="contact" and $up=="DESC" and !$sr) {$tb_title[8]['link']= "<a class='mb' href='?order=contact&lm=".$lm."&fr=1&up=ASC'>$tb[8]</a> <b>&#60</b>";} 
elseif ($order=="contact" and $sr) {$tb_title[8]['link']= "<b>$tb[8]</b>: ".$sr." ";} 
else {$tb_title[8]['link']= "<a class='mb' href='?order=contact&lm=".$lm."&fr=1&up=DESC'>$tb[8]</a>";}


if ($order=="views" and $up=="ASC" and !$sr) {$tb_title[9]['link']= "<a class='mb' href='?order=views&lm=".$lm."&fr=1&up=DESC'>$tb[9]</a> <b>&#62</b>";} 
elseif ($order=="views" and $up=="DESC" and !$sr) {$tb_title[9]['link']= "<a class='mb' href='?order=views&lm=".$lm."&fr=1&up=ASC'>$tb[9]</a> <b>&#60</b>";} 
elseif ($order=="views" and $sr) {$tb_title[9]['link']= "<b>$tb[9]</b>: ".$sr." ";} 
else {$tb_title[9]['link']= "<a class='mb' href='?order=views&lm=".$lm."&fr=1&up=DESC'>$tb[9]</a>";}

$smarty->assign('tb_title', $tb_title);





if (!$zapros)
	echo mysql_error();
else
{   $n=0;
	$rows = [];
	while ($row1 = mysqli_fetch_array($zapros)) {
		$rows[] = $row1;
	}
	$groups_map = zxtunes_author_groups_for_ids(array_column($rows, 'id'));

	foreach ($rows as $row1)
	{
	    
		$y=$row1['years_from']."-".$row1['years_to'];
		if (!$row1['years_to'] and $row1['years_from']) {$y=$row1['years_from'];}
		elseif ($row1['years_from']==$row1['years_to'] and $row1['years_from']) {$y=$row1['years_from'];}
		elseif (!$row1['years_from']) {$y="—";}
		
		for ($i = 0; $i < 9; $i++) {
		if (!$row1[$i]) {$row1[$i]="—";}
		}
		if (!$row1['num_tracks']) {$row1['num_tracks']="0";}

		$first_name = trim((string) ($row1['first_name' . $lang] ?? ''));
		$last_name = trim((string) ($row1['last_name' . $lang] ?? ''));
		$real_name = trim($first_name . ($first_name && $last_name ? ' ' : '') . $last_name);

		
		$gr='';
		$author_groups = $groups_map[(int) $row1['id']] ?? [];
		foreach ($author_groups as $group_row) {
			$name = $group_row['name'];
			$label = h($name);
			if ($group_row['status'] & 2) {
				$label = '<del>' . $label . '</del>';
			}
			if ($sr and $order=="group_name") {
				$gr .= ($gr ? ', ' : '') . $label;
			} else {
				$gr .= ($gr ? ', ' : '') . "<a class='mm' href='?letter=".$letter."&order=group_name&up=ASC&sr=".rawurlencode($name)."'>".$label."</a>";
			}
		}
		$ct=$row1['city'.$lang];
	
	   
	
	
		$nick = "<a class='m' href='".h(zxtunes_author_url($row1))."'>".h($row1['nickname'])."</a>";
		if ($real_name !== '') {
			$nick .= ' <span class="authors-nick__real">(' . h($real_name) . ')</span>';
		}
		$tbtx[$n][1]= $gr ?: '—';
		if ($gr !== '' && $gr !== '—') {
			$nick .= '<span class="authors-nick__groups">^ ' . $gr . '</span>';
		}
		$tbtx[$n][0] = $nick;

		if ($sr and $order=="country") {$tbtx[$n][2]= $row1['country'.$lang];} 
		else {if ($row1['country'.$lang]) {$tbtx[$n][2]= "<a class='mm' href='?letter=".$letter."&order=country&up=ASC&sr=".$row1['country'.$lang]."'>".$row1['country'.$lang]."</a>";}
		     else {$tbtx[$n][2]="—";}
		}

		if ($sr and $order=="city") {$tbtx[$n][3]= $ct;} 
		else {if ($row1['city'.$lang]) {$tbtx[$n][3]= "<a class='mm' href='?letter=".$letter."&order=city&up=ASC&sr=".$row1['city'.$lang]."'>".$ct."</a>";}
		     else {$tbtx[$n][3]="—";}
		}

		$tbtx[$n][4]= $y;
		$tbtx[$n][5]= $row1['num_tracks'];
		
		if ($row1['interview']) {$tbtx[$n][6]="+";} else {$tbtx[$n][6]="-";};
		if ($row1['photo']) {$tbtx[$n][7]="+";} else {$tbtx[$n][7]="-";};
		if ($row1['contact']) {$tbtx[$n][8]="+";} else {$tbtx[$n][8]="-";};
		$tbtx[$n][9]= number_format((int) $row1['views'], 0, '', ' ');

	$n++;	
	}

mysqli_free_result($zapros);
$smarty->assign('tbtx', $tbtx);
}


include "right_strip.php";  


$smarty->assign('body_class', 'page-authors-list');

$smarty->display('authors_list.tpl');
