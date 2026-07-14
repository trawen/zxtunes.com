{include file="menu.tpl"}

<script type="text/javascript" src="css/jquery.js"></script>


<div class="zx-login-wrap">

{if $goto EQ "stargate"}



{if $error EQ 100}
<p style="color: red">Для завершения регистрации перейдите по коду высланному на E-Mail.</p>
{else}

{if $error EQ 6}
<p style="color: red">Такой логин уже занят!</p>
{elseif $error EQ 4}
<p style="color: red">Логин или пароль недопустимой длинны!</p>
{elseif $error EQ 9}
<p style="color: red">Проверочный код введен неверно!</p>
{elseif $error EQ 10}
<p style="color: red">Ошибка при отправке E-Mail!</p>
{elseif $error EQ 7}
<p style="color: red">Произошла неивестная ошибка!</p>
{/if}


<div class="zx-split">

<div class="zx-split__panel">
<div style="font: normal 17px Verdana; letter-spacing: 2px">Регистрация</div>

<form class="zx-form-stack" method="post" enctype="multipart/form-data">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
Логин  <br> <input style="border: 1px solid #ccc; width: 140px" name="login" type="text" size="16" maxlength="15" value="{$login}">
</p>

  
<p>
Пароль <br> <input style="border: 1px solid #ccc; width: 140px"  name="password" type="text" size="16" maxlength="15" value="{$password}">
</p>

  
<p>
E-mail  <br> <input style="border: 1px solid #ccc; width: 140px"  name="email" type="text" size="16" maxlength="100" value="{$email}">
</p>

<p id="klik">
Я музыкант  <input style="border: 1px solid #ccc;" type="checkbox" onclick="$('#klik').hide();$('#author').show()">
</p>

<p id="author" style="display: none">
Я этот музыкант <br>

<select style="border: 1px solid #ccc; width: 138px" name="author_id">
<option value="0"></option>
{section name=n loop=$musicians}
<option value="{$musicians[n].id}">{$musicians[n].nickname} &nbsp; {if $musicians[n].city}({$musicians[n].city}){/if}</option>
{/section}
</select>

</p>

</b>
  

<input type="submit" name="submit" value="Зарегистрироваться">

</form>

<br>

<p><a class="magn" href="makelove.php">Войти</a></p>
<p><a class="magn" href="makelove.php?goto=totalrecall">Забыли пароль?</a></p>
</div>

<div class="zx-split__sep"></div>

<div class="zx-split__panel" style="line-height: 18px">

<p><b>Благодаря регистрации вы сможете:</b></p>

<p>Составлять личные плейлисты, слушать их и делиться с другими пользователями.</p>

<p>Редактировать свою страничку и загружать новые треки (если вы музыкант).</p>

<p>Что-нибудь такое, что мы еще не придумали... </p>
</div>

</div>

{/if}










{elseif $goto EQ "totalrecall"}




{if $error}<p style="color: red">Такой логин или e-mail не значится в нашей базе!</p>{/if}


<div style="font: normal 17px Verdana; letter-spacing: 0px">Востановление пароля</div>

<form class="zx-form-stack" method="post">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
Логин <br> <input style="border: 1px solid #ccc; width: 140px" type="text" name="login" value="{$login}">
</p>

<p>
E-mail <br> <input style="border: 1px solid #ccc; width: 140px" type="text" name="email" value="{$email}">
</p>
</b>

<input type="submit" name="submit" value="Отправить">
</form>

<br>

<p><a class="magn" href="makelove.php">Войти</a></p>
<p><a class="magn" href="makelove.php?goto=stargate">Зарегистрироваться</a></p>












{elseif $goto EQ "alterego"}

<form class="zx-form-stack" method="post" enctype="multipart/form-data">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<input type="hidden" name="goto" value="{$goto}">

<a class="cian" href='makelove.php?goto=alterego'>Моя страница</a> | <a class="magn" href='makelove.php'>Главная страница</a> <!--| <a class="magn" href='makelove.php?goto=hellall_users.php'>Список пользователей</a> -->| <a class="magn" href='makelove.php?goto=hell'>Выход</a><br><br>

Добро пожаловать, <b>{$user.login}</b>!<br><br>

{if $user.avatar}<img alt='newart' src='avatars/{$user.id}.png'>{/if}

<br><br>


<p>Сменить пароль: <br><br> <input name="new_password" type="text" size="15" maxlength="15"></p>

<br>
  
<p>
Сменить аватар:<br> (изображение должно быть формата jpg, gif или png) <br><br> <input style="background-color: white" type="file" name="avatar_upload">
</p>

<br>



<input type="submit" name="submit" value="Отправить">

</form>












{else}


	{if $user.id}

<a class="magn" href='makelove.php?goto=alterego'>Моя страница</a> | <a class="cian" href='makelove.php'>Главная страница</a> <!-- <a class="magn" href='makelove.php?goto=hellall_users.php'>Список пользователей</a> --> | <a class="magn" href='makelove.php?goto=hell'>Выход</a><br><br>




Добро пожаловать, <b>{$user.login}</b>!<br>



<br>

{if $user.avatar}<img alt='newart' src='avatars/{$user.id}.png'>{/if}












	{else}

	

{if $error EQ 124}
<p style="color: red">Новый пароль отправлен на указанный E-Mail.</p>
{elseif $error EQ 122}
<p style="color: red">Ошибка активации!</p>
{elseif $error EQ 163}
<p style="color: red">Ваш Е-мейл подтвержден! Теперь вы можете зайти на сайт под своим логином.</p>
{elseif $error}
<p style="color: red">Неверный логин или пароль!</p>
{/if}	

{if $error EQ 5}
<p style="color: red">Вы превысили количество неудачных попыток входа. Попробуйте снова через 5 минут.</p>

{else}
<div style="font: normal 17px Verdana; letter-spacing: 2px">Вход</div>
	
<form class="zx-form-stack" method="post">
<input type="hidden" name="_csrf" value="{$csrf_token}">

<b>
<p>
Логин <br> <input style="border: 1px solid #ccc; width: 140px"  name="login" type="text" size="15" maxlength="15" value="">
</p>

<p>
Пароль <br> <input style="border: 1px solid #ccc; width: 140px"  name="password" type="text" size="15" maxlength="15" value="">  
</p>
</b>

<!--<p><input name="auto" type="checkbox" value='1'> Запомнить меня</p>-->

<p>
<input type="hidden" name="goto" value="push">
<input type="submit" name="submit" value="Войти">
</p>

</form>
{/if}


<br>

<p><a class="magn" href="makelove.php?goto=stargate">Зарегистрироваться</a></p>
<p><a class="magn" href="makelove.php?goto=totalrecall">Забыли пароль?</a></p>

	
	{/if}

{/if}

</div>

{include file="right_strip.tpl"}

{include file="footer.tpl"}
