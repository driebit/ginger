%% @doc Functions that help with manage_schema data fixtures.
-module(schema).

-include_lib("zotonic.hrl").

-export([
    load/2,
    load/3,
    file/2,
    menu/3,
    reset/1,
    create_identity_if_not_exists/4,
    create_identity_if_not_exists/5,
    create_identity_type_if_not_exists/4,
    lorem/0
]).

%% @doc Load data model for a site
-spec load(#datamodel{}, #context{}) -> ok.
load(#datamodel{} = Datamodel, Context) ->
    load(z_context:site(Context), Datamodel).

%% @doc Load data model for a module
-spec load(module(), #datamodel{}, #context{}) -> ok.
load(Module, #datamodel{} = Datamodel, Context) ->
    z_datamodel:manage(Module, Datamodel, z_context:prune_for_spawn(Context)).

%% @doc Locate file in fixtures directory
-spec file(string(), #context{}) -> string().
file(Filename, Context) ->
    filename:join([z_path:site_dir(Context), "files/fixtures/", Filename]).

%% @doc Set items for a menu
-spec menu(m_rsc:resource(), list(), #context{}) -> ok.
menu(Menu, Items, Context) ->
    {ok, _Id} = mod_menu:set_menu(
        m_rsc:rid(Menu, Context),
        Items,
        z_acl:sudo(Context)
    ),
    ok.

%% @doc Compile and reset database schema
-spec reset(#context{}) -> ok.
reset(Site) when is_atom(Site) ->
    Context = z_context:new(Site),
    reset(Context);
reset(Context) when is_record(Context, context) ->
    z:compile(),
    z:flush(Context),
    z_module_manager:reinstall(z_context:site(Context), Context).

-spec create_identity_if_not_exists(atom(), string(), string(), #context{}) -> ok.
create_identity_if_not_exists(Name, Username, Password, Context) ->
    create_identity_if_not_exists(Name, Username, Password, [], Context).

%% Set username and password if not set before
-spec create_identity_if_not_exists(atom(), string(), string(), list(tuple()), #context{}) -> ok.
create_identity_if_not_exists(Name, Username, Password, Props, Context) ->
    Resource = m_rsc:rid(Name, Context),
    case m_identity:is_user(Resource, Context) of
        false ->
            %% Create new credentials
            case m_identity:lookup_by_username(Username, Context) of
                undefined ->
                    {ok, _IdentityId} = m_identity:insert_unique(Resource, username_pw, Username, Props, z_acl:sudo(Context)),
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


%% @doc Generate simple lorem ipsum text
-spec lorem() -> binary().
lorem() ->
    <<"<p>Lorem ipsum dolor sit amet, <b>consectetur adipiscing elit</b>. Praesent tincidunt <i>justo id dapibus</i> feugiat.</p>\n<h2>Aliquam</h2> <p>erat volutpat. Sed porttitor enim turpis, nec luctus erat scelerisque vitae. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec placerat lorem ac diam dapibus, sed aliquet velit efficitur. Fusce tempor lobortis luctus. Praesent a ultricies lectus. Nunc malesuada nunc et massa feugiat, bibendum placerat risus placerat. Vivamus gravida bibendum tellus. Aenean vel tristique ante. Proin tristique non lorem sit amet pretium. Suspendisse sit amet pellentesque felis. Aliquam erat volutpat. Maecenas risus libero, lobortis et sem a, consectetur vehicula leo. Fusce commodo mi nec urna placerat, id vestibulum eros ornare.">>.
