<?php
require 'ini.php';






//error_reporting(E_ALL | E_STRICT);

$smarty->assign('goto', $_REQUEST['goto']);

function geturl($i){}


$z = mysqli_query($db,"SELECT id,nickname,city FROM muzx_authors ORDER BY nickname" );
while ($t = mysqli_fetch_array($z)) {
  
	$m[] = $t;
		
}
$smarty->assign('musicians', $m);

include "right_strip.php";  	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	

// ВЫХОД
if ($_REQUEST['goto'] == 'hell') {

	zxtunes_logout();

}// АКТИВАЦИЯ ЛОГИНА
elseif ($_REQUEST['goto'] == 'start') {

	//mysql_query ("DELETE FROM users WHERE activation='0' AND UNIX_TIMESTAMP() - UNIX_TIMESTAMP(date) > 3600");


	$code  = htmlspecialchars($_GET['code'] ?? '');
	$login = htmlspecialchars(trim($_GET['login'] ?? ''));


	$myrow = db_fetch_one('SELECT id FROM users WHERE login=? AND activation=0 LIMIT 1', 's', [$login]);

	$activation = $myrow ? md5($myrow['id']).md5($login) : '';

	if ($myrow && hash_equals($activation, $code)) {
		
		db_execute('UPDATE users SET activation=1 WHERE login=? LIMIT 1', 's', [$login]);
		
		$_SESSION['error'] = 163;
		header("Location: /makelove.php");
		exit;
		
	}
	else {
	
		$_SESSION['error'] = 122;
		header("Location: /makelove.php");
		exit;
			
	}

	
}// СОЗДАНИЕ НОВОГО ПАРОЛЯ
elseif ($_REQUEST['goto'] == 'totalrecall' and $_REQUEST['submit'] == "Отправить") {

	csrf_verify();

	$smarty->assign('login', $_POST['login'] ?? '');
	$smarty->assign('email', $_POST['email'] ?? '');

	$login = htmlspecialchars(trim($_POST['login'] ?? ''));
	$email = htmlspecialchars(trim($_POST['email'] ?? ''));
	
	
	$myrow = db_fetch_one(
		'SELECT id FROM users WHERE login=? AND email=? AND activation=1 LIMIT 1',
		'ss',
		[$login, $email]
	);
	
	if (empty($myrow['id'])) {
		
		$_SESSION['error'] = 1;
		header("Location: /makelove.php?goto=totalrecall");
		exit;
	
	}
	
	require 'email.inc';
	
	$datenow = date('YmdHis');
	$new_password = substr(md5($datenow), 2, 6);	
	$new_password_sh = zxtunes_hash_password($new_password);
	db_execute('UPDATE users SET password=? WHERE login=? LIMIT 1', 'ss', [$new_password_sh, $login]);
		
	$message = "Здравствуйте, ".$login."! \n\nМы сгененриоровали для Вас новый пароль. \nПосле входа желательно его сменить. \n\nПароль: ".$new_password."\n\nАдминистрация www.zxtunes.com";;
		
	send_email($_POST['email'], $_POST['login'], "Восстановление пароля", $message);
				
	$_SESSION['error'] = 124;
			
	header("Location: /makelove.php");
	exit;
	
}
elseif ($_REQUEST['goto'] == 'alterego' and ($_REQUEST['new_password'] or $_FILES['avatar_upload']['name'])) {

	csrf_verify();
	if (!login()) {
		header("Location: /makelove.php");
		exit;
	}

	require 'avatar.inc';
	
	$avatar = avatar($_SESSION['id']);
	$user_id = (int) $_SESSION['user_id'];

	if ($_REQUEST['new_password'] and $avatar) {
		$password = zxtunes_hash_password($_REQUEST['new_password']);
		db_execute('UPDATE users SET password=?, avatar=? WHERE id=? LIMIT 1', 'sii', [$password, $avatar, $user_id]);
	}
	elseif ($_REQUEST['new_password']) {
		$password = zxtunes_hash_password($_REQUEST['new_password']);
		db_execute('UPDATE users SET password=? WHERE id=? LIMIT 1', 'si', [$password, $user_id]);
	}
	elseif ($avatar) {
		db_execute('UPDATE users SET avatar=? WHERE id=? LIMIT 1', 'ii', [$avatar, $user_id]);
	}
	
	header("Location: /makelove.php?goto=alterego");
	exit;

}
elseif ($_REQUEST['goto'] == 'push' and $_REQUEST['submit'] == "Войти") {

	csrf_verify();

	$login_name = trim($_POST['login'] ?? '');
	$plain_password = $_POST['password'] ?? '';
	$remember = !empty($_POST['autologin']);

	$myrow = zxtunes_login_by_credentials($login_name, $plain_password);
		
		if (!$myrow) {

	
			$ip=getenv("HTTP_X_FORWARDED_FOR");
			if (empty($ip) || $ip=='unknown') { $ip=getenv("REMOTE_ADDR"); }

			mysqli_query($db, "DELETE FROM oshibka WHERE UNIX_TIMESTAMP() - UNIX_TIMESTAMP(date) > 300");

			$osh = db_fetch_one('SELECT col FROM oshibka WHERE ip=? LIMIT 1', 's', [$ip]);
	
			if (($osh['col'] ?? 0) >= 5) {
			
				$_SESSION['error'] = 5;
				header("Location: /makelove.php");
				exit;
			
			}
	
			if ($osh) {
				db_execute('UPDATE oshibka SET col=col+1, date=NOW() WHERE ip=?', 's', [$ip]);
			} else {
				db_execute('INSERT INTO oshibka (ip, date, col) VALUES (?, NOW(), 1)', 's', [$ip]);
			}
			
			$_SESSION['error'] = 3;


		}
		else {
    
			zxtunes_set_session_user($myrow);
			if ($remember) {
				zxtunes_set_remember_cookie($myrow);
			}
			header("Location: /makelove.php");
			exit;
			
			
		}	
	

}// РЕГИСТРАЦИЯ
elseif ($_REQUEST['goto'] == 'stargate' and $_REQUEST['submit'] == "Зарегистрироваться") {
	
	csrf_verify();

	$author_id = intval($_POST['author_id'] ?? 0);
	$email = htmlspecialchars(trim($_POST['email'] ?? ''));
	$login_name = trim($_POST['login'] ?? '');
	$plain_password = $_POST['password'] ?? '';

	if (strlen($login_name) < 3 or strlen($login_name) > 15 or strlen($plain_password) < 3 or strlen($plain_password) > 15 or !preg_match("/[0-9a-z_]+@[0-9a-z_^\.]+\.[a-z]{2,3}/i", $email)) {

		$_SESSION['error'] = 4;

	}
	else {

		$password = zxtunes_hash_password($plain_password);

		$existing = db_fetch_one('SELECT id FROM users WHERE login=? LIMIT 1', 's', [$login_name]);
	
		if (!empty($existing['id'])) {

			$_SESSION['error'] = 6;

		}
		else {

			$tm = time();
			$avatar = 0;
			if (db_execute(
				'INSERT INTO users (login, password, avatar, email, date, author_id) VALUES (?, ?, ?, ?, ?, ?)',
				'ssisii',
				[$login_name, $password, $avatar, $email, $tm, $author_id]
			)) {
				$new_user = db_fetch_one('SELECT id FROM users WHERE login=? LIMIT 1', 's', [$login_name]);
				$activation = md5($new_user['id']).md5($login_name);

				
				
				$subj = "Подтверждение регистрации";
				$message = "Здравствуйте, $login_name!\n\nБлагодарим за регистрацию на www.zxtunes.com\n\nЧтобы  активировать ваш аккаунт, перейдите по ссылке:\n\n/makelove.php?goto=start&login=".rawurlencode($login_name)."&code=".$activation."\n\nАдминистрация www.zxtunes.com";

				require 'email.inc';
			
				if (!send_email($email, $login_name, $subj, $message)) {
			
					$_SESSION['error'] = 100;
					header("Location: /makelove.php?goto=stargate");
					exit;
				
				}
				else {
			
					$_SESSION['error'] = 10;
	
				}

			}
			else {

				$_SESSION['error'] = 7;

			}	
		}
	}
}





// NO LOGIN, FUCKYOU!
if ($_REQUEST['goto'] == 'alterego' and !login()) {

	header("Location: /makelove.php");
	exit;

}











if (login()) {
	$myrow = db_fetch_one(
		'SELECT * FROM users WHERE id=? AND activation=1 LIMIT 1',
		'i',
		[(int) $_SESSION['user_id']]
	);
}

if (!empty($myrow['id'])) {

	$smarty->assign('user', $myrow);
	
}


$smarty->assign('error', $_SESSION['error']);
unset($_SESSION['error']);

$smarty->display('login.tpl');
?>