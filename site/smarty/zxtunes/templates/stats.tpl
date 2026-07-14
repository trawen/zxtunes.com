{include file="menu.tpl"}
 
<H3>{if $language eq 'rus'}Статистика{else}Statistics{/if}</H3>

<div style="font-size: 1.3em;">
{if $language eq 'rus'}
На сайте: <b>{$authors[0]}</b> авторов, <b>{$tunes[0]}</b> треков, <b>{$photos[0]}</b> авторов с фото, <b>{$interviews[0]}</b> интервью, <b>{$messages[0]}</b> сообщений в гостевых книгах. 
{else}
On site: <b>{$authors[0]}</b> authors, <b>{$tunes[0]}</b> tunes, <b>{$photos[0]}</b> authors with photo, <b>{$interviews[0]}</b> interviews, <b>{$messages[0]}</b> messages in guestbooks.
{/if} 
</div><br>

<div style="font-size: 1.3em;" class=news>{if $language eq 'rus'}Авторы активные на данный момент: {else}Today active authors: {/if}{$act}</div>


<br><br>
<H2>TOP 10</H2>

<div class="zx-stats-cols">

<div class="zx-stats-col">
<div class="zx-stats-col__title">{if $language eq 'rus'}Активные авторы{else}Active authors{/if}</div>
{section name=n loop=$bytunes}
{cycle values=""}
<div class="zx-stats-col__row">
<span><b>{$bytunes[n].nm}.</b></span>
<span><A class=m href="{$bytunes[n].id|aurl}">{$bytunes[n].nickname}</a></span>
<span>{$bytunes[n].num_tracks} 
<span class=d>{if $language eq 'rus'}треков{else}tunes{/if}</span></span>
</div>
{/section}
</div>

<div class="zx-stats-col">
<div class="zx-stats-col__title">{if $language eq 'rus'}Старейшие авторы{else}Oldest authors{/if}</div>
{section name=n loop=$byyears}
<div class="zx-stats-col__row">
<span><b>{$smarty.section.n.iteration}.</b></span>
<span><A class=m href="{$byyears[n].id|aurl}">{$byyears[n].nickname}</a></span>
<span>{$byyears[n][4]} 
<span class=d>{if $language eq 'rus'}лет{else}years{/if}</span></span>
</div>
{/section}
</div>

<div class="zx-stats-col">
<div class="zx-stats-col__title">{if $language eq 'rus'}Популярные редакторы{else}Popular editors{/if}</div>
{section name=n loop=$types max=10}
<div class="zx-stats-col__row">
<span><b>{$smarty.section.n.iteration}.</b></span>
<span>{if $types[n].lnk}<A class=m href="/software.php?id={$types[n].lnk}">{$types[n].type}</a>
{else}<b>{$types[n].type}</b>{/if}</span>
<span>{$types[n].kl} 
<span class=d>{if $language eq 'rus'}треков{else}tunes{/if}</span></span>
</div>
{/section}
</div>

<div class="zx-stats-col">
<div class="zx-stats-col__title">{if $language eq 'rus'}Музыкальные города{else}Musical cities{/if}</div>
{section name=n loop=$bycity}
<div class="zx-stats-col__row">
<span><b>{$smarty.section.n.iteration}.</b></span>
<span><A class=m href="/authors_list.php?order=city&sr={if $language eq 'rus'}{$bycity[n].city}{else}{$bycity[n].city_en}{/if}">
{if $language eq 'rus'}{$bycity[n].city}{else}{$bycity[n].city_en}{/if}</a></span>
<span>{$bycity[n][1]} 
<span class=d>{if $language eq 'rus'}авторов{else}authors{/if}</span></span>
</div>
{/section}
</div>

</div>



<br><br>
{if $language eq 'rus'}
Следующий график отражает количество музыкантов на спектруме в тот или иной год 
(наиболее точны данные за 1995-2007 года):
{else}
The following schedule reflects quantity of musicians in a spectrum in this or that year (data for 1995-2008 are most exact):
{/if}
<div align=left><img src="images/grafik.png" ></div>

<div style="font-size: 1.3em;">
<br>
{if $language eq 'rus'}
На графике можно отметить несколько ключевых моментов: 
{else}
On the schedule it is possible to note some the key moments:
{/if}
<p>
<b>1989</b>
{if $language eq 'rus'}
 год - Игр выходит все меньше, однако сами игры становятся профессиональнее и количество игр c музыкальным сопровождением под музыкальный сопроцессор AY-3-8910 увеличивается (по сравнению с предыдущими годами).
{else}
year - Games leaves ever less, however games become more professional also quantity of games c music underneath under musical coprocessor AY-3-8910 increases (in comparison with the last years).
{/if}
</p>

<p>
<b>1993</b> 
{if $language eq 'rus'}
год - На западе окончательно прекращен выпуск коммерческих игр, журналов и программ.
В России этот год напротив отмечен небывалым ростом интереса к спектруму. Запущены в производство множество  новых клонов спектрума, с каждым днем выходит все больше новых программ, количество пользовталей многократно увеличивается.  
{else}
year - In the west Europe is finally stopped release of commercial games, magazines and programs. In Russia this year is opposite noted by unknown growth of interest to a spectrum. Are started in manufacture set of new clones of a spectrum, every day leaves more and more than new programs, the quantity users repeatedly increases.
{/if}
</p>
 
<p>
<b>1997</b> 
{if $language eq 'rus'}
год - Молодые пользователи все чаще спектруму предпочитают новомодные приставки Dendy и Sega, в то же время бывалые спектрумисты переходят на все более доступные IBM PC или попросту взрослеют. Интерес к спектруму резко падает.
{else}
year - Young users even more often prefer a spectrum modern prefixes NES and Sega, at the same time skilled users pass on more and more accessible IBM PC or simply mature. Interest to a spectrum starts to fall sharply.
{/if}
</p>
</div>




      	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}
