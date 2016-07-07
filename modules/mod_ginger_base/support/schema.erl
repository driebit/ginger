%% @doc Functions that help with manage_schema data fixtures.
-module(schema).

-include_lib("zotonic.hrl").

-export([
    load/2,
    file/2,
    reset/1,
    create_identity_if_not_exists/4,
    create_identity_type_if_not_exists/4
]).

load(Datamodel = #datamodel{}, Context) ->
    z_datamodel:manage(
        z_context:site(Context),
        Datamodel, z_context:prune_for_spawn(Context)
    ).

%% @doc Locate file in fixtures directory
-spec file(string(), #context{}) -> string().
file(Filename, Context) ->
    filename:join([z_path:site_dir(Context), "files/fixtures/", Filename]).

%% @doc Compile and reset database schema
-spec reset(#context{}) -> ok.
reset(Site) when is_atom(Site) ->
    Context = z_context:new(Site),
    reset(Context);
reset(Context) when is_record(Context, context) ->
    z:compile(),
    z:flush(Context),
    z_module_manager:reinstall(z_context:site(Context), Context).

%% Set username and password if not set before
-spec create_identity_if_not_exists(atom(), string(), string(), #context{}) -> ok.
create_identity_if_not_exists(Name, Username, Password, Context) ->
    Resource = m_rsc:rid(Name, Context),
    case m_identity:is_user(Resource, Context) of
        false ->
            %% Create new credentials
            case m_identity:lookup_by_username(Username, Context) of
                undefined ->
                    ok = m_identity:set_username_pw(Resource, Username, Password, z_acl:sudo(Context));
                _ ->
                    %% Another user already exists with the username, so do nothing
                    ok
            end;
        true ->
            %% The user already has credentials, so don't change them
            ok
    end.

create_identity_type_if_not_exists(Name, Type, Key, Context) ->
    Resource = m_rsc:rid(Name, Context),
    case m_identity:get_rsc_by_type(Resource, Type, Context) of
        [] ->
            m_identity:insert_unique(Resource, Type, Key, Context);
        _ ->
            ok
    end.
