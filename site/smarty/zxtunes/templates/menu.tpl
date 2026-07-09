{include file="top.tpl"}


<div class=tpmenu>
<TABLE height=34 cellSpacing=0 cellPadding=0 border=0 width=100%>
<TBODY>
<TR height=34>

<td width=20px></td>
<TD height=34 align=left bgcolor=#495874 width=110 valign=absMiddle>
<IMG height=34 alt="zxtunes.com" title="zxtunes.com" src="/css/zxtunes_logo.png" width=104 border=0>
</TD>


<TD height=34 align=left bgcolor=#495874 cellSpacing=0 width="100%">

<A {$active.news} href="/news.php">{if $language eq 'rus'}новости{else}news{/if}</A>
<A {$active.authors} href="/authors_list.php">{if $language eq 'rus'}музыканты{else}musicians{/if}</A>
<A {$active.authors_map} href="{$authors_map_url}">{if $language eq 'rus'}карта{else}map{/if}</A>
<A {$active.soft} href="/software_list.php">{if $language eq 'rus'}софт{else}software{/if}</A>
<A {$active.interview} href="/interview.php">{if $language eq 'rus'}интервью{else}interviews{/if}</A>
<A {$active.podcasts} href="/podcast_list.php">{if $language eq 'rus'}подкасты{else}podcasts{/if}</A>
<A {$active.stats} href="/stats.php">{if $language eq 'rus'}статистика{else}stats{/if}</A>
<A {$active.remix_mp3} href="/remix_mp3.php">{if $language eq 'rus'}ремиксы в MP3{else}MP3 remixes{/if}</A>
<A {$active.faq} href="/faq.php">{if $language eq 'rus'}чаво{else}faq{/if}</A>
</TD>


<TD bgcolor=#495874 align=right valign=middle class="tpmenu__search-cell">
<form class="site-search" method="get" action="{$search_url}">
<input class="site-search__input" type="search" name="srtext" value="{$search_query|escape}" maxlength="31" placeholder="{if $language eq 'rus'}поиск…{else}search…{/if}" aria-label="{if $language eq 'rus'}Поиск{else}Search{/if}">
<button class="site-search__btn" type="submit" name="submit" value="OK">OK</button>
</form>
</TD>


<TD bgcolor=#495874 align=right valign=bottom class="tpmenu__rainbow-cell">
<IMG title="zx-spectrum" height=34 src="/css/rainbow.png" width=12 align=absMiddle border=0>
</TD>

<td width=20px></td>
</TR>
  
</TBODY></TABLE>
</div>






 
<div style="width: 100%">
<TABLE cellSpacing=0 cellPadding=0 border=0 width=100%>
<TBODY>
<TR>
<td width=20px></td>
<td class=d style="vertical-align: top"><img src="/css/sinclair_zx_spectrum.png"> ZX Spectrum music collection
</td>

<td align=right class=d style="padding-right: 24px">
<form class="site-search site-search--mobile" method="get" action="{$search_url}">
<input class="site-search__input" type="search" name="srtext" value="{$search_query|escape}" maxlength="31" placeholder="{if $language eq 'rus'}поиск…{else}search…{/if}" aria-label="{if $language eq 'rus'}Поиск{else}Search{/if}">
<button class="site-search__btn" type="submit" name="submit" value="OK">OK</button>
</form>
{if $language eq 'rus'}
язык <b>rus <a href="{$tkurl}ln=eng" style="COLOR: #909090">eng</a></b>
{else}
language <b><a href="{$tkurl}ln=rus" style="COLOR: #909090">rus</a> eng</b>{/if}
</td>

<td width=20px></td>
</TR></TBODY></TABLE>
</div>




<TABLE cellSpacing=20 cellPadding=0 width="100%" border=0>
<TBODY>
<TR>
<td valign=top width="80%">