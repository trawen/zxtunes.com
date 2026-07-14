{include file="menu.tpl"}
 
<div class="zx-podcast-page">

<div>
<h3>{if $language eq 'rus'}{$podcast.topic_rus}{else}{$podcast.topic_eng}{/if}</h3>

<div class="zx-soft-dl">
<img src='images/download.png'>
<div class="soft_copyright"><a style='COLOR: #0063b0;' href='downloads.php?id={$podcast.id}&md=podcast'><b>{$podcast.file_name}</b></a> <span style="FONT-SIZE: 0.9em;">(MP3 / {$podcast.file_size}Mb)</span> &nbsp; {$podcast.player}</div>
<div class="zx-soft-dl__meta"><span class="dd">
{if $language eq 'rus'}скачиваний{else}downloads{/if}</span> {$podcast.downloads}
</div>
</div>
</div>


<div class="zx-meta-box">

<div class="zx-meta-box__row"><span class="dd">{if $language eq 'rus'}просмотры{else}views{/if}:</span> {$podcast.views}</div>
 
<div class="zx-meta-box__row"><span class="dd">{if $language eq 'rus'}дата:{else}release date:{/if}</span> &nbsp;  {$podcast.release_date}</div>
</div>


<div class="zx-podcast-page__body">
<br><br>
{if $language eq 'rus'}{$podcast.text_rus}{else}{$podcast.text_eng}{/if}
</div>

</div>


{include file="right_strip.tpl"}


{include file="footer.tpl"}
