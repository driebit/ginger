%% @doc View model to search for GeoNames place names.
-module(m_geonames).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(uri, #m{value = undefined} = M, _Context) ->
    M#m{value = uri};
m_find_value(GeoNamesId, #m{value = uri}, _Context) ->
    mod_ginger_geonames:uri(GeoNamesId);
m_find_value({geo_lookup, Params}, #m{value = undefined}, Context) ->
    %% Search by coordinates.
    case proplists:get_value(id, Params) of
        undefined ->
            [];
        Id ->
            case geonames_lookup:reverse_lookup(Id, Context) of
                {error, no_geo} ->
                    [];
                Result ->
                    Result
            end
    end;
m_find_value({search, Params}, #m{value = undefined}, Context) ->
    %% Search by text query.
    case proplists:get_value(text, Params) of
        undefined ->
            [];
        Text ->
            geonames_client:search([{q, Text}], Context)
    end.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.
