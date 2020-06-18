<?php

$server_id = 'pod_alias';

$hmac_secret = 'secret';
$timestamp = (string) round(microtime(true) * 1000);
$connection = 'testhost';
$protocol = 'rdp';
$port = 3389;

$hmac_message = $timestamp.
	'id'.$server_id.
	'connection'.$connection.
	'protocol'.$protocol.
	'port'.$port;

$signature = base64_encode(
	hash_hmac('sha1', $hmac_message, $hmac_secret, true)
);

$urlPrefix = 'https://localhost:8443';

$client = $connection . "\0" . 'c' . "\0" . 'hmac';

$url = $urlPrefix . '/#/client/' . base64_encode($client) . '?' .
	'&timestamp=' . $timestamp .
	'&connection=' . $connection .
	'&signature=' . urlencode($signature);

echo $url;