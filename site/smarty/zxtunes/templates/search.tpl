{include file="menu.tpl"}
<script type="text/javascript" src="css/jquery.js"></script>
<script type="text/javascript" src="css/player6.js"></script>
{if $search_tunes|@count}
<script language="javascript">
var autoplay = {$autoplay|default:0};
var author_name = "{$search_tunes[0].nickname|escape:'javascript'}";
var first_track = {$search_tunes[0].id};
</script>
{/if}

<H3>{if $language eq 'rus'}Вы искали{else}You searched for{/if} «<span style="COLOR: #e08200">{$srtext}</span>»</H3>

{if $search_total}

{if $search_authors|@count}
<section class="search-section">
<h4 class="search-section__title">{if $language eq 'rus'}Музыканты{else}Musicians{/if} ({$search_authors|@count})</h4>
<table class="search-section__table">
{section name=n loop=$search_authors}
<tr>
<td align="right" class="search-section__num">{$search_authors[n].nm}.</td>
<td>
<a class="m" href="{$search_authors[n].id|aurl}">{$search_authors[n].nickname}</a>
{if $language eq 'rus'}
	{if $search_authors[n].first_name and $search_authors[n].last_name}({$search_authors[n].first_name} {$search_authors[n].last_name})
	{elseif $search_authors[n].first_name or $search_authors[n].last_name}({$search_authors[n].first_name}{$search_authors[n].last_name})
	{/if}
{else}
	{if $search_authors[n].first_name_en and $search_authors[n].last_name_en}({$search_authors[n].first_name_en} {$search_authors[n].last_name_en})
	{elseif $search_authors[n].first_name_en or $search_authors[n].last_name_en}({$search_authors[n].first_name_en}{$search_authors[n].last_name_en})
	{/if}
{/if}
{if $search_authors[n].group_name} / {$search_authors[n].group_name}{/if}
{if $search_authors[n].also1}
	<span class="d">{if $language eq 'rus'} — другие ники:{else} — also known:{/if}</span>
	{$search_authors[n].also1}{if $search_authors[n].also2}, {$search_authors[n].also2}{/if}{if $search_authors[n].also3}, {$search_authors[n].also3}{/if}{if $search_authors[n].also4}, {$search_authors[n].also4}{/if}{if $search_authors[n].also5}, {$search_authors[n].also5}{/if}
{/if}
</td>
</tr>
{/section}
</table>
</section>
{/if}

{if $search_groups|@count}
<section class="search-section">
<h4 class="search-section__title">{if $language eq 'rus'}Группы{else}Groups{/if} ({$search_groups|@count})</h4>
<table class="search-section__table">
{section name=n loop=$search_groups}
<tr>
<td align="right" class="search-section__num">{$search_groups[n].nm}.</td>
<td>
<a class="m" href="/authors_list.php?letter=ALL&amp;order=group_name&amp;up=ASC&amp;sr={$search_groups[n].name_plain|escape:'url'}">{$search_groups[n].name}</a>
{if $search_groups[n].acronym} <span class="d">({$search_groups[n].acronym})</span>{/if}
{if $search_groups[n].site} — <a class="mm" href="{$search_groups[n].site|escape}">{$search_groups[n].site|escape}</a>{/if}
</td>
</tr>
{/section}
</table>
</section>
{/if}

{if $search_tunes|@count}
<section class="search-section">
<h4 class="search-section__title">{if $language eq 'rus'}Треки{else}Tunes{/if} ({$search_tunes|@count})</h4>
<div class="search-section__zip">
{if $language eq 'rus'}найденные треки одним архивом:{else}found tunes as one archive:{/if}
<a class="m" href="{$search_url}?download=search">zxtunes_search_{$srtx}.zip</a> (~{$srsz|string_format:"%.0f"}Kb)
</div>

{include file="flash.tpl"}

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="search-tunes">
<tr cellpadding="2" bgcolor="#dedbd8" height="16">
{if $language eq 'rus'}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b>Автор</b></td>
<td nowrap><b>Имя файла</b></td>
<td nowrap><b>Название трека</b></td>
<td nowrap><b>&nbsp; Рейтинг</b></td>
<td nowrap><b>&nbsp; Комм.</b></td>
{else}
<td nowrap>&nbsp; &nbsp; &nbsp;</td>
<td nowrap><b>Author</b></td>
<td nowrap><b>File name</b></td>
<td nowrap><b>Title</b></td>
<td nowrap><b>&nbsp; Rating</b></td>
<td nowrap><b>&nbsp; Comm.</b></td>
{/if}
</tr>
<tr><td colspan="9" style="height: 2px;"></td></tr>
{section name=n loop=$search_tunes}
<tr id="s{$search_tunes[n].id}">
<td width="26" align="center">
<div id="m{$search_tunes[n].id}" class="play" onclick="PlayB('{$search_tunes[n].id}')"></div>
<div id="n{$search_tunes[n].id}" style="display: none">{$search_tunes[n].next_id}</div>
<div id="p{$search_tunes[n].id}" style="display: none">{$search_tunes[n].prev_id}</div>
<div id="a{$search_tunes[n].id}" style="display: none">{$search_tunes[n].author_id}</div>
</td>
<td><a class="m" href="{$search_tunes[n].author_id|aurl}">{$search_tunes[n].nickname}</a></td>
<td id="f{$search_tunes[n].id}"><a class="m" href="/downloads.php?id={$search_tunes[n].id}" title="{if $language eq 'rus'}Скачать {else}Download {/if}{$search_tunes[n].filename|strip_tags}">{$search_tunes[n].filename}</a></td>
<td id="t{$search_tunes[n].id}" style="color: #888">{if $search_tunes[n].name}{$search_tunes[n].name}{else}&nbsp;{/if}</td>
<td nowrap style="color: #888" valign="middle">&nbsp;
<img onclick="Rate({$search_tunes[n].id})" id="r{$search_tunes[n].id}" class="{$search_tunes[n].rt}" src="css/handup.gif" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}">
<div style="display: inline" id="rn{$search_tunes[n].id}">{$search_tunes[n].rating}</div>
</td>
<td nowrap style="color: #777" valign="middle">&nbsp;
<img onclick="Comm({$search_tunes[n].id})" class="rating" src="css/comments.gif" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}">
<div style="display: inline;" id="cm{$search_tunes[n].id}">{if $search_tunes[n].comments}<b>{$search_tunes[n].comments}</b>{else}{$search_tunes[n].comments}{/if}</div>
</td>
</tr>
<tr><td></td><td colspan="7" id="c{$search_tunes[n].id}" class="comment_off"></td></tr>
<tr><td></td><td colspan="7" id="pl{$search_tunes[n].id}" class="plln" style="height: 13px"></td></tr>
{/section}
</table>
</section>
{/if}

{if $search_software|@count}
<section class="search-section">
<h4 class="search-section__title">{if $language eq 'rus'}Софт{else}Software{/if} ({$search_software|@count})</h4>
<table class="search-section__table">
{section name=n loop=$search_software}
<tr>
<td align="right" class="search-section__num">{$search_software[n].nm}.</td>
<td>
<a class="m" href="/software.php?id={$search_software[n].id}">{$search_software[n].title}{if $search_software[n].version} {$search_software[n].version}{/if}</a>
{if $search_software[n].author} <span class="d">— {$search_software[n].author}</span>{/if}
</td>
</tr>
{/section}
</table>
</section>
{/if}

{if $search_remixes|@count}
<section class="search-section">
<h4 class="search-section__title">{if $language eq 'rus'}Ремиксы MP3{else}MP3 remixes{/if} ({$search_remixes|@count})</h4>
<table class="search-section__table">
{section name=n loop=$search_remixes}
<tr>
<td align="right" class="search-section__num">{$search_remixes[n].nm}.</td>
<td>
<strong>{$search_remixes[n].title}</strong>
<a class="m" href="/downloads.php?id={$search_remixes[n].id}&amp;md=remix_mp3">MP3</a>
{if $search_remixes[n].original_id}
<a class="m" href="/downloads.php?id={$search_remixes[n].original_id}">AY</a>
{/if}
{if $search_remixes[n].author} <span class="d">— {$search_remixes[n].author}</span>{/if}
{if $search_remixes[n].composer_name}
<span class="d"> / {if $language eq 'rus'}композитор:{else}composer:{/if}</span>
{if $search_remixes[n].composer_id}
<a class="m" href="{$search_remixes[n].composer_id|aurl}">{$search_remixes[n].composer_name}</a>
{else}
{$search_remixes[n].composer_name}
{/if}
{/if}
{if $search_remixes[n].year} <span class="d">({$search_remixes[n].year})</span>{/if}
{if $search_remixes[n].comment} <span class="d">— {$search_remixes[n].comment}</span>{/if}
</td>
</tr>
{/section}
</table>
</section>
{/if}

{else}
<br>
<b>
{if $language eq 'rus'}По вашему запросу ничего не найдено.
{else}Nothing found for your query.
{/if}
</b>
{/if}

{include file="right_strip.tpl"}
{include file="footer.tpl"}
