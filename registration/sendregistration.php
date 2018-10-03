<!DOCTYPE html>
<html lang=ru>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="/styles.css"/>
<title>Проектировщик тротуарной плитки</title>
</head>
<body>
<div class="marginpanel">

<div class="marginpanel">
<div class="titlepanel">
<span style="float : left">Проектировщик тротуарной плитки 2.2</span>
<h1>Регистрация</h1>
</div>
</div>

<div class="marginpanel">
<div class="alonecontentpanel">

<?php 
if (mail('support@paving-expert.com', 'Регистрация', 
        "Имя/название: ".htmlspecialchars($_REQUEST['regname'])."\r\n".
        "email: ".htmlspecialchars($_REQUEST['regemail'])."\r\n".
        "Код запроса: ".htmlspecialchars($_REQUEST['requestcode']),
        'Content-Type: text/plain; charset=utf-8')) 
{
  echo "Запрос на регистрацию отправлен успешно.";
} else {
  echo "Ошибка при отправке запроса. Повторите запрос.";
}  
?>
</div>
</div>

</div>
</body>
</html>
