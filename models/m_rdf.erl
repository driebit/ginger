-module(m_rdf).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-export([
    object/3,
    link/4,
    find/2
]).

%% @doc Find an RDF resource by URI
%% @spec find(string(), Context) -> Id | undefined
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

%% @doc Fetch a RDF resource
rsc(Url, Context) ->
    %     case z_notifier:first(#rsc_property{id=Id, property=title, value=Title1}, Context) of
    z_depcache:memo(
        fun() ->
            z_notifier:first(#rdf_get{url=Url}, Context)
        end,
        Url,
        ?WEEK,
        Context
    ).
    
%% Create a RDF link between two resources
link(Subject, Predicate, Object, Context) ->
    %% Predicate must be an URL
    %% Subject and object can be either URL or internal Zotonic id

    %% Check if the predicate already exists in Zotonic
    PredicateId = case m_rsc:uri_lookup(Predicate, Context) of
        undefined ->
            %% predicate needs to be created
            {ok, Id} = create_predicate(Predicate, Context),
            Id;
        Id -> Id
    end,
    
    m_edge:insert(
        find_or_create_resource(Subject, Context), 
        PredicateId, 
        find_or_create_resource(Object, Context),
        Context
    ).

%% @doc Create non-authoritative RDF resource
%% @spec create_resource(string(), Context) -> Id
create_resource(Uri, Context) ->
    Props = [
        {title, Uri},
        {name, z_string:to_name(Uri)},
        {category, rdf},
        {is_authoritative, false},
        {is_published, true}
    ],
    {ok, Id} = m_rsc:insert(Props, Context),
    Id.
    
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
    case m_rsc:insert(Props, Context) of
        {ok, Id} -> 
            m_predicate:flush(Context),
            {ok, Id};
        {error, Reason} ->
            {error, Reason}
    end.
    
%% @doc Is String a valid URI?
is_http_uri(String) ->
    {Scheme, _, _, _, _} = mochiweb_util:urlsplit(String),
    case Scheme of
        "http" -> true;
        "https" -> true;
        _ -> false
    end.

find_or_create_resource(Uri, Context) ->
    case is_http_uri(Uri) of
        false ->
            m_rsc:rid(Uri, Context);
        true ->
            case find(Uri, Context) of
                undefined ->
                    create_resource(Uri, Context);
                Id -> Id
            end
    end.
