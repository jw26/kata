(ns bankocr.test.core
  (:use [bankocr.core])
  (:use [midje.sweet]))

(def one-to-nine
"
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

")

(def invalid-character
"
    _  _     _     _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

")

(fact "we can convert codes to ints"
  (let [expected (list '(1 2 3 4 5 6 7 8 9) '(1 2 3 4 5 6 7 8 9))]
      (parse (str one-to-nine one-to-nine)) => expected))

(fact "bad numbers are nils"
  (let [expected (list '(1 2 3 4 5 nil 7 8 9))]
      (parse invalid-character) => expected))

(tabular
  (fact "verification behaves as expected"
    (verified? ?code) => ?expected)
  ?code                 ?expected
  '(1 2 3 4 5 6 7 8 9)  true
  '(nil 2 3 4 5 6 7 8 9) false
  '(0 0 0 0 0 0 0 5 1)  true
  '(7 7 7 7 7 7 1 7 7)  true
  '(9 9 3 9 9 9 9 9 9)  true
  '(9 8 7 6 5 4 3 2 1)  false)

(tabular
  (fact "ills and errs get printed"
    (prepare_for_output ?code) => ?expected)
  ?code                   ?expected
  '(1,2,3,4,5,6,7,8,9)    "123456789"
  '(nil,2,3,4,5,6,7,8,9)  "?23456789 ILL"
  '(9,8,7,6,5,4,3,2,1)    "987654321 ERR")
