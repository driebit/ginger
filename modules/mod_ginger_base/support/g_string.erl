%%%-------------------------------------------------------------------
%%% @author driebit <tech@driebit.nl>
%%% @copyright (C) 2019, driebit
%%% @doc
%%% Utility functions for operations on strings
%%% @end
%%%-------------------------------------------------------------------
-module(g_string).

%% API
-export([contains/2]).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Check if a string contains another string
-spec contains(list(), list()) -> boolean().
contains([], []) ->
    true;
contains(_, []) ->
    false;
contains(Pred, Str) ->
    case lists:prefix(Pred, Str) of
        true->
            true;
        false ->
            contains(Pred, lists:nthtail(1, Str))
    end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
