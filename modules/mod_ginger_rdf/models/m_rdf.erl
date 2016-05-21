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
    object/3,
    ensure_resource/3,
    lookup_triple/2,
    to_triples/2
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
    m_rsc:uri_lookup(Uri, Context).

%% @doc Ensure URI is a resource in Zotonic and update an existing resource
-spec ensure_resource(string(), list(), #context{}) -> integer().
ensure_resource(Uri, Props, Context) ->
    case find_resource(Uri, Context) of
        undefined ->
            create_resource(Uri, Props, Context);
        Id ->
            {ok, Id} = m_rsc:update(Id, Props, Context),
            Id
    end.

%% @doc Create non-authoritative RDF resource
-spec create_resource(string(), list(), #context{}) -> integer().
create_resource(Uri, Props, Context) ->
    AllProps = [
        {category, rdf},
        {is_authoritative, false},
        {is_dependent, true}, %% remove resource when there are no longer edges to it
        {is_published, true},
        {uri, Uri}
    ] ++ Props,
    {ok, Id} = m_rsc_update:insert(AllProps, Context),
    Id.

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

%% @doc Export resource to a set of triples
-spec to_triples(integer(), #context{}) -> #rdf_resource{}.
to_triples(Id, Context) ->
    Props = case m_rsc:get_visible(Id, Context) of
		undefined -> [];
		VisibleProps -> VisibleProps
	end,

    Triples = lists:flatten(
        %% Resource properties
        lists:filtermap(
            fun(Prop) ->
                case property_to_triples(Prop, Props, Context) of
                    [] ->
                        false;
                    PropTriples ->
                        {true, PropTriples}
                end
            end,
            Props
        ) ++
        %% Outgoing resource edges
        lists:filtermap(
            fun({Key, Edges}) ->
                Predicate = m_predicate:get(Key, Context),
                case proplists:get_value(uri, Predicate) of
                    undefined ->
                        false;
                    PredicateUri ->
                        {true, lists:filtermap(
                            fun(Edge) ->
                                Subject = proplists:get_value(subject_id, Edge),
                                Object = proplists:get_value(object_id, Edge),

                                {true, #triple{
                                    type = resource,
                                    predicate = PredicateUri,
                                    subject = m_rsc:p(Subject, uri, Context),
                                    object = m_rsc:p(Object, uri, Context)
                                }}
                            end,
                            Edges
                        )}
                end
            end,
            m_edge:get_edges(Id, Context)
        )
    ),

    %% Find thumbnail
    WithThumbnail =
        with_original_media(Id, with_thumbnail(Id, Triples, Context), Context),

    Result = z_notifier:foldr(#rsc_to_rdf{id = Id}, WithThumbnail, Context),

    #rdf_resource{id = m_rsc:p(Id, uri, Context), triples = Result}.

%% Each property can map to one or more triples
property_to_triples({_, <<>>}, _Props, _Context) ->
    %% Skip empty binary values
    [];
property_to_triples({_, undefined}, _Props, _Context) ->
    %% Skip undefined values
    [];
property_to_triples({address_city, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "locality">>, object = Value}
    ];
property_to_triples({address_country, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "country-name">>, object = Value}
    ];
property_to_triples({address_postcode, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "postal-code">>, object = Value}
    ];
property_to_triples({address_street_1, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "street-address">>, object = Value}
    ];
property_to_triples({body, Value}, _Props, Context) ->
    %% TODO add support for multilingual properties
    [
        #triple{
            predicate = <<?NS_DCTERMS, "description">>,
            object = z_html:strip(z_trans:trans(Value, Context))
        }
    ];
property_to_triples({category_id, Value}, _Props, Context) ->
    case get_category_uri(Value, Context) of
        undefined ->
            [];
        Uri ->
            [
                #triple{
                    type = resource,
                    predicate = <<?NS_RDF, "type">>,
                    object = Uri
                }
            ]
    end;
property_to_triples({created, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "created">>,
            object = Value
        }
    ];
property_to_triples({date_start, Value}, _Props, _Context) ->
    [
        #triple{
        predicate = <<?NS_DCTERMS, "date">>,
        object = Value
        }
    ];
property_to_triples({modified, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "modified">>,
            object = Value
        }
    ];
property_to_triples({name_first, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_FOAF, "firstName">>,
            object = Value
        }
    ];
property_to_triples({name_surname, Value}, Props, _Context) ->
    Surname = case proplists:get_value(name_surname_prefix, Props) of
        undefined ->
            Value;
        <<>> ->
            Value;
        Prefix ->
            iolist_to_binary([Prefix, <<" ">>, Value])
    end,
    [
        #triple{
            predicate = <<?NS_FOAF, "familyName">>,
            object = Surname
        }
    ];
property_to_triples({phone, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_FOAF, "phone">>,
            object = [<<"tel:">>, Value]
        }
    ];
property_to_triples({pivot_location_lat, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_GEO, "lat">>,
            object = Value
        }
    ];
property_to_triples({pivot_location_lng, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_GEO, "long">>,
            object = Value
        }
    ];
property_to_triples({publication_start, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "issued">>,
            object = Value
        }
    ];
property_to_triples({summary, Value}, _Props, Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "abstract">>,
            object = z_trans:trans(Value, Context)
        }
    ];
property_to_triples({title, Value}, _Props, Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "title">>,
            object = z_trans:trans(Value, Context)
        }
    ];
property_to_triples({website, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_FOAF, "homepage">>,
            object = Value
        }
    ];
property_to_triples({_Prop, _Val}, _, _) ->
    [].

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
            <<"http://purl.org/dc/elements/1.1/title">> %% legacy
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
            <<"http://www.europeana.eu/schemas/edm/type">>
        ],
        Triples
    );
lookup_triple(thumbnail, Triples) ->
    lookup_triples(
        [
            <<"http://xmlns.com/foaf/0.1/thumbnail">>,
            <<"http://www.europeana.eu/schemas/edm/isShownBy">>,
            <<"http://schema.org/image">>,
            <<"http://www.europeana.eu/schemas/edm/object">>
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
    case lists:dropwhile(
        fun(Triple) ->
            Triple#triple.predicate /= Predicate
        end,
        Triples
    ) of
        [] -> undefined;
        [Triple | _] -> Triple
    end.

lookup_triples([Predicate | Rest], Triples) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> lookup_triples(Rest, Triples);
        Triple -> Triple
    end;
lookup_triples([], _Triples) ->
    undefined.

%% @doc Try to media triples and add them
-spec with_thumbnail(integer(), list(), #context{}) -> list().
with_thumbnail(Id, Triples, Context) ->
    maybe_add_media(
        fun() ->
            z_media_tag:url(Id, [{mediaclass, <<"foaf-thumbnail">>}, {use_absolute_url, true}], Context)
        end,
        <<?NS_FOAF, "thumbnail">>,
        Triples
    ).

%% @doc Try to find media triples and add them
-spec with_original_media(integer(), list(), #context{}) -> list().
with_original_media(Id, Triples, Context) ->
    maybe_add_media(
        fun() ->
            z_media_tag:url(Id, [{use_absolute_url, true}], Context)
        end,
        <<?NS_FOAF, "depiction">>,
        Triples
    ).

maybe_add_media(Fun, Predicate, Triples) ->
    case Fun() of
        {ok, MediaUrl} ->
            Triples ++ [#triple{
                type = resource,
                predicate = Predicate,
                object = MediaUrl
            }];
        {error, _} ->
            Triples
    end.

%% @doc Get category URI, starting at the most specific category and falling
%%      back to parent categories
get_category_uri([], _Context) ->
    undefined;
get_category_uri([Category|T], Context) ->
    %% Don't use m_rsc:p(Id, uri, Context) as that will return all URIs, even
    %% including generated ones (http://site.com/id/123). We only want to return
    %% a URI if it has been set explicitly.
    Props = m_rsc:get_visible(Category, Context),
    case proplists:get_value(uri, Props) of
        undefined ->
            %% Fall back to parent category
            get_category_uri(T, Context);
        Uri ->
            Uri
    end;
get_category_uri(Category, Context) ->
    get_category_uri(lists:reverse(m_category:is_a(Category, Context)), Context).
