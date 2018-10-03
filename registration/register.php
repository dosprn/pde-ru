<!DOCTYPE html>
<html lang=ru>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="/styles.css"/>
<title>Проектировщик тротуарной плитки</title>
<style type="text/css">
input {
  border-width  : 1px; 
  border-style  : solid;
  border-color  : #E0E0E0;
  padding       : 2px 2px 2px 2px;
  border-radius : 4px 4px 4px 4px;
}
</style>
</head>
<body>
<div class="marginpanel">

<div class="marginpanel">
<div class="titlepanel">
<span style="float : left">Проектировщик тротуарной плитки 2.2</span>
<h1>Запрос регистрации</h1>
</div>
</div>

<div class="marginpanel">
<div class="alonecontentpanel">

<form method="post" enctype="application/x-www-form-urlencoded" action="sendregistration.php">
<p>Имя/название:<br><input name="regname" required size=50 type="text" value="<?php echo htmlspecialchars($_REQUEST['regname'])?>"></p>
<p>email:<br><input name="regemail" size=50 type="email" value="<?php echo htmlspecialchars($_REQUEST['regemail'])?>"></p>
<p>Код запроса:<br><input name="requestcode" required size=50 type="text" value="<?php echo htmlspecialchars($_REQUEST['requestcode'])?>"></p>
<p><input name="submit" type="submit" value="Отправить запрос"></p>
</form>

</div>
</div>
</div>

</body>
</html>
