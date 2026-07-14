{include file="menu.tpl"}

<H3>{if $language eq 'rus'}Гостевые сообщения - полный список{else}Guest messages - the full list{/if}</H3>




<br><br>
<div class="zx-feed">
{section name=n loop=$messages}
{cycle values=""}
<div class="zx-feed-item">
<div class="zx-feed-item__badge">{$messages[n].nm}</div>
<div class="zx-feed-item__head">
<div class="zx-feed-item__title">{if $messages[n].user_email}
{mailto extra='class="m"' address=$messages[n].user_email text=$messages[n].user_name encode="javascript"}
{else}<b>{$messages[n].user_name}</b>{/if}<noindex>
{if $messages[n].site}<a href="http://{$messages[n].site}" rel="nofollow"><img border=0 style="padding-left: 8px;" src="images/home.png"></a>{/if}</noindex>
</div>
<div class="zx-feed-item__meta"><span class=d>{$messages[n].update}</span></div>
</div>
<div class="zx-feed-item__body">{$messages[n].message}</div>
</div>
{/section}

</div>


	  

      	  
{include file="right_strip.tpl"}
{include file="footer.tpl"}
