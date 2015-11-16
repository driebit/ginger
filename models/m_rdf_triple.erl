-module(m_rdf_triple).

-export([
    insert/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

%% @doc Insert a triple, making sure no duplicates are created
-spec insert(#triple{}, #context{}) -> {ok, integer()} | {error, string()}.
insert(#triple{
    type=Type,
    subject=Subject,
    subject_props=SubjectProps,
    predicate=Predicate,
    object=Object,
    object_props=ObjectProps
}, Context) ->
    PredicateId = ensure_predicate(Predicate, Context),
    m_edge:insert(
        m_rdf:ensure_resource(Subject, SubjectProps, Context),
        PredicateId,
        m_rdf:ensure_resource(Object, ObjectProps, Context),
        Context
    ).

%% @doc Ensure predicate exists. If it doesn't yet exist, create it.
%% @spec ensure_predicate(Uri, Context) -> int()
-spec ensure_predicate(string(), #context{}) -> integer().
ensure_predicate(Uri, Context) ->
    %% Find predicate by URI
    case m_rsc:uri_lookup(Uri, Context) of
        undefined ->
            %% Fall back to predicate name (instead of URI)
            case m_predicate:get(Uri, Context) of
                undefined ->
                    %% predicate needs to be created
                    {ok, Id} = create_predicate(Uri, Context),
                    Id;
                PredicateProps ->
                    proplists:get_value(id, PredicateProps)
            end;
        Id -> Id
    end.

%% @doc Create RDF predicate
create_predicate(Uri, Context) ->
    Props = [
        {title, Uri},
        {name, z_string:to_name(Uri)},
        {uri, Uri},
        {category, predicate},
        {group, admins},
        {is_published, true},
        {visible_for, 0}
    ],
    case m_rsc_update:insert(Props, [{acl_check, false}], Context) of
        {ok, Id} ->
            m_predicate:flush(Context),
            {ok, Id};
        {error, Reason} ->
            {error, Reason}
    end.
