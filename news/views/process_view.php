<?php

/********************************************
* PHP Newsletter 4.0.7 beta
* Copyright (c) 2006-2014 Alexander Yanitsky
* Website: http://janicky.com
* E-mail: janickiy@mail.ru
* Skype: janickiy
********************************************/

header('Content-Type: application/xml; charset=utf-8');
$xml = new DomDocument('1.0','utf-8');
$DOCUMENT = $xml->appendChild($xml->createElement('DOCUMENT'));
		
$process = $DOCUMENT->appendChild($xml->createElement('process'));

$result = $data->updateProcess();

if($result)
	$process->appendChild($xml->createTextNode($_GET['status']));
	
else
	$process->appendChild($xml->createTextNode('no'));
	
echo $xml->saveXML();	

?>