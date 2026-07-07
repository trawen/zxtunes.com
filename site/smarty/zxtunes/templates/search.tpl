{include file="menu.tpl"}
<script type="text/javascript" src="css/jquery.js"></script>
<script type="text/javascript" src="css/player6.js"></script> 
<script language="javascript">
var autoplay = {$autoplay};
var author_name = "{$search[0].nickname}";
var first_track = {$search[0].id};
</script>




<H3>{if $language eq 'rus'}Вы искали{else}You search{/if} «<span style='COLOR: #e08200'>{$srtext}</span>»</H3>



{if $klsr}


{if $mdsr eq 'authors'}
<table>
{section name=n loop=$search}
{cycle values=""}
<tr><td align=right style="padding-top: 4px;">
{$search[n].nm}. 
</td>
<td style="padding-top: 4px;">
<a class=m href="author.php?id={$search[n].id}">{$search[n].nickname}</a> 
{if $language eq 'rus'}
	{if $search[n].first_name and $search[n].last_name}({$search[n].first_name} {$search[n].last_name})
	{elseif $search[n].first_name or $search[n].last_name}({$search[n].first_name}{$search[n].last_name})
	{/if}
{else}
	{if $search[n].first_name_en and $search[n].last_name_en}({$search[n].first_name_en} {$search[n].last_name_en})
	{elseif $search[n].first_name_en or  $search[n].last_name_en}({$search[n].first_name_en}{$search[n].last_name_en})
	{/if}
{/if}

{if $search[n].group_name} / {$search[n].group_name} {/if}

{if $search[n].also1}{if $language eq 'rus'}<SPAN style="padding-left: 8px;" class=d>другие ники:</span> 
{else}<SPAN style="padding-left: 8px;" class=d>also known: </span>{/if}{$search[n].also1}
{if $search[n].also2}, {$search[n].also2}{/if}
{if $search[n].also3}, {$search[n].also3}{/if}
{if $search[n].also4}, {$search[n].also4}{/if}
{if $search[n].also5}, {$search[n].also5}{/if}
{/if}
</td>
</tr>
{/section}
</table>  



{elseif $mdsr eq 'software'}
<table>
{section name=n loop=$search}
{cycle values=""}
<tr><td align=right style="padding-top: 4px;">
{$search[n].nm}. 
</td>
<td style="padding-top: 4px;">
<a class=m href="software.php?id={$search[n].id}">{$search[n].title}{if $search[n].version} {$search[n].version}{/if}</a> 
{if $search[n].author} by {$search[n].author} {/if}
</td>
</tr>
{/section}
</table>  


{elseif $mdsr eq 'tunes'}

<div style="FONT-SIZE: 1.3em;">
найденные треки одним архивом: <a class=m href="search.php?download=search">zxtunes_search_{$srtx}.zip</a> (~{$srsz}Kb)</div><br><br>







{include file="flash.tpl"}	



<table border=0 cellpadding=0 cellspacing=0 width='100%'>
<tr cellpadding=2 bgcolor=#dedbd8 height=16>
{if $language eq 'rus'}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b> Автор </b></td>
<td nowrap><b>Имя файла</b></td>
<td nowrap><b>Название трека</b></td>
<td nowrap><b> &nbsp; Рейтинг</b></td>
<td nowrap><b> &nbsp; Комм.</b></td>
</tr>
{else}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b> Author </b></td>
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
<div id="a{$search[n].id}" style="display: none">{$search[n].author_id}</div>
</td>


<td><a class=m href="author.php?id={$search[n].author_id}">{$search[n].nickname}</a> </td>


<td id="f{$search[n].id}"><a class='m' href='downloads.php?id={$search[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$search[n].filename}">{$search[n].filename}</a></td>
<td id="t{$search[n].id}" style="color: #888">{if $search[n].name}{$search[n].name}{else}&nbsp;{/if}</td>
<td nowrap style="color: #888" valign=middle> &nbsp; 

<img onclick="Rate({$search[n].id})" id="r{$search[n].id}" class="{$search[n].rt}" src="css/handup.gif" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}"> <div style="display: inline" id="rn{$search[n].id}">
{$search[n].rating}</div>
</td>

<td nowrap style="color: #777" valign=middle> &nbsp; 
<img onclick="Comm({$search[n].id})" class="rating" src="css/comments.gif" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}"> 
<div style="display: inline;" id="cm{$playlist[n].id}">
{if $search[n].comments}<b>{$search[n].comments}</b>{else}{$search[n].comments}{/if}</div>
</td>

</tr>
<tr><td></td><td colspan="7" id="c{$search[n].id}" class="comment_off"></td></tr>
<tr><td></td><td colspan="7" id="pl{$search[n].id}" class="plln" style="height: 13px"></td></tr>


{/section}
</table>  
{/if}



{else}
<br>
<b>
	{if $language eq 'rus'}Увы, по вашему запросу ничего не найдено. Возможно вы ошиблись разделом?
	{else}
	Alas, by your inquiry nothing is found. Probably you were mistaken section?
	{/if}
</b>
{/if} 	  


{include file="right_strip.tpl"}



{include file="footer.tpl"}