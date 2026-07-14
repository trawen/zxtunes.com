{include file="menu.tpl"}

<script type="text/javascript" src="css/jquery.js"></script>
 
<script>
{literal}
$(document).ready( function () {
{/literal}
	{if $language eq 'rus'}
	var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Отправить'>";
	{else}
	var spam = "<in"+"put type='submit' style='width: 120px' name='submit' value='Send'>";
	{/if}
	
	
{literal}
	$("#spam").html(spam);

});




function validateEmpty() {

	var n = validateEmpty.arguments.length;
	var args = validateEmpty.arguments;
	for(var i=0;i<n;i++) {

	
		if(document.getElementById(args[i]).value != 0 ) {
			
			document.getElementById(args[i]).className = document.getElementById(args[i]).className.replace(" error", "");

		}	

		else {

			document.getElementById(args[i]).focus();
			document.getElementById(args[i]).className += " error";
{/literal}			
			{if $language eq 'rus'}
			
				alert("Пожалуйста заполните поля: 'Ник', 'E-Mail' и 'Сообщение'");
			{else}
				alert("Please fill fields 'Nickname', 'E-Mail' and 'Message'");
			{/if}
			
{literal}			
			return false;

		}
	}
	return true;
}



</script> 
{/literal}

{if $language eq 'rus'}
	{if $error EQ 1}
	<p style="color: red">Благодарствуем за поддержку!</p>
	{elseif $error EQ 2}
	<p style="color: red">Странно, произошла какая-то ошибка, повторите попытку позже.</p>
	{/if}
{else}
	{if $error EQ 1}
	<p style="color: red">Thank you for support!</p>
	{elseif $error EQ 2}
	<p style="color: red">Strangely, there was some error, try again later.</p>
	{/if}
{/if}


<div class="zx-split">

<div class="zx-split__panel">
<div style="font: normal 12px Arial; padding-left: 20px; line-height: 18px;">
{if $language eq 'rus'}

<div style="font: normal 17px Verdana; letter-spacing: 2px">Обратная связь</div><br><br>  
Имеете информацию о ком-нибудь из музыкантов?<br><br> 
Есть неопубликованная на сайте музыка или программа?<br><br> 
Нашли ошибку на сайте?<br><br> 
Есть идеи по улучшению проекта?<br><br> 
Или просто желаете связаться с автором проекта?<br><br> 

{else}

<div style="font: normal 17px Verdana; letter-spacing: 2px">Feedback</div><br><br>  
Have the information on somebody from musicians?<br><br>
You have music not published on a site or the program?<br><br>
Have found a mistake on a site?<br><br>
There Are ideas on improvement of the project?<br><br>
Or simply wish to contact the author of the project?<br><br>

{/if}
</div>
</div>

<div class="zx-split__sep"></div>

<div class="zx-split__panel">
<form class="zx-form-stack" method="post" enctype="multipart/form-data" onsubmit="return validateEmpty('name', 'email', 'message')">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
{if $language eq 'rus'}Ник или имя{else}Nickname{/if}  <br> <input style="border: 1px solid #ccc; width: 220px" name="name" type="text" maxlength="32" id="name">
</p>
  
<p>
E-mail  <br> <input style="border: 1px solid #ccc; width: 220px"  name="email" type="text" maxlength="32" value="{$email}" id="email">
</p>

<p>
{if $language eq 'rus'}Файл{else}File{/if}  <br> <input style="border: 1px solid #ccc; width: 220px"  name="file" type="file">
</p>


<p>
{if $language eq 'rus'}Сообщение{else}Message{/if} <br> 
<textarea type="text" name="message" rows="3" style="border: 1px solid #ccc; width: 220px" id="message"></textarea>
</p>
</b>


<div id="spam"></div>  


</form>
</div>

</div>








	  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}
