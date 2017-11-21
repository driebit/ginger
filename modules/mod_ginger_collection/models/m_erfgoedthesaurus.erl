%% @doc A wrapper around the Erfgoedthesaurus API
-module(m_erfgoedthesaurus).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    concept/1,
    dbpedia_uris/1
]).

m_find_value(Uri, #m{value = undefined}, _Context) ->
    concept(Uri);
m_find_value(_Key, #m{value = _UnsupportedUrl}, _Context) ->
    undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.

%% @doc Look up a concept in the Erfgoedthesaurus by URI.
-spec concept(Uri :: binary()) -> m_rdf:rdf_resource() | undefined.
concept(<<"http://data.cultureelerfgoed.nl/semnet/", Id/binary>>) ->
    concept(<<"https://data.cultureelerfgoed.nl/term/id/cht/", Id/binary>>);
    %% BC for old Erfgoedthesaurus URIs
concept(<<"https://data.cultureelerfgoed.nl/term/id/cht", _/binary>> = Uri) ->
    case ginger_http_client:get(<<Uri/binary, ".jsonld">>) of
        %% Erfgoedthesaurus returns JSON-LD as a list
        [Item | _] ->
            ginger_json_ld:deserialize(Item);
        _ ->
            undefined
    end;
concept(_) ->
    undefined.

%% @doc Get DBPedia URI for an Erfgoedthesaurus concept.
-spec dbpedia_uris(binary()) -> [binary() | undefined].
dbpedia_uris(Uri) ->
    case concept(Uri) of
        undefined ->
            undefined;
        Concept ->
            Matches = m_rdf:objects(Concept, <<"http://www.w3.org/2004/02/skos/core#exactMatch">>) ++
                m_rdf:objects(Concept, <<"http://www.w3.org/2004/02/skos/core#closeMatch">>),
            lists:filter(fun m_dbpedia:is_dbpedia_uri/1, Matches)
    end.
