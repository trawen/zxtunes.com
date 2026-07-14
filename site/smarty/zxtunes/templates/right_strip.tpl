</main>
<aside class="site-layout__aside" id="right_column_holder">
<div class="right_column">

<!--
<center>
<strong style="color: red">
{if $language eq 'rus'}Слушайте музыку в <a href="/software.php?id=20">AY Emulator{else}Listen music in <a href="/software.php?id=20">AY Emulator{/if}
</strong>
<img border=0 src="images/ay_emulator.jpg"></a>
</center>

<br><br>





<div class="menu_box">
<div class="menu_title"><span class="menu_title">{if $language eq 'rus'}ПОПУЛЯРНЫЕ{else}{/if}</span></div>



<div style="padding-top: 4px">

<UL class=forum>
<LI>
{section name=n loop=$best}

<a class=mm href="{$best[n].id_author|aurl}">{$best[n].nickname}</a> - <a class='m' href='/downloads.php?id={$best[n].id}' 
title="{if $language eq 'rus'}Скачать {else}Download {/if} {$best[n].filename}">{$best[n].filename}</a><br>

{/section}
...
<div align="right"><a href="last_rated.php">{if $language eq 'rus'}слушать online{else}playing online{/if}</a> →</div>
</LI>
</LI></UL>

</div>
</div>

<div class="brk"></div>
-->








{if $user.login and $user.id}
<div class="menu_box_user">
<div class="menu_title"><span class="menu_title" style="text-transform: uppercase;  vertical-align: bottom"><img src="/css/user_ico2.png" style="opacity:.5;"> &nbsp;{if $language eq 'rus'}АДМИНКА{else}ADMIN{/if}</span></div>
<div style="padding-top: 4px">

<UL class=forum><LI>

<b>&nbsp; {if $language eq 'rus'}Ваша страница{else}Your page{/if}: <a class=m href="/cave.php?id={$user.id}">{$user.login}</a></b>

</LI></UL>


</div>
</div>
<div class="brk"></div>
{/if}








<div class="brk"></div>

<!-- <a href="http://bit.ly/2vmID00"><img src="/images/cc17.png"></a> -->

<div class="brk"></div>
	
<div class="menu_box">
<div class="menu_title"><span class="menu_title"><img style="opacity:.5" src="/css/update_ico.png"> &nbsp;{if $language eq 'rus'}ОБНОВЛЕНИЯ{else}UPDATES{/if}</span></div>


<div style="padding-top: 4px">

<UL class=forum>
<LI style="line-height: 16px">
{section name=n loop=$upd}

{if $language eq 'rus'}
{if $upd[n].event eq 0}<img src="/css/musician.png" style="opacity:.5"> 
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> обновил профайл 

{elseif $upd[n].event eq 1}<img src="/css/musician.png" style="opacity:.5"> 
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> загрузил фото

{elseif $upd[n].event eq 3}<img src="/css/musician.png" style="opacity:.5"> 
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> обновил фото

{elseif $upd[n].event eq 4}<img src="/css/musician.png" style="opacity:.5"> 
<b>{$upd[n].misc}</b> перемещен в <A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A>

{elseif $upd[n].event eq 5}<img src="/css/musician.png" style="opacity:.5"> 
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> добавил интервью

{elseif $upd[n].event eq 6}<img src="/css/musician.png" style="opacity:.5"> 
Новый автор - <A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A>!
{/if}


{else}
{if $upd[n].event eq 0}
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A>  profile updated 

{elseif $upd[n].event eq 1}
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> uploaded photo

{elseif $upd[n].event eq 3}
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> photo updated

{elseif $upd[n].event eq 4}
<b>{$upd[n].misc}</b> removed to <A class=m href="{$gbs[n].author_id|aurl}">{$upd[n].nickname}</A>

{elseif $upd[n].event eq 5}
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> added interview

{elseif $upd[n].event eq 6}
<A class=m href="{$upd[n].id|aurl}">{$upd[n].nickname}</A> a new author!
{/if}


{/if}
 <SPAN class=d>{$upd[n].update}</SPAN><br>
{/section}
</LI></UL>

</div>
</div>





<div class="brk"></div>
<div class="menu_box">
<div class="menu_title"><span class="menu_title"><img src="/css/popular_ico.png" style="opacity:.5"> &nbsp;{if $language eq 'rus'}ЛЮБИМЧИКИ{else}TOP 10{/if}</span></div>

<div style="padding-top: 4px">

<UL class=forum><LI style="line-height: 16px">
{section name=n loop=$bests}
<img src="/css/musician.png" style="opacity:.5"> 
<A class=m href="{$bests[n].id|aurl}">{$bests[n].nickname}</A>{$bests[n].z}
{/section}
</LI></UL>

</div>
</div>







<div class="brk"></div>
<div class="menu_box">
<div class="menu_title"><span class="menu_title"><img src="/css/guestbook_ico.png" style="opacity:.5"> &nbsp;{if $language eq 'rus'}НАГОСТИЛИ{else}GUESTBOOK{/if}</span></div>


<div style="padding-top: 4px">

<UL class=forum><LI style="line-height: 16px">
{section name=n loop=$gbs}
<img src="/css/listener.png" style="opacity:.5"> 
<A class=m href="{$gbs[n].author_id|aurl}?md=4">{$gbs[n].user_name}:</A> 
{$gbs[n].message} <SPAN class=d>{$gbs[n].update}</SPAN> 
{/section}
</LI></UL>

</div>
</div>



<div class="brk"></div>
		

		
<div class="menu_box">
<div class="menu_title"><span class="menu_title"><img src="/css/wanted_ico.png" style="opacity:.5"> &nbsp;{if $language eq 'rus'}РОЗЫСК{else}WANTED{/if}</span></div>


<div style="padding-top: 4px">

<UL class=forum><LI>
{$wanted}
</LI></UL>

</div>
</div>



{if $sape_links}
<div class="brk"></div>


<div class="menu_box">
<div class="menu_title"><span class="menu_title"><img src="/css/links_ico.png" style="opacity:.5"> &nbsp;{if $language eq 'rus'}РЕКЛАМА{else}ADVERTS{/if}</span></div>


<div style="padding-top: 4px">


<UL class=forum><LI>
<div style="padding-left: 2px; FONT-WEIGHT: normal; FONT-SIZE: 0.6em; COLOR: #909090">{$sape_links}</div>
</LI></UL>

</div>
</div>
{/if}



<br>

<div style="padding-top: 2px;" align=center>
{if $language eq 'rus'}
<img src="/css/error_ico.png"> 
<a class=g href="/informer.php">Нашли ошибку?</a> &nbsp; 
<img src="/css/plus_ico.png"> 
<a class=g href="/informer.php">Добавить инфо</a> →
{else}
<img src="/css/error_ico.png"> 
<a class=g href="/informer.php">Found a bug?</a> &nbsp; 
<img src="/css/plus_ico.png"> 
<a class=g href="/informer.php">Add info</a> →
{/if}
</div>

    

<!--
<br>

<center>
<strong style="color: red">
{if $language eq 'rus'}Создавайте музыку в <br><a href="/software.php?id=12">Vortex Tracker{else}Create music in <a href="/software.php?id=12">Vortex Tracker{/if}
</strong>
<img border=0 src="images/vortex_tracker_scr.png" vspace="2"></a>
</center>

-->

</div>
</aside>
