{include file="menu.tpl"}

	
 






<p align="left">
 
<!-- =========================== -->
{if $mode eq 0}


{section name=n loop=$news_list}



<h3><A href="{$link_2_name}.php?{$link_2_id}={$news_list[n].id}">{$news_list[n].title}</A></H3>

<div style="color: grey; font: bold 11px Arial">{$news_list[n].author} - {$news_list[n].date2} - 1/{$news_list[n].messages}</div>
<p>{$news_list[n].text}{$news_list[n].div}</p>




{if $news_list[n].nm eq 2 OR $news_list[n].nm eq 4 OR $news_list[n].nm eq 7}
{/if}



{/section}



<!-- ========================================= -->
{elseif $mode eq 1}



<h1>{$title}</h1>




{section name=n loop=$news_list}


<div style="font: bold 11px Arial">{$news_list[n].author} - {$news_list[n].date}</div>
<p>{$news_list[n].text}{$news_list[n].div}</p>



{if $news_list[n].nm eq 2 OR $news_list[n].nm eq 4 OR $news_list[n].nm eq 7}
{/if}

<br><br>
{/section}


<!-- ========================================================= -->
{else}

<div class="post-1107 post sticky hentry category-home" id="post-1107">

<H2>Архив тем</H2>

{section name=n loop=$news_list}
<B>
<div style="padding-top: 4px">
<div style="width: 80px; float: left; font-size: 12px">{$news_list[n].date}</div>
<div> » <A href="{$link_2_name}.php?{$link_2_id}={$news_list[n].id}">{$news_list[n].title}</A></div>
</div>
</B>
{/section}
</div>

{/if}



<br><br>
<div class="navigation-bottom">
{if $news_pages[1]}

{/if}
<br>
</div>



		

{if $mode eq 0 or $mode eq 2}

<center>


<br><br>

{if $news_pages[1]}

{if $news_pages[0] neq 1}<a href="{$link_1_name}.php?{$link_1_id}=1">1</a> ... {/if}

{section name=n loop=$news_pages}

{if $news_pages[n] eq $news_tk_page}
	<b>&laquo;{$news_pages[n]}&raquo;</b>
{else}
	<a href="{$link_1_name}.php?{$link_1_id}={$news_pages[n]}">{$news_pages[n]}</a>
{/if} 
{/section}
 ... <a href="{$link_1_name}.php?{$link_1_id}={$news_nm_pages}">{$news_nm_pages}</a>
{/if}

</center>
<br>


{elseif $mode eq 1}

<br><br>
<center>
{if $news_pages[1]}

{section name=n loop=$news_pages}

{if $news_pages[n] eq $news_tk_page}
	<b>&laquo;{$news_pages[n]}&raquo;</b>
{else}
	<a href="{$link_2_name}.php?{$link_2_id}={$id}&page={$news_pages[n]}">{$news_pages[n]}</a>
{/if} 
{/section}
{/if}
</center>
<br><br>

<div id="respond">
<h2>Ответить:</h2>

<form method="post" id="commentform">

<p><input type="text" name="author" id="author" value="" size="22" tabindex="1" />
<label for="author"><small>Имя</small></label></p>
<p><input type="text" name="email" id="email" value="" size="22" tabindex="2" />
<label for="email"><small>e-mail</small></label></p>

<p><textarea name="comment" id="comment" cols="50%" rows="10" tabindex="4"></textarea></p>
<p><input name="submit" type="submit" id="submit" tabindex="5" value="отправить" />
<input type='hidden' name='comment_post_ID' value='581' id='comment_post_ID' />
<input type='hidden' name='comment_parent' id='comment_parent' value='0' />
</p>

</form>

</div>

{/if}
</p>
 












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