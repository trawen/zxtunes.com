{include file="menu.tpl"}

<script language="javascript">
{if $language eq 'rus'}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Отправить'>";
{else}
var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Submit'>";
{/if}

{literal}

function noSpam() {
	var el = document.getElementById("spam");
	if (el) {
		el.innerHTML = spam;
	}
}

function FixProfileHeight() {
	noSpam();
}

function validateEmpty() {

	var n = validateEmpty.arguments.length;
	var args = validateEmpty.arguments;
	for(var i=0;i<n;i++) {
	
		if(document.getElementById(args[i]).value != 0 ) {
			
			document.getElementById(args[i]).className = document.getElementById(args[i]).className.replace(" error", "");

		}	

		else {

			document.getElementById(args[i]).focus();
			document.getElementById(args[i]).className += " error";
{/literal}			
			{if $language eq 'rus'}
			
				alert("Пожалуйста заполните все поля! (e-mail не публикуется)");
			{else}
				alert("Please complete all fields! (e-mail no published)");
			{/if}
			
{literal}			
			return false;

		}
	}
	return true;
}



</script>
{/literal}

 
<div class="author-page">

<section class="author-profile">
	<div class="author-profile__top">
		<div class="author-profile__info" id="author_info">

			<div class="author-profile__heading">
				<div class="author-heading author-heading--with-thumb">
					<H1{if $author.dead} class="author-heading__name--dead"{/if}><span class="author-heading__nick">{$author.nickname}</span>{if $language eq 'rus'}{if $author.first_name or $author.last_name}<span class="author-heading__real"> ({if $author.first_name and $author.last_name}{$author.first_name} {$author.last_name}{elseif $author.first_name}{$author.first_name}{else}{$author.last_name}{/if})</span>{/if}{else}{if $author.first_name_en or $author.last_name_en}<span class="author-heading__real"> ({if $author.first_name_en and $author.last_name_en}{$author.first_name_en} {$author.last_name_en}{elseif $author.first_name_en}{$author.first_name_en}{else}{$author.last_name_en}{/if})</span>{/if}{/if}</H1>
					{if $author.photo}
					<a class="author-profile__thumb" href="{$author_photo_url}" title="{if $language eq 'rus'}Фото {$author.nickname}{else}{$author.nickname} photo{/if}">
						<img src="/photo/60/{$author.id}.jpg" alt="{$author.nickname|escape}" width="32" height="32">
					</a>
					{/if}
					{if $author.dead}<span class="author-dead">{if $language eq 'rus'}умер {$author.dead}г{else}died {$author.dead}{/if}</span>{/if}
				</div>
				{if $user.login}
				<a href="/author_edit.php?id={$author.id}" class="author-profile__edit dwns">редактировать <img src="/images/edit.ico" alt="" style="vertical-align: middle"></a>
				{/if}
			</div>

			{if $author.also}
			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}другие ники:{else}also known:{/if}</span>
				<span class="au2">{$author.also}</span>
			</p>
			{/if}

			{if $group}
			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}группа:{else}group:{/if}</span>
				<span class="au2">{$group}</span>
			</p>
			{if $others}
			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}согрупники:{else}others members:{/if}</span>
				<span class="au2">{$others}</span>
			</p>
			{/if}
			{/if}

			{if $author.city or $author.city_en or $author.country or $author.country_en}
			<p class="author-field author-field--location">
				<span class="au1">{if $language eq 'rus'}расположение:{else}location:{/if}</span>
				<span class="au2">
				{if $language eq 'rus'}
					{if $author.city and $author.country}{$author.city}, {$author.country}
					{elseif $author.city}{$author.city}
					{elseif $author.country}{$author.country}
					{/if}
				{else}
					{if $author.city_en and $author.country_en}{$author.city_en}, {$author.country_en}
					{elseif $author.city_en}{$author.city_en}
					{elseif $author.country_en}{$author.country_en}
					{/if}
				{/if}
				{if $flag}<img width="16" height="10" class="flag" src="/{$flag}" alt="">{/if}
				</span>
			</p>
			{/if}

			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}специализация:{else}specialization:{/if}</span>
				<span class="au2">{$author.spec}</span>
			</p>

			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}активность:{else}activity:{/if}</span>
				<span class="au2">
					{if $author.years_from and $author.years_to and $author.years_from eq $author.years_to}{$author.years_from}
					{elseif $author.years_from and $author.years_to}{$author.years_from}—{$author.years_to}
					{elseif $author.years_from}{$author.years_from}
					{elseif $author.years_to}{$author.years_to}
					{else}—{/if}
				</span>
			</p>

			{if $author.email or $author.site}
			<p class="author-field">
				<span class="au1">{if $language eq 'rus'}контакты:{else}contacts:{/if}</span>
				<span class="au2">
					{if $author.email}{mailto address=$author.email encode="javascript"}{/if}{if $author.email and $author.site}, {/if}{if $author.site}<noindex><a href="{$author.site_url}" rel="nofollow">{$author.site_label}</a></noindex>{/if}
				</span>
			</p>
			{/if}

			<p class="author-field author-field--archive">
				<span class="au1">{if $language eq 'rus'}архив музыки:{else}music archive:{/if}</span>
				<span class="author-field__body">
					<span class="au2">
						{if $szip}<a class="m" title="{$author.nickname} music" href="/downloads.php?id={$author.id}&md=author">{$author.nickname}.zip</a> ({$szip}Kb){else}—{/if}
					</span>
					{if $szip}<span class="author-field__meta dwns">{if $language eq 'rus'}скачиваний{else}downloads{/if} {$author.downloads}</span>{/if}
				</span>
			</p>
		</div>

		<div class="author-profile__photo">
			<img alt="{$title}" title="{$title}" onload="FixProfileHeight()" id="author_photo" class="photo" src="/{if $author.photo}photo/{$author.id}.jpg{else}css/wanted.png{/if}">
		</div>
	</div>

	<nav class="author-tabs" aria-label="{if $language eq 'rus'}Разделы профиля{else}Profile sections{/if}">
		<a class="author-tabs__item{if $md eq 1} author-tabs__item--active{/if}" href="{$author_url}">
			<span class="author-tabs__label">{if $language eq 'rus'}Музыка{else}Music{/if}</span>
			<span class="author-tabs__count">{$author.num_tracks}</span>
		</a>
		<a class="author-tabs__item{if $md eq 3} author-tabs__item--active{/if}" href="{$author_url}?md=3">
			<span class="author-tabs__label">{if $language eq 'rus'}Интервью{else}Interview{/if}</span>
			{if $intv[0]}<span class="author-tabs__count">{$intv[0]}</span>{/if}
		</a>
		<a class="author-tabs__item{if $md eq 4} author-tabs__item--active{/if}" href="{$author_url}?md=4">
			<span class="author-tabs__label">{if $language eq 'rus'}Гостевая{else}Guestbook{/if}</span>
			{if $gb[0]}<span class="author-tabs__count">{$gb[0]}</span>{/if}
		</a>
	</nav>

	<div class="author-profile__updated dwns">{$last_update}</div>
</section>

<div class="author-content">
























{if $md eq 1}
{include file="flash.tpl"}	
	




	


<br><br>

<div class="playlist_box">
	<strong class="playlist_box__title">{if $language eq "rus"}Плейлист{else}Playlist{/if}</strong>
	<span class="playlist_box__sort">
{if $language eq "rus"}
{if $sort eq "playing"}
		<a class="m" href="{$author_url}?sort=year">по году</a><span class="playlist_box__sep"> / </span><span class="playlist_box__current">по прослушиваниям</span>
{else}
		<span class="playlist_box__current">по году</span><span class="playlist_box__sep"> / </span><a class="m" href="{$author_url}?sort=playing">по прослушиваниям</a>
{/if}
{else}
{if $sort eq "playing"}
		<a class="m" href="{$author_url}?sort=year">by year</a><span class="playlist_box__sep"> / </span><span class="playlist_box__current">by playings</span>
{else}
		<span class="playlist_box__current">by year</span><span class="playlist_box__sep"> / </span><a class="m" href="{$author_url}?sort=playing">by playings</a>
{/if}
{/if}
	</span>
	<span class="playlist_box__count"><b>{$author.num_tracks}</b> {$author.num_tracks_label}</span>
</div>

<br>


<div id="tb" class="zx-playlist">

{section name=n loop=$playlist}

<div class="zx-track-item">
<div class="zx-track-row" id="s{$playlist[n].id}" data-track-id="{$playlist[n].id}">

<div class="zx-track-year">{if $playlist[n].print_year}{if $playlist[n].year}{$playlist[n].year}{else}n/a{/if}{/if}</div>

<div class="zx-track-play">
{if $playlist[n].fym eq 0}
<div id="m{$playlist[n].id}" class="play" onclick="PlayB('{$playlist[n].id}')"></div>
{elseif $playlist[n].fym eq 1}
<div class="fym_wait"></div>
{else}
<div class="fym_none"></div>
{/if}

<div id="n{$playlist[n].id}" style="display: none">{$playlist[n].next_id}</div>
<div id="p{$playlist[n].id}" style="display: none">{$playlist[n].prev_id}</div>
<div id="a{$playlist[n].id}" style="display: none">{$author.id}</div>
</div>

<div class="zx-track-title" id="f{$playlist[n].id}"><a rel="nofollow" class="m" href="/downloads.php?id={$playlist[n].id}" title="{if $language eq 'rus'}Скачать {else}Download {/if} {$playlist[n].filename}">{$playlist[n].filename}</a>{if $playlist[n].name} - {/if}<span>{$playlist[n].name}</span></div>

<div class="zx-track-time" id="t{$playlist[n].id}">{$playlist[n].time}</div>

<div class="zx-track-dl"><img style="opacity: 0.3; vertical-align: bottom" src="/css/plays.png" alt=""> <span id="dw{$playlist[n].id}">{$playlist[n].downloads}</span></div>

<div class="zx-track-format"><img src="/images/type_{if $playlist[n].format eq 0}ay.png" title="AY/YM song"{elseif $playlist[n].format eq 1}bp.png" title="Beeper song"{elseif $playlist[n].format eq 2}ts.png" title="Turbo Sound song"{elseif $playlist[n].format eq 3}dg.png" title="Digital song"{/if} alt=""></div>

</div>

<div class="zx-track-line"></div>
</div>

{/section}

</div>
	  
	  
	  
	  
  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  





{elseif $md eq 3}

{if $intv[0]}

<br>
<H2>
{if $interview.int_title}{$interview.int_title}{else}

{if $language eq 'rus'}Интервью с {else}An interview with {/if}{$author.nickname}{/if}</H2>
<span class="au2">
© {if $interview.int_from_url}<noindex><a href="http://{$interview.int_from_url}" rel="nofollow">{$interview.int_author}</a></noindex>
  {else}{$interview.int_author}{/if}, {$interview.int_year}</span> &#160&#160&#160   
  {if $interview.int_sent}<span class="dd">{if $language eq 'rus'}прислал{else}sent{/if}</span>
  {if $interview.int_sent_url} <noindex><a href="http://{$interview.int_sent_url}" rel="nofollow">{$interview.int_sent}</a></noindex>
  {else} {$interview.int_sent}{/if}
  {/if}

<div align='justify' style="FONT-SIZE: 1.2em; width: 540px">{$interview.int_text}</div>
<br>

	{if $all_interview}
	<b>{if $language eq 'rus'}Также читайте:{else}Also read:{/if}</b> <br>
	<div style="font: normal 14px Verdana">
	
	
	{section name=n loop=$all_interview}

	<p><a href="{$author_url}?md=3&interview={$all_interview[n].int_id}">{$all_interview[n].int_title}</a></p>
	{/section}
	
	
	
	</div>
	{/if}

	
	
	
	
{else}




<br><br><br>

<div style="font: normal 17px Verdana; letter-spacing: 0px" align=center>
{if $language eq 'rus'}
Печально, но у {$author.nickname} всё еще нет интервью.
{else}
It is sad, but {$author.nickname} still no interviews.
{/if}
</div>







{/if}










{elseif $md eq 2}

<br>
<H3>{$author.nickname} 
{if $language eq 'rus'}не имеет альбомов.{else}no albums.{/if}</H3>



{elseif $md eq 4}
<br><br>
<div class="zx-guestbook">

<div class="zx-guestbook__form">

<br><br><br>

<div style="font: bold 13px Verdana;">{if $language eq 'rus'}Что-нибудь cказать{else}Something to say{/if}</div>
<br>

<form method="post" enctype="multipart/form-data" class="zx-form-stack" onsubmit="return validateEmpty('name', 'email', 'message')">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
{if $language eq 'rus'}Ник или имя{else}Nickname{/if}<br> <input style="width: 150px" name="name" type="text" size="16" maxlength="15" id="name">
</p>
  
<p>
E-mail  <br> <input style="width: 150px"  name="email" type="text" size="16" maxlength="100" id="email">
</p>

<p>
{if $language eq 'rus'}Сообщение{else}Message{/if} <br> 
<textarea type="text" name="message" rows="4" style="width: 150px" id="message"></textarea>
</p>
</b>

<div  id="spam"></div>
</form>

</div>

<div class="zx-guestbook__list">

{section name=n loop=$guestbook}
<div>
<div class="zx-guestbook__item-head">
<div>
<b>{$guestbook[n].user_name|h}</b>

{if $guestbook[n].site}<a href="http://{$guestbook[n].site|h}" rel="nofollow"><img border=0 src="/css/links_ico.png"></a>{/if}
</div>
<span class=d>{$guestbook[n].update}</span>
</div>
<div class="zx-guestbook__item-body">{$guestbook[n].message|h}</div>
</div>
{/section}

</div>

</div>



{/if}

</div>

	<div class="author-profile__updated author-profile__updated--footer dwns">
		{if $language eq 'rus'}Страница обновлена: {else}Page updated: {/if}{$last_update}
	</div>
</div>

{if $md eq 1}
<link rel="preload" href="/css/ay_player.css?v=27" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="/css/ay_player.css?v=27"></noscript>
{literal}
<div id="zx_ay_player_wrap" class="zx-ay-player-wrap">
<div class="zx-ay-player-inner">
<div id="player" class="zx-ay-player">
<div class="p_control_left">
<button id="b_play" class="b_control b_play" onclick="togglePlay(); return false;"><span class="icon"></span></button>
</div>
<div class="p_body">
<div class="track_text"><div class="track_name_wrap"><span id="track_name"></span></div><span id="track_time" class="track_time" onclick="toggleTime(); return false;">0:00</span></div>
<div class="timeline" onclick="changeProgress(event); return false;"><div id="track_progress_left" class="timeline0"></div><div id="track_progress_right" class="timeline1"></div></div>
</div>
<div class="p_track_nav">
<button class="b_control b_prev" onclick="PreviousTrack(); return false;"><span class="icon"></span></button>
<button class="b_control b_next" onclick="NextTrack(); return false;"><span class="icon"></span></button>
</div>
<div class="p_control_right">
<button id="b_shuffle" class="b_control b_shuffle" onclick="playShuffle(); return false;"><span class="icon"></span></button>
<button id="b_repeat" class="b_control b_repeat" onclick="playRepeat(); return false;"><span class="icon"></span></button>
</div>
</div>
</div>
</div>
{/literal}

<script type="application/json" id="zxtunes-player-config">{$player_config_json}</script>
<script defer type="text/javascript" src="/css/jquery.js"></script>
<script defer src="/zxtune/wothke/scriptprocessor_player.min.js?v=2"></script>
<script defer src="/zxtune/js/author-player.js?v=22"></script>
<script defer src="/zxtune/wothke/backend_zxtune.js?v=2"></script>
{/if}

{include file="right_strip.tpl"}
{include file="footer.tpl"}
