<?php
/*
    This is the PHP-Side of the bridge. It connects the user to your binary.
*/
$config = require 'config.php';
$basePath = $config['base_path'];
$fullPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$normalizedPath = '/' . ltrim(preg_replace('#^' . preg_quote($basePath, '#') . '#', '', $fullPath), '/');

$payload = json_encode([
    'path' => $normalizedPath,
    'method' => $_SERVER['REQUEST_METHOD'],
    'query'  => (object)$_GET,
    'post'   => (object)$_POST,
    'body'   => file_get_contents('php://input'),
    'headers' => getallheaders(),
]);

$descriptorspec = [
    0 => ['pipe', 'r'],  // stdin
    1 => ['pipe', 'w'],  // stdout
];
$process = proc_open($config["server_binary_path"], $descriptorspec, $pipes);

if (is_resource($process)) {
    fwrite($pipes[0], $payload);
    fclose($pipes[0]);

    $output = stream_get_contents($pipes[1]);
    fclose($pipes[1]);

    proc_close($process);

    $response = json_decode($output, true);

    if (json_last_error() === JSON_ERROR_NONE && is_array($response)) {
        // Set status code
        http_response_code($response['status'] ?? 200);

        // Set headers
        if (!empty($response['headers']) && is_array($response['headers'])) {
            foreach ($response['headers'] as $key => $value) {
                header("$key: $value");
            }
        }

        // Print body
        echo $response['body'] ?? '';
    } else {
        http_response_code(500);
        echo "Invalid response from binary.";
    }
} else {
    http_response_code(500);
    echo "Failed to start binary.";
}
