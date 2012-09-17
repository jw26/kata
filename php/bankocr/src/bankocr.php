<?php
namespace bankocr;

function validate($code) {
  $r = array();
  for($i=0;$i<count($code);$i++) {
    if(-1 == $code[$i]) {
      return false;
    }
    $r []= ($i+1)*$code[$i];
  }
  return (array_reduce($r, function($acc,$i) { return $acc+$i; }) % 11) !== 0;
}

function lookup($char) {
  $lookup = array(
    " _ | ||_|" => 0, "     |  |" => 1,
    " _  _||_ " => 2, " _  _| _|" => 3,
    "   |_|  |" => 4, " _ |_  _|" => 5,
    " _ |_ |_|" => 6, " _   |  |" => 7,
    " _ |_||_|" => 8, " _ |_| _|" => 9,
  );
  return $lookup[$char];
}

function codes($in) {

  $chars = array();

  for($i=0; $i<9; $i++) {
    $char = substr($in[0],0,3);
    $char .= substr($in[1],0,3);
    $char .= substr($in[2],0,3);
    $chars []= lookup($char);

    $in[0] = substr($in[0],3);
    $in[1] = substr($in[1],3);
    $in[2] = substr($in[2],3);
  }

  return array($chars);
}

function line($in, $acc) {
  if(count($in)) {
    return line(array_slice($in,3), array_merge($acc,codes(array_slice($in,0,3))));
  } else {
    return $acc;
  }
}

function parse($in) {
  $splut = explode("\n",$in);
  $unblanked = array_filter($splut, function ($a) { return $a != ""; });
  return line($unblanked,array());
}
