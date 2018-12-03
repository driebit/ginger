%% @doc View model to search for GeoNames place names.
-module(m_geonames).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value({geo_lookup, Params}, #m{value = undefined}, Context) ->
    case proplists:get_value(id, Params) of
        undefined ->
            %% coordinates search
            undefined;
        Id ->
            case geonames_lookup:reverse_lookup(Id, Context) of
                {error, no_geo} ->
                    [];
                Result ->
                    Result
            end
    end;
m_find_value(A, #m{value = Params}, Context) ->
    ?DEBUG(A),
    undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.
