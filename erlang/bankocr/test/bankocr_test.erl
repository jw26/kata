-module(bankocr_test).
-include_lib("eunit/include/eunit.hrl").

lookup_test_() ->
  {"Should be able to lookup code chars",
    fun() ->
        ?assertEqual(1, bankocr:lookup_char("     |  |")),
        ?assertEqual(3, bankocr:lookup_char(" _  _| _|")),
        ?assertEqual(6, bankocr:lookup_char(" _ |_ |_|"))
    end
  }.

output_illerr_test_() ->
  {"Should prepare output properly",
    fun() ->
        Input = [
          [1,2,3,4,5,6,7,8,9],
          [-1,2,3,4,5,6,7,8,9],
          [9,8,7,6,5,4,3,2,1]],

        Expected = [
          "123456789",
          "?23456789 ILL",
          "987654321 ERR"],

        Got = [bankocr:prepare_output(X) || X <- Input],

        ?assertEqual(Expected,Got)
    end
  }.

validate_test_() ->
  {"Should be able to validate",
    fun() ->
        Input = [
          [1,2,3,4,5,6,7,8,9],
          [-1,2,3,4,5,6,7,8,9],
          [0,0,0,0,0,0,0,5,1],
          [7,7,7,7,7,7,1,7,7],
          [9,9,3,9,9,9,9,9,9],
          [9,8,7,6,5,4,3,2,1]],

        Expected = [true, false, true, true, true, false],

        Got = [bankocr:valid(X) || X <- Input],

        ?assertEqual(Expected,Got)
    end
  }.

parse_test_() ->
  {"Should be able to parse a couple of code lines",
    fun() ->
        Input = string:join(
          ["\n",
           "    _  _     _  _  _  _  _ ",
           "  | _| _||_||_ |_   ||_||_|",
           "  ||_  _|  | _||_|  ||_| _|",
           "\n",
           "    _  _     _  _  _  _  _ ",
           "  | _| _||_||_ |_   ||_||_|",
           "  ||_  _|  | _||_|  ||_| _|",
           "\n"], "\n"),

        Expected = [ [1,2,3,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9] ],
        Got = bankocr:parse(Input),

        ?assertEqual(Expected,Got)
    end
  }.
