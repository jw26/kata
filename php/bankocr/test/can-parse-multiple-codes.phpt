--TEST--
--FILE--
<?php
require_once(dirname(dirname(__FILE__)).'/src/bankocr.php');

$input = <<<IN

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

IN;

$got = \bankocr\parse($input);
$got = array_map( function ($a) { return '[' . join($a,',') . ']'; }, $got );
$got = '[' . join($got,',') . ']';

var_dump($got);

?>
--EXPECT--
string(41) "[[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]"
