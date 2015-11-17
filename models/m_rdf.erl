%% @doc RDF view model that consists of one or more triples
%% @author David de Boer <david@driebit.nl>
-module(m_rdf).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    find/2,
    object/3,
    ensure_resource/3
]).

m_find_value(#rdf_resource{} = Rdf, #m{value = undefined} = M, _Context) ->
    M#m{value = Rdf};
m_find_value(id, #m{value = #rdf_resource{id = Id}}, _Context) ->
    Id;
m_find_value(uri, #m{value = #rdf_resource{id = Id}}, _Context) ->
    Id;
m_find_value(Predicate, #m{value = #rdf_resource{id = _Id, triples = Triples}}, _Context) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> undefined;
        Triple -> Triple#triple.object
    end.

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.

%% @doc Find a RDF resource by URI
-spec find(string(), #context{}) -> integer() | undefined.
find(Uri, Context) ->
    m_rsc:uri_lookup(Uri, Context).

%% @doc Fetch an object from a RDF resource
object(Url, Predicate, Context) ->
    %% Check depcache
    Value = case z_depcache:get(Url, Predicate, Context) of
                {ok, V} ->
                    %% Todo: check if depcache will expire soon, then queue write-behind
                    %% refresh.
                    V;
                undefined ->
                    %% Retrieve from remote host
                    rsc(Url, Context)
            end,
    Value.

%% @doc Ensure URI is a resource in Zotonic.
-spec ensure_resource(string(), list(), #context{}) -> integer().
ensure_resource(Uri, _Props, _Context) when is_integer(Uri) ->
    Uri;
ensure_resource(Uri, Props, Context) ->
    case is_http_uri(Uri) of
        false ->
            m_rsc:rid(Uri, Context);
        true ->
            case find(Uri, Context) of
                undefined ->
                    create_resource(Uri, Props, Context);
                Id ->
                    {ok, Id} = m_rsc_update:update(Id, Props, Context),
                    Id
            end
    end.

%% @doc Create non-authoritative RDF resource
-spec create_resource(string(), list(), #context{}) -> integer().
create_resource(Uri, Props, Context) ->
    AllProps = [
        {name, z_string:to_name(Uri)},
        {category, rdf},
        {is_authoritative, false},
        {is_dependent, true}, %% remove resource when it has no edges to it anymore
        {is_published, true},
        {uri, Uri}
    ] ++ Props,
    {ok, Id} = m_rsc_update:insert(AllProps, Context),
    Id.

%% @doc Is String a valid URI?
-spec is_http_uri(string()) -> boolean().
is_http_uri(String) ->
    {Scheme, _, _, _, _} = mochiweb_util:urlsplit(z_convert:to_list(String)),
    case Scheme of
        "http" -> true;
        "https" -> true;
        _ -> false
    end.

%% @doc Fetch a RDF resource
rsc(Url, Context) ->
    %     case z_notifier:first(#rsc_property{id=Id, property=title, value=Title1}, Context) of
    z_depcache:memo(
        fun() ->
            z_notifier:first(#rdf_get{uri = Url}, Context)
        end,
        Url,
        ?WEEK,
        Context
    ).

lookup_triple([Predicate | Rest], Triples) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> lookup_triple(Rest, Triples);
        Triple -> Triple
    end;
lookup_triple([], _Triples) ->
    undefined;
%% @doc Shortcuts for namespaced RDF properties
lookup_triple(uri, Triples) ->
    lookup_triple(
        [
            <<"http://xmlns.com/foaf/0.1/page">>
        ],
        Triples
    );
lookup_triple(title, Triples) ->
    lookup_triple(
        [
            <<"http://purl.org/dc/elements/1.1/title">>
        ],
        Triples
    );
lookup_triple(description, Triples) ->
    lookup_triple(
        [
            <<"http://purl.org/dc/elements/1.1/description">>
        ],
        Triples
    );
lookup_triple(type, Triples) ->
    lookup_triple(
        [
            <<"http://www.europeana.eu/schemas/edm/type">>
        ],
        Triples
    );
lookup_triple(thumbnail, Triples) ->
    lookup_triple(
        [
            <<"http://xmlns.com/foaf/0.1/thumbnail">>,
            <<"http://www.europeana.eu/schemas/edm/isShownBy">>,
            <<"http://schema.org/image">>,
            <<"http://www.europeana.eu/schemas/edm/object">>
        ],
        Triples
    );
lookup_triple(rights, Triples) ->
    lookup_triple(
        [
            <<"http://www.europeana.eu/schemas/edm/rights">>
        ],
        Triples
    );
lookup_triple(Predicate, Triples) ->
    %% Find the requested predicate
    case lists:dropwhile(
        fun(Triple) ->
            Triple#triple.predicate /= Predicate
        end,
        Triples
    ) of
        [] -> undefined;
        [Triple | _] -> Triple
    end.
