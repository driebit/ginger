-module(m_rdf).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-export([
    object/3,
    find/2,
    ensure_resource/2
]).

%% @doc Find a RDF resource by URI
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
            z_notifier:first(#rdf_get{uri=Url}, Context)
        end,
        Url,
        ?WEEK,
        Context
    ).

%% @doc Ensure URI is a resource in Zotonic.
%% @spec ensure_resource(Uri, Context) -> int()
ensure_resource(Uri, _Context) when is_integer(Uri) ->
    Uri;
ensure_resource(Uri, Context) ->
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
    
%% @doc Create non-authoritative RDF resource
%% @spec create_resource(string(), Context) -> Id
create_resource(Uri, Context) ->
    Props = [
        {name, z_string:to_name(Uri)},
        {category, rdf},
        {is_authoritative, false},
        {is_published, true},
        {uri, Uri}
    ],
    {ok, Id} = m_rsc_update:insert(Props, Context),
    Id.
    
%% @doc Is String a valid URI?
is_http_uri(String) ->
    {Scheme, _, _, _, _} = mochiweb_util:urlsplit(z_convert:to_list(String)),
    case Scheme of
        "http" -> true;
        "https" -> true;
        _ -> false
    end.

