-module(bankocr_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, lookup_char/1, parse/1, valid/1, prepare_output/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  bankocr_sup:start_link().

stop(_State) ->
  ok.

lookup_char(Char) ->
  Lookup = [
    {" _ | ||_|", 0}, {"     |  |", 1},
    {" _  _||_ ", 2}, {" _  _| _|", 3},
    {"   |_|  |", 4}, {" _ |_  _|", 5},
    {" _ |_ |_|", 6}, {" _   |  |", 7},
    {" _ |_||_|", 8}, {" _ |_| _|", 9}],

  hd([V || {C,V} <- Lookup, C =:= Char]).

que_for_minus_one(-1) -> "?";
que_for_minus_one(X) -> X.

prepare_output(C) ->
  Valid = valid(C),
  HasIll = lists:any( fun(X) -> X =:= -1 end, C ),
  AsString = lists:concat([que_for_minus_one(X) || X <- C]),

  case Valid of
    true -> AsString;
    false ->
      case HasIll of
        true -> string:concat(AsString," ILL");
        false -> string:concat(AsString," ERR")
      end
  end.

valid(C) ->
  Adds = [lists:nth(X,C)*(X+1) || X <- lists:seq(1,9), lists:nth(X,C) >= 0],
  lists:foldl(fun(X, Sum) -> X + Sum end, 0, Adds) rem 11 =:= 0.

parse(Input) ->
  parsep(string:tokens(Input,"\n"),[]).

parsep([],Acc) ->
  Acc;

parsep(T,Acc) ->
  {H,R} = lists:split(3, T),
  parsep(R, Acc ++ [parse_row_p(H, [])]).

parse_row_p(Row,Acc) ->
  case length(lists:nth(1,Row)) of
    0 ->
      Acc;
    _ ->
      TopRow = string:sub_string(lists:nth(1,Row),1,3),
      MiddleRow = string:sub_string(lists:nth(2,Row),1,3),
      BottomRow = string:sub_string(lists:nth(3,Row),1,3),
      Value = lookup_char(lists:concat([TopRow,MiddleRow,BottomRow])),

      TopRest = string:sub_string(lists:nth(1,Row),4),
      MiddleRest = string:sub_string(lists:nth(2,Row),4),
      BottomRest = string:sub_string(lists:nth(3,Row),4),
      Rest = lists:append([[TopRest],[MiddleRest],[BottomRest]]),

      parse_row_p(Rest, Acc ++ [Value])
  end.

