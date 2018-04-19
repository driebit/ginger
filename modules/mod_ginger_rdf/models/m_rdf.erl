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
    merge/2,
    object/3,
    objects/2,
    filter_subject/2,
    ensure_resource/2,
    ensure_resource/3,
    ensure_resource_edges/4,
    lookup_triple/2,
    to_triples/2
]).

-opaque rdf_resource() :: #rdf_resource{}.
-opaque triple() :: #triple{}.
-export_type([
    rdf_resource/0,
    triple/0
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
m_find_value(Predicate, #m{value = #rdf_resource{triples = Triples}}, Context) ->
    case lookup_triple(Predicate, Triples) of
        undefined -> undefined;
        #triple{object = Object} -> literal_object_value(Object, Context)
    end.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.

merge(#rdf_resource{triples = Triples1} = Rdf1, #rdf_resource{triples = Triples2}) ->
    Rdf1#rdf_resource{triples = Triples1 ++ Triples2}.

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
    ok = m_edge:replace(Subject, Predicate, Ids, Context).

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

        %% Site title is publisher
        publisher_triples(Context) ++

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

                                {true, [
                                    #triple{
                                        type = resource,
                                        predicate = PredicateUri,
                                        subject = m_rsc:p(Subject, uri, Context),
                                        object = m_rsc:p(Object, uri, Context)
                                    },

                                    %% Add literal triple with the edge's object
                                    %% title for convenience.
                                    #triple{
                                        predicate = <<?NS_DCTERMS, "title">>,
                                        subject = m_rsc:p(Object, uri, Context),
                                        object = #rdf_value{value = z_trans:trans(m_rsc:p(Object, title, Context), Context)}
                                    }
                                ]}
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
    rdf_resource(m_rsc:p(Id, uri, Context), Result).

-spec rdf_resource(binary(), [#triple{}]) -> #rdf_resource{}.
rdf_resource(SubjectUri, Triples) ->
    #rdf_resource{
        id = SubjectUri,
        triples = [with_subject(SubjectUri, Triple) || Triple <- Triples]
    }.

%% Each property can map to one or more triples
property_to_triples({_, <<>>}, _Props, _Context) ->
    %% Skip empty binary values
    [];
property_to_triples({_, undefined}, _Props, _Context) ->
    %% Skip undefined values
    [];
property_to_triples({address_city, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "locality">>, object = #rdf_value{value = Value}}
    ];
property_to_triples({address_country, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "country-name">>, object = #rdf_value{value = Value}}
    ];
property_to_triples({address_postcode, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "postal-code">>, object = #rdf_value{value = Value}}
    ];
property_to_triples({address_street_1, Value}, _Props, _Context) ->
    [
        #triple{predicate = <<?NS_VCARD, "street-address">>, object = #rdf_value{value = Value}}
    ];
property_to_triples({body, Value}, _Props, Context) ->
    %% TODO add support for multilingual properties
    [
        #triple{
            predicate = <<?NS_DCTERMS, "description">>,
            object = #rdf_value{value = z_html:strip(z_trans:trans(Value, Context))}
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
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({date_start, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "date">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({modified, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "modified">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({name_first, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_FOAF, "firstName">>,
            object = #rdf_value{value = Value}
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
            object = #rdf_value{value = Surname}
        }
    ];
property_to_triples({phone, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_FOAF, "phone">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({pivot_location_lat, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_GEO, "lat">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({pivot_location_lng, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_GEO, "long">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({publication_start, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "issued">>,
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({license, Value}, _Props, _Context) ->
    [
        #triple{
            type = resource,
            predicate = <<?NS_DCTERMS, "license">>,
            object = Value
        }
    ];
property_to_triples({subtitle, Value}, _Props, Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "alternative">>,
            object = #rdf_value{value = z_trans:trans(Value, Context)}
        }
    ];
property_to_triples({summary, Value}, _Props, Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "abstract">>,
            object = #rdf_value{value = z_trans:trans(Value, Context)}
        }
    ];
property_to_triples({title, Value}, _Props, Context) ->
    [
        #triple{
            predicate = <<?NS_DCTERMS, "title">>,
            object = #rdf_value{value = z_trans:trans(Value, Context)}
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

%% @doc Return publisher triples based on the site name and hostname
-spec publisher_triples(#context{}) -> [#triple{}].
publisher_triples(Context) ->
    Hostname = z_context:abs_url(<<"">>, Context),
    [
        #triple{
            type = resource,
            predicate = <<?NS_DCTERMS, "publisher">>,
            object = Hostname
        }
    ].

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

%% @doc Add subject URI to each triple that has none.
-spec with_subject(binary(), #triple{}) -> #triple{}.
with_subject(SubjectUri, #triple{subject = undefined} = Triple) ->
    Triple#triple{subject = SubjectUri};
with_subject(_SubjectUri, #triple{} = Triple) ->
    Triple.

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
    case m_rsc:get_visible(Category, Context) of
        undefined ->
            undefined;
        Props ->
            case proplists:get_value(uri, Props) of
                undefined ->
                    %% Fall back to parent category
                    get_category_uri(T, Context);
                Uri ->
                    Uri
            end
    end;
get_category_uri(Category, Context) ->
    get_category_uri(lists:reverse(m_category:is_a(Category, Context)), Context).

to_json_ld(Id, Context) ->
    jsx:encode(ginger_json_ld:serialize_to_map(to_triples(Id, Context))).

%% @doc Extract literal value from triple object(s).
-spec literal_object_value([#rdf_value{}] | #rdf_value{} | any(), #context{}) -> binary() | list().
literal_object_value(Objects, Context) when is_list(Objects) ->
    literal_object_value_translation(Objects, Context);
literal_object_value(#rdf_value{value = Value}, _Context) ->
    Value;
literal_object_value(Other, _Context) ->
    Other.

%% @doc Determine whether a given language matches the expected (or desired) language.
%%      E.g. given language <<"en-GB">> should match :en as well as <<"en">>.
-spec language_matches(binary(), atom() | binary()) -> boolean().
language_matches(LanguageGiven, LanguageExpected) when is_atom(LanguageExpected) ->
    language_matches(LanguageGiven, atom_to_binary(LanguageExpected, utf8));
language_matches(LanguageGiven, LanguageExpected) when is_binary(LanguageGiven), is_binary(LanguageExpected) ->
    case binary:match(LanguageGiven, LanguageExpected) of
        {0, _} ->
            true;
        _ ->
            false
    end;
language_matches(_, _) ->
    false.

%% @doc Select matching translations and untranslated values from a list of #rdf_value.
-spec literal_object_value_translation([#rdf_value{}] | any(), #context{}) -> binary() | list().
literal_object_value_translation([#rdf_value{}|_] = Objects, #context{} = Context) ->
    Language = z_context:language(Context),
    % First try to match the preferred language
    % nl as set language should match values like nl-NL
    { Translations, OtherValues } =
        lists:foldr(
            fun( Object, { Ts, OVs } ) ->
                case Object of
                    #rdf_value{value = V, language = undefined} ->
                        { Ts, [V|OVs] };
                    #rdf_value{value = _, language = _} ->
                        { [Object|Ts], OVs };
                    _ ->
                        { Ts, [Object|OVs] }
                end
            end,
            { [], [] },
            Objects
        ),
    Translated =
        case [V || #rdf_value{value = V, language = L} <- Translations, language_matches(L, Language)] of
            [] ->
                % Fall back to default language
                % Should we also see if we have a z_context:fallback_language()?
                DefaultLanguage = z_trans:default_language(Context),
                [V || #rdf_value{value = V, language = L} <- Translations, language_matches(L, DefaultLanguage)];
            Vs -> Vs
        end,
    % Include any untranslated values
    case Translated ++ OtherValues of
        [] ->
            undefined;
        [SingleValue] ->
            SingleValue;
        Values ->
            Values
    end;
literal_object_value_translation(Objects, _Context) ->
    Objects.
