--TEST--
--FILE--
<?php
require_once(dirname(dirname(__FILE__)).'/src/bankocr.php');

$input = array(
  array(1,2,3,4,5,6,7,8,9),
  array(-1,2,3,4,5,6,7,8,9),
  array(0,0,0,0,0,0,0,5,1),
  array(7,7,7,7,7,7,1,7,7),
  array(9,9,3,9,9,9,9,9,9),
  array(9,8,7,6,5,4,3,2,1),
);

$expected = array(true, false, true, true, true, false);

$got = array_map(function($i){return \bankocr\validate($i);},$input);

var_dump($got == $expected);

?>
--EXPECT--
bool(true)
