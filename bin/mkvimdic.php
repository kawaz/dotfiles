<?php
$keywords = array(
  'if', 'else', 'elseif', 'endif', 'while', 'endwhile', 'do', 'as', 'for', 'endfor', 'foreach', 'endforeach',
  'break', 'continue', 'switch', 'endswitch', 'case', 'default', 'declare', 'enddeclare',
  'try', 'catch', 'return', 'exit', 'const', 'class', 'function',
  'require', 'include', 'require_once', 'include_once',
  'global',
  'abstract', 'final', 'interface', 'private', 'protected', 'public', 'static',
  '__LINE__', '__FILE__', '__DIR__', '__FUNCTION__', '__CLASS__', '__METHOD__', '__NAMESPACE__',
);

$global_vars = array('GLOBALS', '_SERVER', '_GET', '_POST', '_FILES', '_REQUEST', '_COOKIE', '_SESSION', '_ENV', 'argc', 'argv');

$server_vars = array(
  'DOCUMENT_ROOT', 'HTTP_ACCEPT', 'HTTP_ACCEPT_CHARSET', 'HTTP_ACCEPT_ENCODING', 'HTTP_ACCEPT_LANGUAGE',
  'HTTP_CONNECTION', 'HTTP_COOKIE', 'HTTP_HOST', 'HTTP_USER_AGENT', 'HTTP_X_FORWARDED_FOR',
  'HTTP_X_FORWARDED_PORT', 'HTTP_X_FORWARDED_PROTO', 'PHP_SELF', 'QUERY_STRING', 'REMOTE_ADDR',
  'REMOTE_PORT', 'REQUEST_METHOD', 'REQUEST_TIME', 'REQUEST_URI', 'SCRIPT_FILENAME', 'SCRIPT_NAME',
  'SERVER_ADDR', 'SERVER_ADMIN', 'SERVER_NAME', 'SERVER_PORT', 'SERVER_PROTOCOL',
);

$functions  = function_exists( 'get_defined_functions'   ) ? get_defined_functions()   : array();
$constants  = function_exists( 'get_defined_constants'   ) ? get_defined_constants()   : array();
$interfaces = function_exists( 'get_declared_interfaces' ) ? get_declared_interfaces() : array();
$classes    = function_exists( 'get_declared_classes'    ) ? get_declared_classes()    : array();

$arrays = array_merge(
  $keywords,
  $functions['internal'],
  //  array_keys( $constants ),   // 定数を補完したい場合はこの行を有効にする
  $interfaces,
  $classes
);
sort($arrays);
$arrays = array_unique($arrays);
foreach($arrays as $k) {
  echo "$k\n";
}
