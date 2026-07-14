{include file="menu.tpl"}

	
 

<H3>{if $language eq 'rus'}Новости{else}News{/if}</H3>

<br><br>
<div class="zx-feed">
{section name=n loop=$news}
{cycle values=""}
<div class="zx-feed-item">
<div class="zx-feed-item__badge">{$news[n].nm}</div>
<div class="zx-feed-item__head">
<div class="zx-feed-item__title">
{if $language eq 'rus'}{$news[n].topic_rus}{else}{$news[n].topic_eng}{/if}
</div>
<div class="zx-feed-item__meta"><span class=d>{$news[n].update}</span> | 
<span class=d>{if $language eq 'rus'}добавил{else}posted by{/if}  <b>{$news[n].username}</b></span></div>
</div>
<div class="zx-feed-item__body news">
{if $language eq 'rus'}{$news[n].text_rus}{else}{$news[n].text_eng}{/if}<br><br>
</div>
</div>
{/section}

</div>






	  

      	  
{include file="right_strip.tpl"}


{include file="footer.tpl"}
