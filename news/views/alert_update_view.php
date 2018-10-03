<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

$update = new Update();

if($update->checkNewVersion($PNSL["system"]["version"])){
	header('Content-Type: application/xml; charset=utf-8');
	$xml = new DomDocument('1.0','utf-8');
	$DOCUMENT = $xml->appendChild($xml->createElement('DOCUMENT'));

	$PNSL["lang"]["str"]["update_warning"] = str_replace('%SCRIPTNAME%', $PNSL["lang"]["script"]["name"], $PNSL["lang"]["str"]["update_warning"]);
	$PNSL["lang"]["str"]["update_warning"] = str_replace('%VERSION%', $update->getVersion(), $PNSL["lang"]["str"]["update_warning"]);
	$PNSL["lang"]["str"]["update_warning"] = str_replace('%CREATED%', $update->getCreated(), $PNSL["lang"]["str"]["update_warning"]);
	$PNSL["lang"]["str"]["update_warning"] = str_replace('%DOWNLOADLINK%', $update->getDownloadLink(), $PNSL["lang"]["str"]["update_warning"]);
	
	$warning = $DOCUMENT->appendChild($xml->createElement('warning'));
	$warning->appendChild($xml->createTextNode($PNSL["lang"]["str"]["update_warning"]));	

	echo $xml->saveXML();
}

?>