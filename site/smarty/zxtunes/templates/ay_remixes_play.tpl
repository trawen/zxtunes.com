{include file="menu.tpl"}

<script type="text/javascript" src="css/jquery.js"></script>
<script type="text/javascript" src="/js/swfobject.js"></script>
<script type="text/javascript" src="css/player6.js"></script> 
<script language="javascript">
var autoplay = 0;
var author_name = "zx";
var first_track = {$remixes[0].id};
</script>



<h2>Группа «<span style="text-transform: uppercase">{$remix_info.rfr_name_ru}</span>»</h2> 

<strong style="font: 11px bold Arial">ремиксы / ремейки / каверы / копии / конверсии</strong>

<br><br>


{assign var="in_album" value=0}
{section name=n loop=$remixes}

{if $remixes[n].show_album}
{if $in_album}</div></div>{/if}
{assign var="in_album" value=1}
<div class="zx-remix-album">
<div class="zx-remix-album__cover">
<img src="remix_images/albums/{$remixes[n].ral_id}.{$remixes[n].ral_image}"><br>
<b>{$remixes[n].ral_title_ru}</b>
</div>
<div class="zx-remix-album__tracks">
{/if}

<div class="zx-remix-track" id="s{$remixes[n].song_id}">

<div>
<div id="m{$remixes[n].song_id}" class="play" onclick="PlayB('{$remixes[n].song_id}')"></div>
<div id="n{$remixes[n].song_id}" style="display: none">{$remixes[n].next_id}</div>
<div id="p{$remixes[n].song_id}" style="display: none">{$remixes[n].prev_id}</div>
<div id="a{$remixes[n].song_id}" style="display: none">{$remixes[n].author_id}</div>
<div id="f{$remixes[n].song_id}" style="display: none"></div>
</div>

<div><a class='m' href='/downloads.php?id={$remixes[n].song_id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$remixes[n].rti_title_ru}.mp3">{$remixes[n].rti_title_ru}</a> &nbsp; - &nbsp; <a class=mm href="{$remixes[n].author_id|aurl}">{$remixes[n].nickname}</a> {if $remixes[n].year} © <span style="color: #888">{$remixes[n].year} год</span>{/if}</div>

<div style="color: #888"> &nbsp; 
<img onclick="Rate({$remixes[n].song_id})" id="r{$remixes[n].song_id}" class="rating" src="css/handup.gif" title="{if $language eq 'rus'}Мне нравится!{else}I Like it!{/if}"> <div style="display: inline" id="rn{$remixes[n].song_id}">
{$remixes[n].rating}</div>
</div>

<div nowrap style="color: #777"> &nbsp; 
<img onclick="Comm({$remixes[n].song_id})" class="rating" src="css/comments.gif" title="{if $language eq 'rus'}Добавить комментарий{else}Add Comment{/if}"> 
<div style="display: inline;" id="cm{$remixes[n].song_id}">
{if $search[n].comments}<b>{$remixes[n].comments}</b>{else}{$remixes[n].comments}{/if}</div>
</div>

</div>

<div id="c{$remixes[n].song_id}" class="comment_off"></div>
<div id="pl{$remixes[n].song_id}" class="plln2"></div>

{/section}
{if $in_album}</div></div>{/if}


{include file="right_strip.tpl"}
{include file="footer.tpl"}
