-module(m_ginger_admin_info).
-mod_depends([mod_admin]).
-behaviour(gen_model).

-export([m_find_value/3,
         m_to_list/2, m_value/2,
         git_ginger_info/0, erlang_info/0, git_zotonic_info/0]).

-include_lib("zotonic.hrl").


m_value(T, _Context) ->
    T.

m_find_value(git_zotonic_info, #m{value=undefined}, _) ->
    git_zotonic_info();
m_find_value(git_ginger_info, #m{value=undefined}, _) ->
    git_ginger_info();
m_find_value(erlang_info, #m{value=undefined}, _) ->
    erlang_info();
m_find_value(directory_info, #m{value=undefined}, _) ->
    directory_info();


m_to_list(_,_) ->
    [].

directory_info() ->
    {ok, Path} = file:get_cwd(),
    Path.

erlang_info() ->
    erlang:system_info(system_version).

git_zotonic_info() ->
    case os:find_executable("git") of
        false -> "Could not find Git";
        _Path -> os:cmd("(cd ../zotonic; git describe --tags)")
    end.

git_ginger_info() ->
    case os:find_executable("git") of
        false -> "Could not find Git";
        _Path -> os:cmd("(cd ../ginger; git describe --tags)")
    end.

