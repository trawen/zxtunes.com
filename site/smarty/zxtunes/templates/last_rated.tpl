{include file="menu.tpl"}
<script type="text/javascript" src="css/jquery.js"></script>
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



<table width=100% border=0 ><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 12px;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> 

{section name=n loop=$pages}
{if $pages[n] eq $page}<span class="Page">{$pages[n]}</span>
{else}
<a class='Page' href="last_rated.php?page={$pages[n]}">{$pages[n]}</a>
{/if}
{/section}

</div>
</td>
<td>


 

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





</td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$nm1} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$nm2}</div></td></tr></table><br>











<table border=0 cellpadding=0 cellspacing=0 width='100%'>
<tr cellpadding=2 bgcolor=#dedbd8 height=16>
{if $language eq 'rus'}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b> Музыкант </b></td>
<td nowrap><b>Имя файла</b></td>
<td nowrap><b>Название трека</b></td>
<td nowrap><b> &nbsp; Рейтинг</b></td>
<td nowrap><b> &nbsp; Комм.</b></td>
</tr>
{else}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b> Musician </b></td>
<td nowrap><b>File name</b></td>
<td nowrap><b>Title</b></td>
<td nowrap><b> &nbsp; Rating</b></td>
<td nowrap><b> &nbsp; Comm.</b></td>
</tr>
{/if}

<tr><td colspan="9" style="height: 2px;"></td></tr>


{section name=n loop=$search}


<tr id="s{$search[n].id}">

<td width="26" align="center">
<div id="m{$search[n].id}" class="play" onclick="PlayB('{$search[n].id}')"></div>
<div id="n{$search[n].id}" style="display: none">{$search[n].next_id}</div>
<div id="p{$search[n].id}" style="display: none">{$search[n].prev_id}</div>
<div id="a{$search[n].id}" style="display: none">{$search[n].id_author}</div>
</td>


<td style="padding-right: 8px"><a class=m href="author.php?id={$search[n].id_author}">{$search[n].nickname}</a></td>


<td id="f{$search[n].id}"><a class='m' href='downloads.php?id={$search[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$search[n].filename}">{$search[n].filename}</a></td>
<td id="t{$search[n].id}" style="color: #888">{if $search[n].name}{$search[n].name}{else}&nbsp;{/if}</td>
<td nowrap style="color: #888" valign=middle> &nbsp; 

<img onclick="Rate({$search[n].id})" id="r{$search[n].id}" class="{$search[n].rt}" src="css/handup.gif" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}"> <div style="display: inline" id="rn{$search[n].id}">{$search[n].rating}</div>
</td>

<td nowrap style="color: #777" valign=middle> &nbsp; 
<img onclick="Comm({$search[n].id})" class="rating" src="css/comments.gif" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}"> 
<div style="display: inline; color: #{if $search[n].comments}0063B0{else}888{/if}" id="cm{$search[n].id}">{$search[n].comments}</div>
</td>

</tr>
<tr><td></td><td colspan="7" id="c{$search[n].id}" class="comment_off"></td></tr>
<tr><td></td><td colspan="7" id="pl{$search[n].id}" class="plln" style="height: 13px"></td></tr>


{/section}
</table>  


<table width=100% border=0 ><tr><td align=left>
<div id='Navigator2' style="PADDING-TOP: 1.2em;" align='left'><span style="FONT-SIZE: 12px;">
{if $language eq 'rus'}Страницы: {else}Pages: {/if}</span> 

{section name=n loop=$pages}
{if $pages[n] eq $page}<span class="Page">{$pages[n]}</span>
{else}
<a class='Page' href="last_rated.php?page={$pages[n]}">{$pages[n]}</a>
{/if}
{/section}

</div>
</td>
<td>


 

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





</td><td align=right><div style="PADDING-TOP: 0.9em;"><span  class="dd">
{if $language eq 'rus'}треков {else}tunes {/if}</span> {$nm1} <span class="dd">
{if $language eq 'rus'}из {else}from {/if}</span> {$nm2}</div></td></tr></table><br>




{include file="right_strip.tpl"}
{include file="footer.tpl"}