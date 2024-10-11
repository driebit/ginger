-module(m_rdf_triple).

-behaviour(gen_model).

-export([
    find/2,
    insert/2,
    m_find_value/3,
    m_to_list/2,
    m_value/2,

    remove_empty/1
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

m_find_value([#triple{} = Triple], #m{value=undefined} = M, _Context) ->
    M#m{value=Triple};
m_find_value(subject, #m{value=#triple{}=Triple}, _Context) ->
    Triple#triple.subject;
m_find_value(id, #m{value=undefined}, _Context) ->
    fun(Subject, _IdContext) ->
        fun(Predicate, _PredContext) ->
            fun(Object, Context) ->
                find(#triple{subject=Subject, predicate=Predicate, object=Object}, Context)
            end
        end
    end;
m_find_value(One, Two, _Context) ->
    ?DEBUG(One),
    ?DEBUG(Two).

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.

%% @doc Find a triple in the site's database
-spec find(#triple{}, #context{}) -> integer() | undefined.
find(#triple{subject=Subject, predicate=Predicate, object=Object}, Context) ->
    case m_rdf:find_resource(Subject, Context) of
        undefined ->
            undefined;
        SubjectId ->
            case m_rdf:find_resource(Object, Context) of
                undefined ->
                    undefined;
                ObjectId ->
                    case find_predicate(Predicate, Context) of
                        undefined ->
                            undefined;
                        PredicateId ->
                            m_edge:get_id(SubjectId, PredicateId, ObjectId, Context)
                    end
            end
    end.

%% @doc Insert a triple, making sure no duplicates are created
-spec insert(#triple{}, #context{}) -> {ok, integer()} | {error, term()}.
insert(#triple{
    type=_Type,
    subject=Subject,
    subject_props=SubjectProps,
    predicate=Predicate,
    object=Object,
    object_props=ObjectProps
}, Context) ->
    SubjectId = m_rdf:ensure_resource(Subject, SubjectProps, Context),
    PredicateId = ensure_predicate(Predicate, Context),
    ObjectId = m_rdf:ensure_resource(Object, ObjectProps, Context),
    case {SubjectId, PredicateId, ObjectId} of
        {SubjectId, PredicateId, ObjectId}
            when is_integer(SubjectId), is_integer(PredicateId), is_integer(ObjectId) ->
            m_edge:insert(
                SubjectId,
                PredicateId,
                ObjectId,
                Context
            );
        _ ->
            {error, eacces}
    end.


%% @doc Ensure predicate exists. If it doesn't yet exist, create it.
-spec ensure_predicate(string(), #context{}) -> integer().
ensure_predicate(Uri, Context) ->
    case find_predicate(Uri, Context) of
        undefined ->
            {ok, Id} = create_predicate(Uri, Context),
            Id;
        Id ->
            Id
    end.

%% @doc Find predicate by URI
-spec find_predicate(string(), #context{}) -> integer() | undefined.
find_predicate(UriOrName, Context) ->
    case m_rsc:uri_lookup(UriOrName, Context) of
        undefined ->
            %% Fall back to predicate name (instead of URI)
            case m_predicate:name_to_id(UriOrName, Context) of
                {ok, Id} ->
                    Id;
                _ ->
                    %% predicate needs to be created
                    undefined
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


% Removes all empty triples, recursively, from an 'rdf_resource', a 'triple' or
% a list of either; returns any other value unaltered.
% Note: the type of the output is always the same as the input's.
remove_empty(List) when is_list(List) ->
    % First remove the empty triples from the resources/triples in the list:
    NewList = lists:map(fun remove_empty/1, List),
    % Then filter the items in the list themselves:
    [Item || Item <- NewList, not is_empty(Item)];
remove_empty(Triple) when is_record(Triple, triple) ->
    NewObject = remove_empty(Triple#triple.object),
    Triple#triple{object=NewObject};
remove_empty(Resource) when is_record(Resource, rdf_resource) ->
    NewTriples = remove_empty(Resource#rdf_resource.triples),
    Resource#rdf_resource{triples=NewTriples};
remove_empty(Other) ->
    Other.

% A triple is considered empty if it doesn't add any new information, aka iff:
% 1. its object is empty (see 'is_empty_object')
% 2. there are no 'subject_props' nor 'object_props'
-spec is_empty(rdf:triple()) -> boolean().
is_empty(#triple{object = Object, subject_props = [], object_props = []}) ->
    is_empty_object(Object);
is_empty(_) ->
    false.

% A triple's object is considered empty if it doesn't add any new information, aka iff:
% 1. it's an empty URI/binary value
% 2. it's an 'rdf_value' whose 'value' is itself an empty object
-spec is_empty_object(ginger_uri:uri() | #rdf_value{} | #rdf_resource{}) -> boolean().
is_empty_object(Value) when is_binary(Value) ->
    z_utils:is_empty(Value);
is_empty_object(#rdf_value{value = Value}) ->
    is_empty_object(Value);
is_empty_object(_) ->
    false.
