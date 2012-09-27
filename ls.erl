-module(ls).
%-include_lib("/usr/lib64/erlang/lib/kernel-2.15.1/include/file.hrl").
-include_lib("kernel/include/file.hrl").
-import(file, [list_dir/1, read_file_info/1]).
-import(io, [format/2]).
-export([main/0, main/1]).

main() ->
  main(["."]).

main(Args) ->
  Dir = if
    Args =:= [] -> ".";
    true        ->
      [H|_] = Args,
      H
  end,
  case list_dir(Dir) of
    {ok, List} ->
      io:format("~p~n", [length(List)]),
      render(Dir, List),
      ok;
    {error, _}  ->
      io:format("~p~n", ["No such file or directory"]),
      error
  end.

render(Dir, List) ->
  Len = max_length(List),
  lists:map(fun(File) ->
    Path = filename:join(Dir, File),
    Info = file_info(Path),
    if
      Info =/= error ->
        io:format(lists:concat(["~-", Len, "s ~p~n"]), [File, Info]);
      true -> nil
    end
  end, List).

max_length(List) ->
  lists:max(lists:map(fun(I) -> string:len(I) end, List)).

file_info(Path) ->
  case read_file_info(Path) of
    {ok, Facts} ->
      {Date, Time} = Facts#file_info.atime,
      [Facts#file_info.mode,
       Facts#file_info.size,
       erlang:tuple_to_list(Date), erlang:tuple_to_list(Time)];
    {error, _}  ->
      error
  end.
