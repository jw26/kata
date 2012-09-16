package bankocr

import (
  "testing"
  "fmt"
)

func TestOutputOfIllErr(t *testing.T) {
  input := [][]int {
    []int {1,2,3,4,5,6,7,8,9},
    []int {-1,2,3,4,5,6,7,8,9},
    []int {9,8,7,6,5,4,3,2,1},
  }
  expected := []string {
    "123456789",
    "?23456789 ILL",
    "987654321 ERR",
  }

  got := []string {}
  for _, v := range input {
    got = append(got, prepare_for_output(v))
  }

  if fmt.Sprintf("%v", expected) != fmt.Sprintf("%v", got) {
    t.Errorf("verification failed %v != %v",expected,got)
  }
}

func TestVerification(t *testing.T) {
  input := [][]int {
    []int {1,2,3,4,5,6,7,8,9},
    []int {-1,2,3,4,5,6,7,8,9},
    []int {0,0,0,0,0,0,0,5,1},
    []int {7,7,7,7,7,7,1,7,7},
    []int {9,9,3,9,9,9,9,9,9},
    []int {9,8,7,6,5,4,3,2,1},
  }

  expected := []bool {true, false, true, true, true, false}

  got := []bool {}
  for _, v := range input {
    got = append(got, verifies(v))
  }

  if fmt.Sprintf("%v", expected) != fmt.Sprintf("%v", got) {
    t.Errorf("verification failed %v != %v",expected,got)
  }
}

func TestMoreThanOneFullCode(t *testing.T) {
  input :=
`
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

`

  expected := [][]int {[]int {1,2,3,4,5,6,7,8,9}, []int{1,2,3,4,5,6,7,8,9}}

  got := parse(input)

  if fmt.Sprintf("%v", expected) != fmt.Sprintf("%v", got) {
    t.Errorf("couldnt parse a couple of codes %v != %v",expected,got)
  }
}

func TestReadBadCode(t *testing.T) {
  input :=
`
    _  _     _     _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

`

  expected := [][]int {[]int{1,2,3,4,5,-1,7,8,9}}

  got := parse(input)

  if fmt.Sprintf("%v", expected) != fmt.Sprintf("%v", got) {
    t.Errorf("couldnt parse a single code")
  }
}
