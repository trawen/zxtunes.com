{include file="menu.tpl"}
<script type="text/javascript" src="css/jquery.js"></script>
<script type="text/javascript" src="/js/swfobject.js"></script>
<script type="text/javascript" src="css/player6.js"></script> 
<script language="javascript">
var autoplay = "{$autoplay}";
var author_name = "{$search[0].nickname}";
var first_track = "{$search[0].id}";
</script>

{if $language eq 'rus'}
<h2>Популярные ZX Spectrum AY/YM треки по мнению посетителей zxtunes.com</h2>
{else}
<h2> Popular ZX Spectrum AY/YM tunes according to visitors zxtunes.com </h2>
{/if}

{include file="flash.tpl"}


<div class="zx-pager-bar">
<div id='Navigator2'><span style="FONT-SIZE: 12px;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> 

{section name=n loop=$pages}
{if $pages[n] eq $page}<span class="Page">{$pages[n]}</span>
{else}
<a class='Page' href="last_rated.php?page={$pages[n]}">{$pages[n]}</a>
{/if}
{/section}

</div>

<form method="post">

<select name='sort' style="font: normal 11px Arial">

{if $language eq 'rus'}
<option value='1' {if $sort eq 1}selected{/if}>по дате оценки</option>
<option value='2' {if $sort eq 2}selected{/if}>по музыкантам</option>
<option value='3' {if $sort eq 3}selected{/if}>по рейтингу</option>
<option value='4' {if $sort eq 4}selected{/if}>случайно</option>
{else}
<option value='1' {if $sort eq 1}selected{/if}>per last rated</option>
<option value='2' {if $sort eq 2}selected{/if}>per musicians</option>
<option value='3' {if $sort eq 3}selected{/if}>per rating</option>
<option value='4' {if $sort eq 4}selected{/if}>random</option>
{/if}

</select>

<input name="page" value="{$page}" type="hidden">
<input name="ok" value="ok" type="submit">
</form>

<div class="zx-pager-bar__count"><span class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$nm1} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$nm2}</div>
</div>


<div class="zx-track-list">
<div class="zx-track-list__head">
<div></div>
{if $language eq 'rus'}
<div><b> Музыкант </b></div>
<div><b>Имя файла</b></div>
<div class="zx-track-list__cell--title"><b>Название трека</b></div>
<div><b> &nbsp; Рейтинг</b></div>
<div><b> &nbsp; Комм.</b></div>
{else}
<div><b> Musician </b></div>
<div><b>File name</b></div>
<div class="zx-track-list__cell--title"><b>Title</b></div>
<div><b> &nbsp; Rating</b></div>
<div><b> &nbsp; Comm.</b></div>
{/if}
</div>

{section name=n loop=$search}

<div class="zx-track-list__row" id="s{$search[n].id}">

<div>
<div id="m{$search[n].id}" class="play" onclick="PlayB('{$search[n].id}')"></div>
<div id="n{$search[n].id}" style="display: none">{$search[n].next_id}</div>
<div id="p{$search[n].id}" style="display: none">{$search[n].prev_id}</div>
<div id="a{$search[n].id}" style="display: none">{$search[n].id_author}</div>
</div>

<div style="padding-right: 8px"><a class=m href="{$search[n].id_author|aurl}">{$search[n].nickname}</a></div>

<div id="f{$search[n].id}"><a class='m' href='/downloads.php?id={$search[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$search[n].filename}">{$search[n].filename}</a></div>
<div id="t{$search[n].id}" class="zx-track-list__cell--title" style="color: #888">{if $search[n].name}{$search[n].name}{else}&nbsp;{/if}</div>
<div nowrap style="color: #888"> &nbsp; 

<img onclick="Rate({$search[n].id})" id="r{$search[n].id}" class="{$search[n].rt}" src="css/handup.gif" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}"> <div style="display: inline" id="rn{$search[n].id}">{$search[n].rating}</div>
</div>

<div nowrap style="color: #777"> &nbsp; 
<img onclick="Comm({$search[n].id})" class="rating" src="css/comments.gif" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}"> 
<div style="display: inline; color: #{if $search[n].comments}0063B0{else}888{/if}" id="cm{$search[n].id}">{$search[n].comments}</div>
</div>

</div>
<div id="c{$search[n].id}" class="comment_off zx-track-list__line"></div>
<div id="pl{$search[n].id}" class="plln zx-track-list__line"></div>

{/section}
</div>  


<div class="zx-pager-bar">
<div id='Navigator2'><span style="FONT-SIZE: 12px;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> 

{section name=n loop=$pages}
{if $pages[n] eq $page}<span class="Page">{$pages[n]}</span>
{else}
<a class='Page' href="last_rated.php?page={$pages[n]}">{$pages[n]}</a>
{/if}
{/section}

</div>

<form method="post">

<select name='sort' style="font: normal 11px Arial">

{if $language eq 'rus'}
<option value='1' {if $sort eq 1}selected{/if}>по дате оценки</option>
<option value='2' {if $sort eq 2}selected{/if}>по музыкантам</option>
<option value='3' {if $sort eq 3}selected{/if}>по рейтингу</option>
<option value='4' {if $sort eq 4}selected{/if}>случайно</option>
{else}
<option value='1' {if $sort eq 1}selected{/if}>per last rated</option>
<option value='2' {if $sort eq 2}selected{/if}>per musicians</option>
<option value='3' {if $sort eq 3}selected{/if}>per rating</option>
<option value='4' {if $sort eq 4}selected{/if}>random</option>
{/if}

</select>

<input name="page" value="{$page}" type="hidden">
<input name="ok" value="ok" type="submit">
</form>

<div class="zx-pager-bar__count"><span class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$nm1} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$nm2}</div>
</div>


{include file="right_strip.tpl"}
{include file="footer.tpl"}
