{include file="menu.tpl"}
 
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

<center>
{if $language eq 'rus'}
	{if $error EQ 1}
	<p style="color: red">Благодарим за поддержку!</p>
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










<div style="padding: 32px; font: normal 14px Verdana; line-height: 170%" align=left>
<H1>Ретро-лихорадка</H1>

<big style="color: red"><b>ОБЬЯВЛЯЕМ НАГРАДУ ЗА ДИСКЕТЫ И КАССЕТЫ ДЛЯ СПЕКТРУМА!</b></big>

<br>

<p><img border=1 src="http://kino-govno.com/img/30844.jpg" align=right>
Создатели сайта уже который месяц испытывают на себе действие мощнейшей ретро-ностальгии. Нет, не той ностальгии, которая «Я-то в советские времена — ооо!», а той, что имеет отношение исключительно к старым компьютерам, приставкам и играм для оных.</p><br>


<p>
<b>ZX Spectrum, Atari 130XE, Commodore 64, БК-0011М, Dizzy, Exolon, International Karate, Montezuma's Revenge, «Звёздное наследие», «Клад»...</b> Если эти названия для вас не пустой звук, то вы наверняка поймёте, откуда в сердце людей, живущих в эпоху PlayStation 3, Xbox 360, iPad 2 и iPhone 4, горит любовь к ретро-компьютерам и играм для оных.</p><p><img border=1 src="http://speccy.info/images/thumb/c/c9/Nafanya_Case.jpg/180px-Nafanya_Case.jpg" align=right></p><p>

Но от болтовни к делу.</p><p>

Если у вас где-нибудь на антресолях, в кладовке или прямо на рабочем столе завалялся компьютер производства 70-90-х годов (не PC-совместимый, кому они вообще нужны?) — дайте знать.</p><p>

Нас интересуют как фирменные <b>ZX Spectrum</b>, так и их всевозможные отечественные и не только клоны, разные вариации <b>Commodore, Atari, Amstrad, Enterprise, BBC Micro, MSX</b>, отечественные компьютеры типа <b>БК-0010-01</b> и <b>БК-0011М, «Вектора-Ц», «Агата» и «Микроши»</b>, а также многие-многие другие бытовые компьютеры.</p>

<center><img border=1 src="http://zxpress.ru/img/kassets.jpg"></center>


<br>
<big style="color: red"><b>ОБЬЯВЛЯЕМ НАГРАДУ ЗА ДИСКЕТЫ И КАССЕТЫ ДЛЯ СПЕКТРУМА!</b></big>
<p>
Имеется некоторый интерес и к приставкам того же времени — из тех, что появились ДО PlayStation, но включая <b>Sega Saturn и Nintendo 64</b>. То есть: <b>Денди (NES), SNES, Sega Genesis, Sega Master System, Atari 2600</b> и так далее, и тому подобное.</p>

<img border=1 src="http://speccy.info/images/thumb/7/75/Delta_pcb.jpg/180px-Delta_pcb.jpg" align=right>



<p>

От ретро-литературы — книг, журналов, мануалов по всему вышеперечисленному — тоже не откажемся. «<b>ZX-Ревю</b>» — наше всё, знаете ли.</p>

<img border=1 src="http://zxpress.ru/pictures/20.jpg" width=150 align=right>

<p>
Иными словами — да, «Всеяредакция примет в дар или купит ретро-компьютеры, ретро-игры и ретро-приставки». Доставку возьмём на себя, о цене договоримся, так что смело засылайте на адрес <b>vtcd@mail.ru</b> свои предложения, прикладывайте фотографии своих ретро-аксессуаров — в общем, дайте знать, если вам есть, чем поделиться.</p><p>

С нетерпением ждём.</p><p>

p.s. <b>Spectrum Forever!</b></p><p>

</div>


<hr>


<div align=left>
<center>
<form method="post" enctype="multipart/form-data" onsubmit="return validateEmpty('name', 'email', 'message')">
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
</center>
</div>











	  

     	  
{include file="right_strip.tpl"}

{include file="footer.tpl"}