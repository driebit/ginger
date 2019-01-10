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
    find_resource/2,
    merge/1,
    merge/2,
    object/3,
    objects/2,
    filter_subject/2,
    ensure_resource/2,
    ensure_resource/3,
    ensure_resource_edges/4,
    lookup_triple/2,
    to_triples/2,
    rdf_resource/2
]).

-opaque rdf_resource() :: #rdf_resource{}.
-opaque triple() :: #triple{}.
-type predicate() :: ginger_uri:uri().

-export_type([
    rdf_resource/0,
    triple/0,
    predicate/0
]).

m_find_value(#rdf_resource{} = Rdf, #m{value = undefined} = M, _Context) ->
    M#m{value = Rdf};

% Assume integer input is a RscId
m_find_value(RscId, #m{value = undefined} = M, Context) when is_integer(RscId) ->
    case m_rsc:p(RscId, is_authoritative, Context) of
        true ->
            %% Authoritative resource, so base RDF representation on internal data.
            to_json_ld(RscId, Context);
        false ->
            %% Non-authoritative resource, so base representation on external data.
            Uri = m_rsc:p_no_acl(RscId, uri, Context),
            m_find_value(Uri, M, Context)
    end;

% Assume other input is an Uri we need to lookup
m_find_value(undefined, #m{value = undefined}, _Context) ->
    undefined;
m_find_value(#{}, #m{value = undefined}, _Context) ->
    undefined;
m_find_value(Uri, #m{value = undefined} = M, Context) ->
    M#m{value = rsc(Uri, Context)};

m_find_value(id, #m{value = #rdf_resource{id = Id}}, _Context) ->
    Id;
m_find_value(uri, #m{value = #rdf_resource{id = Id}}, _Context) ->
    Id;
m_find_value(Predicate, #m{value = #rdf_resource{triples = Triples}}, _Context) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> undefined;
        #triple{object = Object} -> literal_object_value(Object)
    end.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.

%% @doc Merge a list of RDF resources, grouping them by their subject URIs.
-spec merge([rdf_resource()]) -> [rdf_resource()].
merge(RdfResources) ->
    maps:values(
        lists:foldl(
            fun(#rdf_resource{id = Uri} = Resource, Acc) ->
                case maps:get(Uri, Acc, undefined) of
                    undefined ->
                        Acc#{Uri => Resource};
                    Current ->
                        Acc#{Uri => merge(Current, Resource)}
                end
            end,
            #{},
            RdfResources
        )
    ).

-spec merge(rdf_resource(), rdf_resource) -> rdf_resource().
merge(#rdf_resource{triples = Triples1} = Rdf1, #rdf_resource{triples = Triples2}) ->
    Rdf1#rdf_resource{triples = lists:usort(Triples1 ++ Triples2)}.

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

%% @doc Find a RDF resource by URI or id
-spec find_resource(string(), #context{}) -> integer() | undefined.
find_resource(Uri, Context) when is_integer(Uri) ->
    m_rsc:rid(Uri, Context);
find_resource(Uri, Context) ->
    m_rsc:uri_lookup(z_sanitize:uri(Uri), Context).

%% @doc Ensure RDF resource or URI is a non-authoritative (pointer) resource in
%%      Zotonic.
ensure_resource(#rdf_resource{id = Uri} = Rdf, Context) ->
    Props = rdf_to_rsc_props(Rdf),
    ensure_resource(Uri, Props, Context);
ensure_resource(Uri, Context) when is_binary(Uri) ->
    ensure_resource(Uri, [], Context).

%% @doc Ensure URI or Id is a resource in Zotonic and update an existing resource
-spec ensure_resource(string(), list(), #context{}) -> integer() | {error, term()}.
ensure_resource(RscId, Props, Context) when is_integer(RscId) ->
    case find_resource(RscId, Context) of
        undefined ->
            {ok, Id} = m_rsc_update:insert(Props, Context),
            Id;
        Id ->
            {ok, Id} = m_rsc:update(Id, Props, Context),
            Id
    end;
ensure_resource(Uri, Props0, Context) ->
    case z_acl:is_allowed(use, mod_ginger_rdf, Context) of
        true ->
            % Make sure these props are set...
            % ... so that you can not insert non rdf resources this way.
            RequiredProps = [
                {category, rdf},
                {is_authoritative, false},
                {is_dependent, true}, %% remove resource when there are no longer edges to it
                {uri, Uri}
            ],
            Props1 = z_utils:props_merge(RequiredProps, Props0),

            AdminContext = z_acl:sudo(Context),

            case find_resource(Uri, Context) of
                undefined ->
                    DefaultProps = [
                        {is_published, true},
                        {content_group, rdf_content_group}
                    ],
                    Props2 = z_utils:props_merge(Props1, DefaultProps),

                    {ok, Id} = m_rsc_update:insert(Props2, AdminContext),
                    Id;
                Id ->
                    {ok, Id} = m_rsc:update(Id, Props1, AdminContext),
                    Id
            end;
        false ->
            {error, eacces}
    end.

%% @doc Ensure a Zotonic resource has edges to a set of external RDFs.
-spec ensure_resource_edges(m_rsc:resource(), atom(), [#rdf_resource{} | binary()], z:context()) -> ok.
ensure_resource_edges(Subject, Predicate, Rdfs, Context) ->
    Ids = lists:map(
        fun(Rdf) ->
            ensure_resource(Rdf, Context)
        end,
        Rdfs
    ),
    ok = m_edge:replace(Subject, Predicate, unique(Ids), Context).

%% @doc Derive Zotonic resource properties from RDF triples.
-spec rdf_to_rsc_props(#rdf_resource{}) -> proplists:proplist().
rdf_to_rsc_props(#rdf_resource{triples = Triples}) ->
    [
        {title, lookup_triple(title, Triples)}
    ].

%% @doc Fetch a RDF resource
rsc(Uri, Context) ->
    UriBin = z_convert:to_binary(Uri),
    z_depcache:memo(
        fun() ->
            z_notifier:foldl(#rdf_get{uri = UriBin}, #rdf_resource{}, Context)
        end,
        #rdf_resource{id = UriBin},
        ?WEEK,
        Context
    ).

%% @doc Export resource to a set of triples
-spec to_triples(integer(), #context{}) -> #rdf_resource{}.
to_triples(Id, Context) ->
    m_rdf_export:to_rdf(Id, Context).

-spec rdf_resource(binary(), [#triple{}]) -> #rdf_resource{}.
rdf_resource(SubjectUri, Triples) ->
    #rdf_resource{
        id = SubjectUri,
        triples = [with_subject(SubjectUri, Triple) || Triple <- Triples]
    }.

%% @doc Find all objects matching the predicate.
-spec objects(rdf_resource(), binary()) -> list().
objects(#rdf_resource{triples = Triples}, Predicate) ->
    MatchingTriples = lists:filter(
        fun(Triple) ->
            Triple#triple.predicate =:= Predicate
        end,
        Triples
    ),
    [Object || #triple{object = Object} <- MatchingTriples].

%% @doc Filter the resource's triples by subject.
-spec filter_subject(rdf_resource(), binary()) -> [triple()].
filter_subject(#rdf_resource{triples = Triples}, Subject) ->
    lists:filter(
        fun(#triple{subject = TripleSubject}) ->
            TripleSubject =:= Subject
        end,
        Triples
    ).

%% @doc Shortcuts for namespaced RDF properties
lookup_triple(uri, Triples) ->
    lookup_triples(
        [
            <<"http://xmlns.com/foaf/0.1/page">>
        ],
        Triples
    );
lookup_triple(title, Triples) ->
    lookup_triples(
        [
            <<"http://purl.org/dc/terms/title">>,
            <<?NS_RDF_SCHEMA, "label">>,
            <<"http://nl.dbpedia.org/property/naam">>,
            <<"http://purl.org/dc/elements/1.1/title">> %% legacy
        ],
        Triples
    );
lookup_triple(abstract, Triples) ->
    lookup_triples(
        [
            <<?NS_DCTERMS, "abstract">>,
            <<?NS_DBPEDIA_OWL, "abstract">>
        ],
        Triples
    );
lookup_triple(description, Triples) ->
    lookup_triples(
        [
            <<"http://purl.org/dc/terms/description">>,
            <<"http://purl.org/dc/elements/1.1/description">> %% legacy
        ],
        Triples
    );
lookup_triple(type, Triples) ->
    lookup_triple(
        [
            <<?NS_RDF, "type">>,
            <<"http://www.europeana.eu/schemas/edm/type">>
        ],
        Triples
    );
lookup_triple(thumbnail, Triples) ->
    lookup_triples(
        [
            <<"http://xmlns.com/foaf/0.1/thumbnail">>,
            <<?NS_DBPEDIA_OWL, "thumbnail">>,
            <<"http://schema.org/image">>,
            <<"http://www.europeana.eu/schemas/edm/object">>,
            <<"http://www.europeana.eu/schemas/edm/isShownBy">>
        ],
        Triples
    );
lookup_triple(rights, Triples) ->
    lookup_triples(
        [
            <<"http://www.europeana.eu/schemas/edm/rights">>,
            <<"http://purl.org/dc/terms/rights">>
        ],
        Triples
    );
lookup_triple(spatial, Triples) ->
    lookup_triples(
        [
            <<"http://purl.org/dc/terms/spatial">>,
            <<"http://purl.org/dc/elements/1.1/spatial">>
        ],
        Triples
    );
lookup_triple(date, Triples) ->
    case lookup_triples(
        [
            <<"http://purl.org/dc/terms/date">>,
            <<"http://purl.org/dc/elements/1.1/date">> % legacy
        ],
        Triples
    ) of
        undefined ->
            undefined;
        #triple{object = Object} = Triple ->
            %% Replace object with date that Zotonic can work with
            [Start|_End] = Object,
            [Y, M, D] = binary:split(Start, <<"-">>, [global]),
            Triple#triple{object = {z_convert:to_integer(Y), z_convert:to_integer(M), z_convert:to_integer(D)}}
    end;
lookup_triple(Predicate, Triples) when is_list(Predicate) ->
    %% Predicates are stored as binaries
    lookup_triple(z_convert:to_binary(Predicate), Triples);
lookup_triple(Predicate, Triples) ->

    %% Find the requested predicate
    FoundTriples = lists:filter(
        fun(Triple) ->
            Triple#triple.predicate == Predicate
        end,
        Triples
    ),

    case FoundTriples of
        [] -> undefined;
        [Triple] -> Triple;
        [Triple | _] ->
            % If multiple triples are found with the same predicate..
            % .. put the objects in a list for use in templates
            Objects = [Object || #triple{object = Object} <- FoundTriples],
            Triple#triple{object = Objects}
    end.

lookup_triples([Predicate | Rest], Triples) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> lookup_triples(Rest, Triples);
        Triple -> Triple
    end;
lookup_triples([], _Triples) ->
    undefined.

%% @doc Add subject URI to each triple that has none.
-spec with_subject(binary(), #triple{}) -> #triple{}.
with_subject(SubjectUri, #triple{subject = undefined} = Triple) ->
    Triple#triple{subject = SubjectUri};
with_subject(_SubjectUri, #triple{} = Triple) ->
    Triple.

to_json_ld(Id, Context) ->
    jsx:encode(ginger_json_ld:serialize_to_map(to_triples(Id, Context))).

%% @doc Extract literal value from triple object(s).
-spec literal_object_value([#rdf_value{}] | #rdf_value{} | any()) -> binary() | list().
literal_object_value(Objects) when is_list(Objects) ->
    [literal_object_value(Object) ||  Object <- Objects];
literal_object_value(#rdf_value{value = Value}) ->
    Value;
literal_object_value(Other) ->
    Other.

-spec unique([any()]) -> [any()].
unique(Ids) ->
    sets:to_list(sets:from_list(Ids)).
