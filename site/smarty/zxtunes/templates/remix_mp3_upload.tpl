{include file="menu.tpl"}
 
 





<H3>{if $language eq 'rus'}Отправка информации или музыки{else}Submit info or music{/if}</H3>
	
<br><br>	
	
<div style="FONT-SIZE: 1.3em; padding-left: 20px;">
{if $language eq 'rus'}
Имеете информацию о ком-нибудь из музыкантов?<br><br> 
У вас есть неопубликованная на сайте музыка или программа?<br><br> 
Нашли ошибку на сайте?<br><br> 
Есть идеи по улучшению проекта?<br><br> 
Или просто желаете связаться с автором проекта?<br><br> 
{else}
Have the information on somebody from musicians?<br><br>
You have music not published on a site or the program?<br><br>
Have found a mistake on a site?<br><br>
There Are ideas on improvement of the project?<br><br>
Or simply wish to contact the author of the project?<br><br>
{/if}
</div>
<br>


	  

<table>
<form method="POST" action="sendinfo.php" enctype='multipart/form-data'>
<input type="hidden" name="_csrf" value="{$csrf_token}">

{if $ert}<tr><td></td><td style="COLOR: red;">{$ert}<br></td></tr>{/if}




<tr><td valign=top><b>{if $language eq 'rus'}автор ремикса{else}remix author{/if}: </b>*</td><td>
<select name="author_rmx_select">
<option value="">—</option>
{section name=n loop=$rmx_author}
{cycle values=""}
<option value="{$rmx_author[n]}">{$rmx_author[n]}</option>
{/section}
</select>

<input type="text" name="user_name" value="{$user_name}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}автор оригинала{else}original author{/if}:</b></td><td>
<select name="author_org_select">
{section name=n loop=$org_author}
{cycle values=""}
<option value="{$org_author[n].id}">{$org_author[n].name}</option>
{/section}
</select>

</td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}год ремикса{else}remix year{/if}:</b></td><td>
<select name="remix_year">
<option value="0">—</option> 
<option value="2009">2009</option>
<option value="2008">2008</option>
<option value="2007">2007</option>
<option value="2006">2006</option>
<option value="2005">2005</option>
<option value="2004">2004</option>
<option value="2003">2003</option>
<option value="2002">2002</option>
<option value="2001">2001</option>
<option value="2000">2000</option>
<option value="1999">1999</option>
<option value="1998">1998</option>
<option value="1997">1997</option>
<option value="1996">1996</option>
<option value="1995">1995</option>
</select>
</td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}оригинальный AY трек{else}original AY tune{/if}:</b></td><td>
<input type="text" name="user_site" value="{$user_site}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}комментарий{else}comment{/if}: </b>*</td>
<td><input type="text" name="user_site" value="{$user_site}" maxlength="64" size="20"></td></tr>

<tr><td valign=top><b>{if $language eq 'rus'}файл</b>{else}file</b>{/if}: **</td>
<td><input type='file' name='file'></td></tr>





<tr>
<td><img src="confirm_code.php?cc={$cc}" alt="" title="">*</td><td>
<input type="text" class="post" style="width: 90px" name="confirm_code" size="6" maxlength="6" value="">&nbsp&nbsp&nbsp<input type="submit" name="submit" value="{if $language eq 'rus'}отправить{else}submit{/if}"></td>
</tr>
<tr><td></td><td colspan=2><br>* <b>- {if $language eq 'rus'}обязательно{else}necessarily{/if}</b></td></tr>
<tr><td></td><td colspan=2><br>** <b>- {if $language eq 'rus'}до 16 мегабайт{else}up to 16Mb{/if}</b></td></tr>
<input type="hidden" name="mode" value="informer">
<input type="hidden" name="confirm_id" value="{$cc}">


</form>
</table>
	  
	  
	  
	  
     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}