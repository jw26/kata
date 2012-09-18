--TEST--
--FILE--
<?php
require_once(dirname(dirname(__FILE__)).'/src/bankocr.php');

$input = array(
  array(1,2,3,4,5,6,7,8,9),
  array(-1,2,3,4,5,6,7,8,9),
  array(9,8,7,6,5,4,3,2,1),
);

$expected = array(
  "123456789",
  "?23456789 ILL",
  "987654321 ERR",
);

$got = \bankocr\prepare_for_output($input);

var_dump($got == $expected);

?>
--EXPECT--
bool(true)
