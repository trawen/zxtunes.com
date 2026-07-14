{include file="menu.tpl"}
 
 





<H3>{if $language eq 'rus'}Обновления - полный список{else}Updates - full list{/if}</H3>

<div class="zx-updates">
{section name=n loop=$updates}
{cycle values=""}
<div class="zx-updates__row">
<div>{if $updates[n].update}<br>{/if}<SPAN class=d>{$updates[n].update}</SPAN>
{if $updates[n].update}<SPAN class=d>{$updates[n].update2}</SPAN>{/if}</div>

<div>{if $updates[n].update}<br>{/if}
{if $language eq 'rus'}
{if $updates[n].event eq 0}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> обновил профайл 

{elseif $updates[n].event eq 1}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> загрузил фото

{elseif $updates[n].event eq 3}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> обновил фото

{elseif $updates[n].event eq 4}<b>{$updates[n].misc}</b> перемещен в <A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A>

{elseif $updates[n].event eq 5}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> добавил интервью

{elseif $updates[n].event eq 6}Новый автор - <A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A>!
{/if}


{else}
{if $updates[n].event eq 0}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A>  profile updated 

{elseif $updates[n].event eq 1}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> uploaded photo

{elseif $updates[n].event eq 3}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> photo updated

{elseif $updates[n].event eq 4}<b>{$updates[n].misc}</b> removed to <A class=m href="{$updates[n].author_id|aurl}">{$updates[n].nickname}</A>

{elseif $updates[n].event eq 5}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> added interview

{elseif $updates[n].event eq 6}<A class=m href="{$updates[n].id|aurl}">{$updates[n].nickname}</A> a new author!
{/if}


{/if}
</div>
</div>
{/section}
</div>



{include file="right_strip.tpl"}



{include file="footer.tpl"}
