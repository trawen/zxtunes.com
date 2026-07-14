{include file="menu.tpl"}

<h2>РЕМИКСЫ</h2>

<b>
{if $type eq 1}МУЗЫКАЛЬНЫЕ ГРУППЫ{else}<a class=m href="ay_remixes.php?type=1">МУЗЫКАЛЬНЫЕ ГРУППЫ</a>{/if} / 
{if $type eq 2}ФИЛЬМЫ, МУЛЬТФИЛЬМЫ И ТВ{else}<a class=m href="ay_remixes.php?type=2">ФИЛЬМЫ, МУЛЬТФИЛЬМЫ И ТВ</a>{/if} / 
{if $type eq 3}ИГРЫ И ДЕМОСЦЕНА{else}<a class=m href="ay_remixes.php?type=3">ИГРЫ И ДЕМОСЦЕНА</a>{/if} / 
{if $type eq 4}КЛАССИКА{else}<a class=m href="ay_remixes.php?type=4">КЛАССИКА</a>{/if}
</b>

<br><br>

<div class="zx-data-grid zx-data-grid--ay-remix">

<div class="zx-data-grid__row zx-data-grid__row--head">
<div class="zx-data-grid__cell">№</div>
<div class="zx-data-grid__cell">Исполнитель</div>
<div class="zx-data-grid__cell">Ремиксы</div>
<div class="zx-data-grid__cell">Просмотры</div>
<div class="zx-data-grid__cell">Обновления</div>
</div>


{section name=n loop=$remixes}

{if $remixes[n].show_lit}<div class="zx-data-grid__row"><div class="zx-data-grid__cell">&nbsp;</div><div class="zx-data-grid__cell">&nbsp;</div><div class="zx-data-grid__cell">&nbsp;</div><div class="zx-data-grid__cell">&nbsp;</div><div class="zx-data-grid__cell">&nbsp;</div></div>{/if}

<div class="zx-data-grid__row">
<div class="zx-data-grid__cell" style="text-transform: uppercase"><b>{if $remixes[n].show_lit}{$remixes[n].lit}{else}&nbsp;{/if}</b></div>
<div class="zx-data-grid__cell"><a class=m href="ay_remixes_play.php?id={$remixes[n].rfr_id}">{$remixes[n].rfr_article}{$remixes[n].rfr_name_ru}</a></div>
<div class="zx-data-grid__cell">{$remixes[n].rfr_num_tunes}</div>
<div class="zx-data-grid__cell">{$remixes[n].rfr_views}</div>
<div class="zx-data-grid__cell">{$remixes[n].rfr_update}</div>
</div>



{/section}
</div>



{include file="right_strip.tpl"}
{include file="footer.tpl"}
