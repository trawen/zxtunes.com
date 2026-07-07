{include file="menu.tpl"}
 
 





{*<table valign=bottom border=0 width=100%><tr><td valign=bottom>*}
<H3>{if $language eq 'rus'}ЧАВО {else}FAQ{/if}</H3>
{*</td>
<td align=right>
	
	
	
<table border=0 align=right><tr><td style='padding: 6px; border: 1px solid #eeebe8;'>

<table width=100% border=0 cellpadding=0 cellspacing=0 valign=bottom><tr><td>
<span class="dd">
{if $language eq 'rus'}просмотров{else}views{/if}</span></td><td style='padding-left: 4px;'>
 {$faq.faq_views}
 </td></tr>
 
<tr><td>
<div nowrap><span class="dd">
{if $language eq 'rus'}обновление{else}last update{/if}</span></td><td style='padding-left: 4px;'>
 {$faq.faq_update}</div>
 </td></tr></table>

</td></tr></table>
	
	
</td>
</tr></table>
*}








<table width=100%><tr>
<td style="FONT-SIZE: 1.2em;">1.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}О проекте{else}About project{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
<b>ZXTUNES</b> - это крупнейшая в мире коллекция музыки для компьютера ZX Spectrum.
Основное внимание в коллекции уделено «чиповой» музыке, музыке написанной под музыкальный сопроцессор спектрума
 <b>AY-3-8910</b> / <b>YM2149</b>.<br><br> Так же в коллекции представлена однобитная музыка под <b>Beeper</b> и 8-битная, так называемая <b>Digital</b> музыка.<br><br>
 
А еще <b>ZXTUNES</b> - это огромная <a class=d2 href="authors_list.php">база данных</a> по спектрумовским музыкантам.
{else}
<b>ZXTUNES</b> it is world's biggest <b>ZX Spectrum</b> music collection. The basic attention in a collection is given «<b>chip music</b>», music written under the musical coprocessor of a <b>ZX Spectrum</b> <b>AY-3-8910</b> / <b>YM2149</b>.<br><br>

As one-bit music is presented to collections under <b>Beeper</b> and 8-bit, so-named <b> Digital </b> music also. <br><br>
And still ZXTUNES it is a huge <a class=d2 href="authors_list.php">database</a> on zx spectrum musicians.
{/if}
</div><br><br></td></tr>



<td style="FONT-SIZE: 1.2em;">2.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Прослушивание музыки{else}Listening of music{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
 Музыку с сайта <b>ZXTUNES</b> можно слушать в простом и удобном проигрывателе <a class=d2 href="/software.php?id=20">ZX Spectrum Sound Chip Emulator</a>.
{else}
To play music downloaded from <b>ZXTUNES</b>, you can use simple and convenient the <a class=d2 href="/software.php?id=20">ZX Spectrum Sound Chip Emulator</a>.
{/if}
</div><br><br></td></tr>


	  
<td style="FONT-SIZE: 1.2em;">3.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Скачивание файлов{else}Downloads{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
Докачка и скачивание файлов в несколько потоков не поддерживается.
{else}
Downloading in some threads is not supported.
{/if}
</div><br><br></td></tr>
	  
	  
<td style="FONT-SIZE: 1.2em;">4.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Правовая информация{else}Disclaimer{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
Права на музыку принадлежат только ее авторам. Если вы желаете использовать музыку с сайта <b>ZXTUNES</b> в коммерческих целях, обязательно свяжитесь с ее автором или <a class=d2 href="informer.php">администрацией</a> сайта. 

{else}
To use tunes, downloaded from ZXTUNES, for commercial purposes,
you should get explicit permission from their respective composers or <a class=d2 href="informer.php">site admin</a>.
{/if}
</div><br><br></td></tr>
 
 
<td style="FONT-SIZE: 1.2em;">5.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Авторство{else}Credits{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
Идея, разработка и поддержка проекта <b>ZXTUNES</b> - <b>Newart</b> (<b>Калинин Вячеслав</b>).
{else}
Idea, development and support of the project <b>ZXTUNES</b> - <b>Newart</b> (<b>Vyacheslav Kalinin</b>).
{/if}
</div><br><br></td></tr>
  
  
<td style="FONT-SIZE: 1.2em;">6.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Технологии{else}Technologies{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
Код сайта написан на <b>PHP + MySQL + Smarty template engine</b>.
{else}
The code of a site is written on <b>PHP + MySQL + Smarty template engine</b>.
{/if}
</div><br><br></td></tr>




   
<td style="FONT-SIZE: 1.2em;">7.</td><td style="FONT-SIZE: 1.2em;">{if $language eq 'rus'}Благодарности{else}Thanks{/if}</td></tr>

<tr>
<td></td><td>
<div style="FONT-SIZE: 1.3em; padding-top: 4px;">
{if $language eq 'rus'}
За отличный хостинг - <b>untergrund.net</b><br><br>

За помощь в становлении сайта: <b>Nyuk</b> (Andrew Marinov), <b>MD</b> (Roman Borokhov)<br><br>

За консультации по MySql: <b>moroz1999</b>, <b>Paulmory</b><br><br>

За конкуренцию, <b>AY Emulator</b> и <b>Vortex Tracker</b> - <b>Sergey Bulba</b><br><br>

За музыку и информацию о музыкантах: <b>Striker</b>, <b>AAA</b>, <b>Sergey Bulba</b>, <b>Kyv</b>, <b>Research</b>, <b>Kasik</b>, <b>Creator</b>, <b>Jedius</b>, <b>Orion</b>, <b>Risk</b>, <b>Kej-Jee</b>, <b>Voxel</b>, <b>Hedj</b>, <b>Vodoley</b>, <b>Fixxar</b>, <b>Flying</b>, <b>Flyer</b>, <b>VVS</b>, <b>Alone Coder</b>, <b>Dman</b>, <b>Demonik</b>, <b>Nik-O</b>, <b>Alex Raider</b>, <b>PSB</b>, <b>FK0</b>, <b>Qjeta</b>, <b>Scalex</b>, <b>Factor6</b>, <b>CI5</b>, <b>Himik</b>, <b>Ice'Di</b>, <b>Diver</b>, <b>MmcM</b>, <b>Wlodek Black</b>, <b>Yerzmyey</b>, <b>Gasman</b>, <b>Karbofos</b>, <b>Soundliner</b>, <b>Kurles</b>, <b>Brom</b>, <b>Midnight</b>, <b>Quasar</b>, <b>MoNaRcH</b>, <b>Eazy</b>, <b>Ferrum</b>, <b>G.R.</b>, <b>Smont</b>, <b>Sinus</b>, <b>Fox Fluffy's</b>, <b>Breeze</b>, <b>Surfin Bird</b>, <b>Pawel</b>, <b> Nuts</b>, <b>Dic</b>, <b>Golden Max</b>, <b>Klim</b>, <b>Scorpion</b>, <b>Titus</b>, <b>Ironfist</b>, <b>Znahar</b>, <b>Slider</b>, <b>Hunter</b>, <b>MAS</b>, <b>Velesoft</b>, <b>Project AY</b>.<br><br>

И, конечно, огромная благодарность всем спектрумовским музыкантам за вашу музыку и за то, что вы есть!! :)
{else}
For an excellent hosting - <b>untergrund.net</b><br><br>

For the help in becoming a site: <b>Nyuk</b> (Andrew Marinov), <b>MD</b> (Roman Borokhov)<br><br>

For consultations on MySql: <b>moroz1999</b>, <b>Paulmory</b><br><br>

For a competition, <b>AY Emulator</b> и <b>Vortex Tracker</b> - <b>Sergey Bulba</b><br><br>

For music and the information on musicians: <b>Striker</b>, <b>AAA</b>, <b>Sergey Bulba</b>, <b>Kyv</b>, <b>Research</b>, <b>Kasik</b>, <b>Creator</b>, <b>Jedius</b>, <b>Orion</b>, <b>Risk</b>, <b>Kej-Jee</b>, <b>Voxel</b>, <b>Hedj</b>, <b>Vodoley</b>, <b>Fixxar</b>, <b>Flying</b>, <b>Flyer</b>, <b>VVS</b>, <b>Alone Coder</b>, <b>Dman</b>, <b>Demonik</b>, <b>Nik-O</b>, <b>Alex Raider</b>, <b>PSB</b>, <b>FK0</b>, <b>Qjeta</b>, <b>Scalex</b>, <b>Factor6</b>, <b>CI5</b>, <b>Himik</b>, <b>Ice'Di</b>, <b>Diver</b>, <b>MmcM</b>, <b>Wlodek Black</b>, <b>Yerzmyey</b>, <b>Gasman</b>, <b>Karbofos</b>, <b>Soundliner</b>, <b>Kurles</b>, <b>Brom</b>, <b>Midnight</b>, <b>Quasar</b>, <b>MoNaRcH</b>, <b>Eazy</b>, <b>Ferrum</b>, <b>G.R.</b>, <b>Smont</b>, <b>Sinus</b>, <b>Fox Fluffy's</b>, <b>Breeze</b>, <b>Surfin Bird</b>, <b>Pawel</b>, <b> Nuts</b>, <b>Dic</b>, <b>Golden Max</b>, <b>Klim</b>, <b>Scorpion</b>, <b>Titus</b>, <b>Ironfist</b>, <b>Znahar</b>, <b>Slider</b>, <b>Hunter</b>, <b>MAS</b>, <b>Velesoft</b>, <b>Project AY</b>.<br><br>
 
And certainly huge gratitude all spectrum mans to musicians for your music and that you are!! :)
{/if}
</div><br><br></td></tr>
</table>


<a name="question"></a>
<br>
<br>


	  

<table>
<form method="POST" action="sendinfo.php">

{if $ert}<tr><td></td><td style="COLOR: red;">{$ert}<br></td></tr>{/if}



<tr><td></td><td valign=top><div style="FONT-SIZE: 1.4em;"> 
<b>{if $language eq 'rus'}- Есть вопрос?{else}- Have A Question?{/if}</b></div><br></td><td>

<tr><td valign=top><b>{if $language eq 'rus'}имя{else}name{/if}: </b>*</td><td>
<input type="text" name="user_name" value="{$user_name}" maxlength="32" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}почта{else}e-mail{/if}:</b></td><td>
<input type="text" name="user_email" value="{$user_email}" maxlength="32" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}сайт{else}site{/if}:</b></td><td>
<input type="text" name="user_site" value="{$user_site}" maxlength="32" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}сообщение{else}message{/if}: </b>*</td>
<td><textarea type="text" name="message" cols="65" rows="5" style="font-family: arial; font-size: 11px">{$message}</textarea></td></tr>





<tr>
<td><img src="confirm_code.php?cc={$cc}" alt="" title=""></td><td>
<input type="text" class="post" style="width: 90px" name="confirm_code" size="2" maxlength="2" value="">&nbsp&nbsp&nbsp<input type="submit" name="submit" value="{if $language eq 'rus'}отправить{else}submit{/if}"></td>
</tr>
<tr><td></td><td colspan=2><br>* <b>- {if $language eq 'rus'}обязательно{else}necessarily{/if}</b></td></tr>
<input type="hidden" name="confirm_id" value="{cc$}">
<input type="hidden" name="mode" value="faq">

</form>
</table>
	  
	  
	  
	  
     	  
{include file="right_strip.tpl"}



{include file="footer.tpl"}